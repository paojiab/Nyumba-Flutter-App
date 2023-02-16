import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nyumba/pages/login.dart';
import 'package:nyumba/prop.dart';
import 'package:nyumba/property.dart';
import 'package:nyumba/providers/spesnow_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';
import 'package:http/http.dart' as http;

import 'models/rental.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  String _isLoggedIn = "check";
  @override
  void initState() {
    _check();
    super.initState();
  }

  _check() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) {
      setState(() {
        _isLoggedIn = "false";
      });
    } else {
      setState(() {
        _isLoggedIn = "true";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == "false") {
      return const Login(page: "favorite");
    } else if (_isLoggedIn == "check") {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: const Text(
          "Saved",
          style: TextStyle(color: Colors.white),
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
          child: FutureBuilder<List<Rental>>(
            future: SpesnowProvider().fetchFavoriteRentals(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('An error has occurred!'),
                  ),
                );
              } else if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text('No favorites found'),
                    ),
                  );
                } else {
                  return RentalsList(rentals: snapshot.data!);
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class RentalsList extends StatefulWidget {
  const RentalsList({super.key, required this.rentals});

  final List<Rental> rentals;

  @override
  State<RentalsList> createState() => _RentalsListState();
}

class _RentalsListState extends State<RentalsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.rentals.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Prop(
                              id: widget.rentals[index].id,
                            )),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: const Image(
                              image: AssetImage('images/hero-img.jpg'),
                              height: 60,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0,8,8,8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.rentals[index].district}, ${widget.rentals[index].category}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20.0),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 4.0),
                                            child: Icon(
                                              Icons.bathtub_outlined,
                                              color: Color.fromARGB(
                                                  255, 124, 123, 123),
                                            ),
                                          ),
                                          Text(
                                            (widget.rentals[index].bathrooms)
                                                .toString(),
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 124, 123, 123),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 4.0),
                                          child: Icon(
                                            Icons.bed,
                                            color: Color.fromARGB(
                                                255, 124, 123, 123),
                                          ),
                                        ),
                                        Text(
                                          (widget.rentals[index].bedrooms)
                                              .toString(),
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 124, 123, 123),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text("UGX ${widget.rentals[index].price} per month"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () async {
                             await SpesnowProvider()
                                    .removeFavorite(widget.rentals[index].id);
                                setState(() {
                                  widget.rentals.removeAt(index);
                                });
                                const snackBar = SnackBar(
                                  content:
                                      Text('Rental has been unsaved'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}
