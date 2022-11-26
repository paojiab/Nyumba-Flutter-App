import 'package:flutter/material.dart';
import 'package:nyumba/property.dart';
import 'package:nyumba/result.dart';
import 'generated/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'NYUMBA',
          style: TextStyle(color: Colors.brown),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            color: Colors.brown,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 25.0, 10, 25.0),
                color: Colors.brown,
                child: Column(
                  children: [
                    const Text(
                      'Zero Brokers!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                    const Text(
                      'Rentals from verified Landlords',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 8, 15),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            // border: OutlineInputBorder(),
                            hintText: S.of(context).location,
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Result(),
                          ),
                        );
                      },
                      child: Text(
                        S.of(context).search,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Result(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'images/apartment.png',
                            width: 130,
                            height: 100,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Apartments',
                              style: TextStyle(color: Colors.brown),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Result(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'images/single-unit.png',
                            width: 130,
                            height: 100,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Single Unit Homes',
                              style: TextStyle(color: Colors.brown),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Result(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'images/mizigo.jfif',
                          width: 130,
                          height: 100,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Mizigo',
                            style: TextStyle(color: Colors.brown),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Result(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'images/commercial.jpg',
                          width: 130,
                          height: 100,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Commercial',
                            style: TextStyle(color: Colors.brown),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 30, 8, 8),
                child: Text(
                  'RENTALS NEAR ME',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Property(),
                    ),
                  ),
                  child: Card(
                    elevation: 0,
                    color: Colors.brown,
                    child: SizedBox(
                      width: 300,
                      height: 220,
                      child: Stack(children: [
                        Column(
                          children: [
                            Image.asset(
                              'images/hero-img.jpg',
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: 170,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        '3',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                      Icon(Icons.bed, color: Colors.white),
                                    ],
                                  ),
                                  const Text(
                                    'Kampala',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        '2',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.bathtub_outlined,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 10,
                          left: 5,
                          child: Column(children: [
                            TextButton(
                              onPressed: () {},
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                        Positioned(
                          top: 15,
                          right: 10,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {},
                            child: const Icon(
                              Icons.favorite_outline,
                              color: Colors.brown,
                            ),
                          ),
                        ),
                      ]),
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
