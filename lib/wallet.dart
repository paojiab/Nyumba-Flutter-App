import 'package:flutter/material.dart';
import 'generated/l10n.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          S.of(context).wallet.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 290,
                      height: 92,
                      child: Card(
                        color: Colors.brown,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            S.of(context).wallet,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 30,
                      child: SizedBox(
                        width: 290,
                        height: 65,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.brown),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 16.0),
                            child: Text(
                              'UGX 1,000,000.00',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.brown),
                  ),
                  onPressed: () {},
                  child: Text(S.of(context).payUtilities),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(S.of(context).deposit),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
