import 'dart:ui';

import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _character = "momo";
  bool airtel = true;
  bool mtn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Mobile Money'),
                    leading: Radio(
                      value: "momo",
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Card'),
                    leading: Radio(
                      value: "card",
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color.fromARGB(255, 100, 100, 100),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _character == "momo"
                  ? Column(
                      children: [
                        ListTile(
                          trailing: Image.network(
                            'https://mir-s3-cdn-cf.behance.net/project_modules/1400/30455c9384889.57ee562a4fba0.jpg',
                            width: 70,
                            height: 50,
                          ),
                          title: const Text('Airtel'),
                          subtitle: Text('Instant'),
                          leading: Checkbox(
                            checkColor: Colors.white,
                            value: airtel,
                            onChanged: (bool? value) {
                              setState(() {
                                airtel = value!;
                                mtn = false;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          trailing: Image.network(
                            'https://mlbddnoe2gm0.i.optimole.com/w:289/h:175/q:mauto/https://i0.wp.com/theictbook.com/wp-content/uploads/2020/10/images.png?fit=289%2C175&ssl=1',
                            width: 50,
                            height: 50,
                          ),
                          title: const Text('MTN'),
                          subtitle: Text('Instant'),
                          leading: Checkbox(
                            checkColor: Colors.white,
                            value: mtn,
                            onChanged: (bool? value) {
                              setState(() {
                                mtn = value!;
                                airtel = false;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Phone number',
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text("+256"),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('PAY'),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'images/mastercard.jpg',
                              width: 50,
                              height: 50,
                            ),
                            Image.asset(
                              'images/visa.jpg',
                              width: 50,
                              height: 50,
                            ),
                            Image.asset(
                              'images/AE.png',
                              width: 50,
                              height: 35,
                            ),
                            Image.asset(
                              'images/DN.png',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text('Number'),
                            ),
                            hintText: 'Required',
                            suffixIcon: Icon(Icons.credit_card),
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text('Expires'),
                            ),
                            hintText: 'MM / YYYY',
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text('CVV'),
                            ),
                            hintText: 'Security code',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(15.0),
                              ),
                              label: Text('Name on card'),
                            ),
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(15.0),
                            ),
                            label: Text('Address'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){}, child: Text('PAY'),),
                        ),
                        ListTile(
                          leading: Icon(Icons.verified, color: Colors.brown,),
                          title: Text('Your transaction details are encrypted and are never shared with third parties.', style: TextStyle(color: Color.fromARGB(255, 104, 104, 104), fontSize: 14),),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
