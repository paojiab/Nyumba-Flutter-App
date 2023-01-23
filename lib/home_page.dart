import 'package:flutter/material.dart';
import 'package:nyumba/models/category.dart' as my;
import 'package:nyumba/models/rental.dart';
import 'package:nyumba/property.dart';
import 'package:nyumba/result.dart';
import 'package:nyumba/search.dart';
import 'generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:nyumba/providers/spesnow_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
                          controller: searchController,
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
                    SizedBox(
                      height: 36,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Search(search: searchController.text),
                            ),
                          );
                        },
                        child: Text(
                          S.of(context).search,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<my.Category>>(
                future: SpesnowProvider().fetchCategories(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('An error has occurred!'),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Center(
                          child: Text('No categories found'),
                        ),
                      );
                    } else {
                      return CategoriesList(categories: snapshot.data!);
                    }
                  } else {
                    return const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  'LATEST RENTALS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              FutureBuilder<List<Rental>>(
                future: SpesnowProvider().fetchLatestRentals(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    // print(snapshot.error);
                    return const Center(
                      child: Text('An error has occurred!'),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No rentals found'),
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
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key, required this.categories});

  final List<my.Category> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Result(id: categories[index].id),
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
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    categories[index].name,
                    style: const TextStyle(color: Colors.brown),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.rentalId});

  final int rentalId;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorited = false;
  bool _isLoggedIn = true;

  @override
  void initState() {
    logged();
    _check();
    super.initState();
  }

  logged() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  _check() async {
    var response = await SpesnowProvider().checkFavorite(widget.rentalId);
    if (response) {
      if (mounted) {
        setState(() {
          _isFavorited = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (_isLoggedIn) {
          if (_isFavorited) {
            await SpesnowProvider().removeFavorite(widget.rentalId);
            setState(() {
              _isFavorited = false;
            });
             const snackBar = SnackBar(
              content: Text('Rental removed from favorites'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (!_isFavorited) {
            await SpesnowProvider().addFavorite(widget.rentalId);
            setState(() {
              _isFavorited = true;
            });
            const snackBar = SnackBar(
              content: Text('Rental added to favorites'),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      icon: _isFavorited
          ? const Icon(Icons.favorite, color: Colors.brown)
          : const Icon(Icons.favorite_outline, color: Colors.brown),
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
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.rentals.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Property(id: widget.rentals[index].id),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    (widget.rentals[index].bedrooms).toString(),
                                    style: const TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  ),
                                  const Icon(Icons.bed, color: Colors.white),
                                ],
                              ),
                              Text(
                                widget.rentals[index].district,
                                style: const TextStyle(color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Text(
                                    (widget.rentals[index].bathrooms)
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  ),
                                  const Icon(
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
                        onPressed: () async {},
                        child: FavoriteButton(
                          rentalId: widget.rentals[index].id,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
