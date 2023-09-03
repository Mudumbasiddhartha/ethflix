const mongoose = require("mongoose");
mongoose.connect(
    'mongodb+srv://mango-user:87654321@cluster0.v6uj1.mongodb.net/?retryWrites=true&w=majority',
    {useNewUrlParser: true, useUnifiedTopology: true}
);
const paymentSchema = new mongoose.Schema({
    id: String,
    idemId: String,
    paid: Boolean
});

const Payment = mongoose.model("Payment",paymentSchema);

module.exports ={
    Payment
}