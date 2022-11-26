import 'package:flutter/material.dart';
import 'package:nyumba/property.dart';
import 'generated/l10n.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          S.of(context).favorites.toUpperCase(),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
          child: Column(
            children: [
              SizedBox(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(S.of(context).favorites + " (2)"),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(S.of(context).clearAll),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Property()),
                  ),
                  child: SizedBox(
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.brown),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'images/hero-img.jpg',
                              width: 100,
                              height: 100,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Apartment for rent'),
                                const Text(
                                  'Ush 800,000',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(children: const [
                                  Icon(Icons.location_pin),
                                  Text('Kampala'),
                                ]),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Property()),
                  ),
                  child: SizedBox(
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.brown),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'images/hero-img.jpg',
                              width: 100,
                              height: 100,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Apartment for rent'),
                                const Text(
                                  'Ush 800,000',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(children: const [
                                  Icon(Icons.location_pin),
                                  Text('Kampala'),
                                ]),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
