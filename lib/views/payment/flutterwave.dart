import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:uuid/uuid.dart';

class FlutterwavePlugin extends StatefulWidget {
  FlutterwavePlugin(this.title,);

  final String title;

  @override
  _FlutterwavePluginState createState() => _FlutterwavePluginState();
}

class _FlutterwavePluginState extends State<FlutterwavePlugin> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final currencyController = TextEditingController();
  final narrationController = TextEditingController();
  final publicKeyController = TextEditingController();
  final encryptionKeyController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String selectedCurrency = "";

  bool isTestMode = true;

  @override
  Widget build(BuildContext context) {
    currencyController.text = selectedCurrency;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            )),
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: ElevatedButton(
                    onPressed: _onPressed,
                    child: const Text(
                      "Initiate",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _onPressed() {
    if (formKey.currentState!.validate()) {
      _handlePaymentInitialization();
    }
  }

  _handlePaymentInitialization() async {
    final Customer customer = Customer(
        email: "customer@customer.com",
        name: 'customer',
        phoneNumber: '0701111111');

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: getPublicKey(),
        currency: "UGX",
        redirectUrl: 'https://bopclic.com',
        txRef: const Uuid().v1(),
        amount: "500",
        customer: customer,
        paymentOptions: "",
        customization: Customization(title: "Spesnow"),
        isTestMode: true);
    final ChargeResponse response = await flutterwave.charge();

    final result = response.toJson();
    final status = result["status"];
    showNotification(status);
  }

  String getPublicKey() {
    return "FLWPUBK_TEST-086baa1a7947426bd1c9fb5b7f0df86f-X";
  }

  showNotification(String status) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: status == "successful" ? Colors.brown : Colors.red,
          content: Text(
            "Transaction $status.",
            textAlign: TextAlign.center,
          )),
    );
  }
}
