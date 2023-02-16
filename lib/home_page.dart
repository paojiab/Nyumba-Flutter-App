import 'package:flutter/material.dart';
import 'package:nyumba/models/category.dart' as my;
import 'package:nyumba/models/rental.dart';
import 'package:nyumba/notification.dart';
import 'package:nyumba/prop.dart';
import 'package:nyumba/property.dart';
import 'package:nyumba/result.dart';
import 'package:nyumba/search.dart';
import 'generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:nyumba/providers/spesnow_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/location.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              showCursor: false,
              onTap: () {
                Navigator.pushNamed(context, '/search');
              },
              decoration: const InputDecoration(
                hintText: 'Search for a rental in ...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Notify(),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              FutureBuilder<List<my.Category>>(
                future: SpesnowProvider().fetchCategories(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
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
                      padding: EdgeInsets.only(top: 20.0, bottom: 20),
                      child: Center(
                        child: LinearProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.brown),
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Did you know?",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        const Text(
                          "We have a website,",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        const Text(
                          "For property sales and auctions!",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "VISIT NOW >",
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: Container(
              //     color: Colors.brown,
              //     height: 50,
              //     width: double.infinity,
              //     child: const Center(
              //       child: Text(
              //         'Latest Rentals',
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.normal,
              //             fontSize: 18),
              //       ),
              //     ),
              //   ),
              // ),
              FutureBuilder<List<Rental>>(
                future: SpesnowProvider().fetchLatestRentals(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
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
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
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
    return SizedBox(
      height: 120,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
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
                // Image.asset(
                //   'images/apartment.jpg',
                //   width: 90,
                //   height: 80,
                // ),
                const Image(
                  image: AssetImage('images/apartment.png'),
                  width: 90,
                  height: 80,
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
              content: Text('Rental has been unsaved'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (!_isFavorited) {
            await SpesnowProvider().addFavorite(widget.rentalId);
            setState(() {
              _isFavorited = true;
            });
            const snackBar = SnackBar(
              content: Text('Rental has been saved'),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          const snackBar = SnackBar(
            content: Text('You must first login'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      icon: _isFavorited
          ? const Icon(
              Icons.favorite,
              color: Colors.white,
            )
          : const Icon(Icons.favorite_outline, color: Colors.white),
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
            padding: const EdgeInsets.fromLTRB(18.0, 18, 18, 0),
            child: GestureDetector(
              // onTap: () => Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Property(id: widget.rentals[index].id),
              //   ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Prop(id: widget.rentals[index].id),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: const Image(
                          image: AssetImage("images/hero-img.jpg"),
                          fit: BoxFit.cover,
                          height: 270,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child:
                            ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            color: Colors.brown,
                            child: FavoriteButton(
                                rentalId: widget.rentals[index].id),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.rentals[index].district}, ${widget.rentals[index].category}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(widget.rentals[index].rating),
                                const Icon(Icons.star, size: 16),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          "${widget.rentals[index].bedrooms} bedrooms",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 124, 123, 123),
                          ),
                        ),
                        Text(
                          "${widget.rentals[index].bathrooms} bathrooms",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 124, 123, 123),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "UGX ${widget.rentals[index].price}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text('per month'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
