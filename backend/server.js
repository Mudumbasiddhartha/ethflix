const Koa = require('koa');
const Router = require('@koa/router');
const cors = require('@koa/cors');
const ethers = require('ethers');
const PaymentProcessor = require('../build/contracts/PaymentProcessor.json');
const { Payment } = require('./db.js');
const {koaBody } = require('koa-body');

const app = new Koa();
app.use(koaBody());
const router = new Router();

const items = {
    '1': {id: 1, url: 'http://UrlToDownloadItem1'},
    '2': {id: 2, url: 'http://UrlToDownloadItem2'}
};


//homepage
router.get('/', (ctx, next) => {
  ctx.body = 'Hello World!';
});

//generate a paymentId for purchage
router.get('/api/getPaymentId/:itemId', async (ctx, next) => {
  //1. generate paymentId randomly
  const paymentId = (Math.random() * 10000).toFixed(0);
  //2. save paymentId + itemId in mongo 
    await Payment.create({
    id: paymentId,
    itemId: ctx.params.itemId, 
    paid: false
    });
  //3. return paymentId to sender
    ctx.body = {
    paymentId
    }
});

//get the url to download an item purchased
router.get('/api/getItemUrl/:paymentId', async (ctx, next) => {
  //1. verify paymentId exist in db and has been paid
    const payment = await Payment.findOne({id: ctx.params.paymentId});
    console.log(ctx.params.paymentId);
    console.log(payment);
    //2. return url to download item
    if(payment && payment.paid === true) {
        ctx.body = {
        url: items[payment.itemId].url
        };
    } else {
        console.log('here');
        ctx.body = {
        url: ''
        };
    }
});
duration= 0;
router.post('/api/storeDuration/:duration', async (ctx, next) => {
    const formdata = ctx.request.body;
    console.log(formdata);
    duration = ctx.params.duration;
    console.log(duration);
    ctx.body = {
        status: 'success',
        message: 'duration stored'
    };
});
router.get('/api/getDuration', async (ctx, next) => {
    ctx.body = {
        duration : duration
    }
}
);


router.post('/api/pay', async (ctx, next) => {
    const {paymentId, paymentToken} = ctx.request.body;
    const url = `http://localhost:4000/api/getItemUrl/${paymentId}`;
    const provider = new ethers.providers.JsonRpcProvider('http://localhost:7545');
    const signer = provider.getSigner();
    const paymentProcessor = new ethers.Contract(
        PaymentProcessor.networks['5777'].address,
        PaymentProcessor.abi,
        signer
    );
    const payment = await Payment.findOne({id: paymentId});
    if(payment && payment.paid === false) {
        const tx = await paymentProcessor.pay(paymentId, paymentToken, url);
        await tx.wait();
        ctx.body = {
            status: 'success',
            message: 'payment done'
        };
    } else {
        ctx.body = {
            status: 'error',
            message: 'payment already made or paymentId does not exist'
        };
    }
});

app
    .use(cors())
    .use(router.routes())
    .use(router.allowedMethods());



app.listen(4000, () => {
    console.log('Server running on port 4000');
    //keep debug mode on 

});

const listenToEvents = () => {
    const provider = new ethers.providers.JsonRpcProvider('http://localhost:7545');
    const networkId = '5777';
    //when connecting to mainnet or public testnets, use this instead
    //const provider = ethers.providers.getDefaultProvider('mainnet | kovan | etc..');
    //const networkId = '1'; //mainnet 
    //const networkId = '42'; //kovan 

    const paymentProcessor = new ethers.Contract(
        PaymentProcessor.networks[networkId].address,
        PaymentProcessor.abi,
        provider
    );
    paymentProcessor.on('PaymentDone', async (payer, amount, paymentId, date) => {
        console.log(`New payment received: 
        from ${payer} 
        amount ${amount.toString()} 
        paymentId ${paymentId} 
        date ${(new Date(date.toNumber() * 1000)).toLocaleString()}
        `);
        const payment = await Payment.findOne({id: paymentId.toString()});
        if(payment) {
            payment.paid = true;
            await payment.save();
        }
    });
};

listenToEvents();