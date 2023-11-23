//create a payment screen for accepting crypto payments
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key? key, required this.cost}) : super(key: key);
  final double cost;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<void> sendCostToServer(double cost) async {
    final apiUrl =
        "http://172.17.19.233:4000/api/storeDuration/"; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl + "$cost"),
      );

      if (response.statusCode == 200) {
        // Request successful, you can process the response here
        print("Response: ${response.body}");
      } else {
        // Request failed
        print("Request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      // An error occurred
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    //send cost to the server with given api address and get the some response
    sendCostToServer(widget.cost);
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Payment"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: WillPopScope(
        // Prevent user from moving back
        onWillPop: () async {
          return true;
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Total Cost: ${widget.cost} DAI"),
            ],
          ),
        ),
      ),
    );
  }
}
