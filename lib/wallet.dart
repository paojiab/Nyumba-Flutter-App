import 'package:flutter/material.dart';
import 'package:spesnow/pages/payment.dart';
import 'generated/l10n.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                // <-- SEE HERE
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              context: context,
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentPage()),
                            );
                          },
                          title: Text('25 Keys'),
                          leading: Icon(
                            Icons.key,
                          ),
                          trailing: Text(
                            'UGX 5,000',
                            style: TextStyle(color: Colors.brown),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentPage()),
                            );
                          },
                          title: Text('75 Keys'),
                          leading: Icon(Icons.key),
                          trailing: Text(
                            'UGX 15,000',
                            style: TextStyle(color: Colors.brown),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentPage()),
                            );
                          },
                          title: Text('175 Keys'),
                          leading: Icon(Icons.key),
                          trailing: Text(
                            'UGX 35,000',
                            style: TextStyle(color: Colors.brown),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentPage()),
                            );
                          },
                          title: Text('325 Keys'),
                          leading: Icon(Icons.key),
                          trailing: Text(
                            'UGX 65,000',
                            style: TextStyle(color: Colors.brown),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        label: const Text('Buy'),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "0",
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: const Icon(
                Icons.key,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text("No transactions to show"),
      ),
    );
  }
}
