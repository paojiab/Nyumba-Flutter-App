import 'package:flutter/material.dart';
import 'package:nyumba/filter.dart';
import 'package:nyumba/property.dart';
import 'generated/l10n.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          S.of(context).results,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const Filter()),
                ),
              );
            },
            icon: const Icon(Icons.filter_alt),
            color: Colors.white,
          ),
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
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Property()),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.brown),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/hero-img.jpg',
                                  width: 100,
                                  height: 100,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Apartment for rent'),
                                      const Text(
                                        'Ush 800,000',
                                        style: TextStyle(
                                            color: Colors.brown,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: const [
                                          Icon(Icons.location_pin),
                                          Text('Kampala'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 0,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('PROMOTED'),
                      ),
                    ),
                  ],
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
                        side: BorderSide(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/hero-img.jpg',
                              width: 100,
                              height: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
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
