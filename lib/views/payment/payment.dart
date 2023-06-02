import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spesnow/providers/flutterwave.dart';
import 'package:spesnow/views/payment/rave_modal.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage(
      {super.key,
      required this.name,
      required this.email,
      required this.amount});
  final String name;
  final String email;
  final int amount;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  final phoneNumberController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryMonthController = TextEditingController();
  final expiryYearController = TextEditingController();
  final securityCodeController = TextEditingController();
  String raveUrl = "";
  bool airtel = true;
  bool mtn = false;

  @override
  void dispose() {
    phoneNumberController.dispose();
    cardNumberController.dispose();
    expiryMonthController.dispose();
    expiryYearController.dispose();
    securityCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
              indicatorColor: Colors.black54,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: "Mobile money",
                ),
                Tab(
                  text: "Card",
                ),
              ]),
          elevation: 1,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "UGX ${NumberFormat('#,###').format(widget.amount)}",
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: TabBarView(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "PHONE NUMBER",
                              style: TextStyle(color: Colors.black54),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 50,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(8),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            controller: phoneNumberController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone Number Required';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              prefixText: "07",
                              prefixStyle: TextStyle(color: Colors.black),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: SizedBox(
                          height: 50.0,
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  isLoading
                                      ? Colors.brown.shade300
                                      : Colors.brown),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  !isLoading) {
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  await flutteraveProvider()
                                      .initiatePayment(
                                    widget.name,
                                    widget.email,
                                    phoneNumberController.text,
                                    widget.amount,
                                  )
                                      .then((value) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RaveModelPage(
                                                  myUrl: value["link"],
                                                  txRef: value["tx_ref"],
                                                )));
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.black,
                                        content:
                                            const Text("Something went wrong")),
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: isLoading
                                ? const Text('Loading..')
                                : const Text("Pay",
                                    style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: _cardFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "CARD NUMBER",
                              style: TextStyle(color: Colors.black54),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 50,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(16),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            controller: cardNumberController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Card Number Required';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "MM",
                                      style: TextStyle(color: Colors.black54),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: expiryMonthController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Expiry Month Required';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      errorBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "YY",
                                      style: TextStyle(color: Colors.black54),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller: expiryYearController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Expiry Year Required';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      errorBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "CVV",
                              style: TextStyle(color: Colors.black54),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 50,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            controller: securityCodeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'CVV Required';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: SizedBox(
                          height: 50.0,
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  isLoading
                                      ? Colors.brown.shade300
                                      : Colors.brown),
                            ),
                            onPressed: () async {
                              if (_cardFormKey.currentState!.validate() && !isLoading) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.black,
                                      content: const Text("Coming soon..")),
                                );
                              }
                            },
                            child: isLoading
                                ? const Text('Loading..')
                                : const Text("Pay",
                                    style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
