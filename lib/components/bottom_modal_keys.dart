import 'package:flutter/material.dart';
import 'package:spesnow/views/payment/payment.dart';

showBottomModalKeys(BuildContext context, String name, String email) {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage(
                              name: name,
                              email: email,
                              amount: 5000,
                            )),
                  );
                },
                title: const Text(
                  '45 KEYS',
                  style: TextStyle(letterSpacing: 2.0, color: Colors.black54),
                ),
                trailing: const Text(
                  'UGX 5,000',
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, letterSpacing: 1.0),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage(
                            name: name, email: email, amount: 10000)),
                  );
                },
                title: const Text(
                  '90 KEYS',
                  style: TextStyle(letterSpacing: 2.0, color: Colors.black54),
                ),
                trailing: const Text(
                  'UGX 10,000',
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, letterSpacing: 1.0),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage(
                              name: name,
                              email: email,
                              amount: 20000,
                            )),
                  );
                },
                title: const Text(
                  '200 KEYS',
                  style: TextStyle(letterSpacing: 2.0, color: Colors.black54),
                ),
                trailing: const Text(
                  'UGX 20,000',
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, letterSpacing: 1.0),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage(
                              name: name,
                              email: email,
                              amount: 50000,
                            )),
                  );
                },
                title: const Text(
                  '540 KEYS',
                  style: TextStyle(letterSpacing: 2.0, color: Colors.black54),
                ),
                trailing: const Text(
                  'UGX 50,000',
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, letterSpacing: 1.0),
                ),
              ),
            ),
          ],
        );
      });
}
