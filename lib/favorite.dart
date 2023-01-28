import 'package:flutter/material.dart';
import 'package:nyumba/pages/login.dart';
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
        title: Text(
          S.of(context).favorites,
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
        SizedBox(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).favorites),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text((widget.rentals.length).toString()),
                  ),
                ],
              ),
            ),
          ),
        ),
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
                        builder: (context) => Property(
                              id: widget.rentals[index].id,
                            )),
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
                                Text(widget.rentals[index].title),
                                Text(
                                  (widget.rentals[index].price).toString(),
                                  style: const TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(children: [
                                  const Icon(Icons.location_pin),
                                  Text(widget.rentals[index].district),
                                ]),
                              ],
                            ),
                            TextButton(
                              onPressed: () async {
                                await SpesnowProvider()
                                    .removeFavorite(widget.rentals[index].id);
                                setState(() {
                                  widget.rentals.removeAt(index);
                                });
                                const snackBar = SnackBar(
                                  content:
                                      Text('Rental removed from favorites'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
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
              );
            }),
      ],
    );
  }
}
