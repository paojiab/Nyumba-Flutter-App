import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nyumba/models/rental.dart';
import 'package:nyumba/pages/subscribe.dart';
import 'package:nyumba/providers/spesnow_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prop extends StatefulWidget {
  const Prop({super.key, required this.id});

  final int id;

  @override
  State<Prop> createState() => _PropState();
}

class _PropState extends State<Prop> {
  late Future<Rental> futureRental;

  bool _subscribed = false;
  bool _isFavorited = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    futureRental = SpesnowProvider().fetchRental("rentals/${widget.id}");
    _subscriptionCheck();
    _checkFavorite();
    _checkLogin();
  }

  _subscriptionCheck() async {
    final response = await SpesnowProvider().subscriptionCheck();
    if (response) {
      _subscribed = true;
    }
  }

  _checkFavorite() async {
    var response = await SpesnowProvider().checkFavorite(widget.id);
    if (response) {
      if (mounted) {
        setState(() {
          _isFavorited = true;
        });
      }
    }
  }

  _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: futureRental,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            "images/hero-img.jpg",
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                color: Colors.brown,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data!.category,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (_isLoggedIn) {
                                  if (_isFavorited) {
                                    await SpesnowProvider()
                                        .removeFavorite(widget.id);
                                    setState(() {
                                      _isFavorited = false;
                                    });
                                    const snackBar = SnackBar(
                                      content:
                                          Text('Rental removed from favorites'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else if (!_isFavorited) {
                                    await SpesnowProvider()
                                        .addFavorite(widget.id);
                                    setState(() {
                                      _isFavorited = true;
                                    });
                                    const snackBar = SnackBar(
                                      content:
                                          Text('Rental added to favorites'),
                                      backgroundColor: Colors.green,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                } else {
                                  const snackBar = SnackBar(
                                    content: Text('You must login first'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              icon: _isFavorited
                                  ? const Icon(Icons.favorite,
                                      color: Colors.brown)
                                  : const Icon(Icons.favorite_outline,
                                      color: Colors.brown),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_pin,
                              size: 18,
                            ),
                            Text(snapshot.data!.district),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 18,
                            ),
                            Text("Updated ${snapshot.data!.updatedAt}"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Ush ${snapshot.data!.price}/${snapshot.data!.timeframe}",
                          style: const TextStyle(
                              color: Colors.brown, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.bed),
                                Text("${snapshot.data!.bedrooms} Bed"),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.bathtub_outlined),
                                Text("${snapshot.data!.bathrooms} Bath"),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.kitchen),
                                Text("${snapshot.data!.kitchens} Kitchen"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage("images/profile.jpg"),
                              radius: 25,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.landlord,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: const [
                                    Icon(Icons.verified, color: Colors.brown),
                                    Text(
                                      "Verified landlord",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_subscribed) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Subscribe()),
                                );
                              }
                            },
                            child: Text(_subscribed
                                ? snapshot.data!.landlordTel
                                : "Unlock Contact"),
                          ),
                        )),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Property Size',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(snapshot.data!.size ?? '-'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Pets',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data!.pets == 1
                                      ? 'Allowed'
                                      : 'Not Allowed',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Smoking',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data!.smoking == 1
                                      ? 'Allowed'
                                      : 'Not Allowed',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Parties',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data!.parties == 1
                                      ? 'Allowed'
                                      : 'Not Allowed',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Furnished',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data!.furnished == 1 ? 'Yes' : 'No',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Newly Renovated',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data!.renovated == 1 ? 'Yes' : 'No',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Security Guard',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data!.guard == 1 ? 'Yes' : 'No',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.only(top: 250.0),
                  child: CircularProgressIndicator(),
                ));
              })),
    );
  }
}
