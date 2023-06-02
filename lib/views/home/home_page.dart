import 'package:flutter/material.dart';
import 'package:spesnow/views/home/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'rentals.dart';
import '../../providers/firestore_provider.dart';

class RentalCategory {
  final String name;
  final String image;

  RentalCategory(this.name, this.image);
}

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
    return DefaultTabController(
      initialIndex: 0,
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: SizedBox(
            height: 45,
            child: TextField(
              readOnly: true,
              style: const TextStyle(fontSize: 14),
              showCursor: false,
              onTap: () {
                Navigator.pushNamed(context, '/search');
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(45.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(45.0)),
                ),
                hintText: 'Search for a rental in ...',
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
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
              icon: const Icon(Icons.notifications_none),
              color: Colors.black,
            ),
          ],
          bottom: const TabBar(
              isScrollable: true,
              indicatorColor: Colors.black54,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  icon: Icon(Icons.category_outlined),
                  text: "My Space",
                ),
                Tab(
                  icon: Icon(Icons.apartment),
                  text: "Apartment",
                ),
                Tab(
                  icon: Icon(Icons.cabin),
                  text: "Muzigo",
                ),
                Tab(
                  icon: Icon(Icons.castle_outlined),
                  text: "Single Unit",
                ),
                Tab(
                  icon: Icon(Icons.business),
                  text: "Commercial",
                ),
                Tab(
                  icon: Icon(Icons.warehouse_outlined),
                  text: "Multipurpose",
                ),
                Tab(
                  icon: Icon(Icons.other_houses_outlined),
                  text: "Leased",
                ),
              ]),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              // latest
              FutureBuilder(
                future: firestoreProvider().getRentalIds(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const SizedBox(
                        width: double.infinity,
                        height: 500,
                        child: Center(
                          child: Text(
                            "No rentals found",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    } else {
                      final rentalIds = snapshot.data!;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: rentalIds.length,
                          itemBuilder: ((context, index) {
                            return HomepageRentals(rentalId: rentalIds[index]);
                          }));
                    }
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black54),
                    ),
                  );
                }),
              ),
              // Apartment
              FutureBuilder(
                future: firestoreProvider().getSpecificRentalIds("Apartment"),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const SizedBox(
                        width: double.infinity,
                        height: 500,
                        child: Center(
                          child: Text(
                            "No rentals found",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    } else {
                      final rentalIds = snapshot.data!;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: rentalIds.length,
                          itemBuilder: ((context, index) {
                            return HomepageRentals(rentalId: rentalIds[index]);
                          }));
                    }
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black54),
                    ),
                  );
                }),
              ),
              // Muzigo
              FutureBuilder(
                future: firestoreProvider().getSpecificRentalIds("Muzigo"),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const SizedBox(
                        width: double.infinity,
                        height: 500,
                        child: Center(
                          child: Text(
                            "No rentals found",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    } else {
                      final rentalIds = snapshot.data!;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: rentalIds.length,
                          itemBuilder: ((context, index) {
                            return HomepageRentals(rentalId: rentalIds[index]);
                          }));
                    }
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black54),
                    ),
                  );
                }),
              ),
              // Single Unit
              FutureBuilder(
                future: firestoreProvider().getSpecificRentalIds("Single Unit"),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const SizedBox(
                        width: double.infinity,
                        height: 500,
                        child: Center(
                          child: Text(
                            "No rentals found",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    } else {
                      final rentalIds = snapshot.data!;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: rentalIds.length,
                          itemBuilder: ((context, index) {
                            return HomepageRentals(rentalId: rentalIds[index]);
                          }));
                    }
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black54),
                    ),
                  );
                }),
              ),
              // Commercial
              FutureBuilder(
                future: firestoreProvider().getSpecificRentalIds("Commercial"),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const SizedBox(
                        width: double.infinity,
                        height: 500,
                        child: Center(
                          child: Text(
                            "No rentals found",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    } else {
                      final rentalIds = snapshot.data!;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: rentalIds.length,
                          itemBuilder: ((context, index) {
                            return HomepageRentals(rentalId: rentalIds[index]);
                          }));
                    }
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black54),
                    ),
                  );
                }),
              ),
              // Multipurpose
              FutureBuilder(
                future:
                    firestoreProvider().getSpecificRentalIds("Multipurpose"),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const SizedBox(
                        width: double.infinity,
                        height: 500,
                        child: Center(
                          child: Text(
                            "No rentals found",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    } else {
                      final rentalIds = snapshot.data!;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: rentalIds.length,
                          itemBuilder: ((context, index) {
                            return HomepageRentals(rentalId: rentalIds[index]);
                          }));
                    }
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black54),
                    ),
                  );
                }),
              ),
              // Leased
              FutureBuilder(
                future: firestoreProvider().getSpecificRentalIds("Leased"),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const SizedBox(
                        width: double.infinity,
                        height: 500,
                        child: Center(
                          child: Text(
                            "No rentals found",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    } else {
                      final rentalIds = snapshot.data!;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: rentalIds.length,
                          itemBuilder: ((context, index) {
                            return HomepageRentals(rentalId: rentalIds[index]);
                          }));
                    }
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black54),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
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
  bool _isLoggedIn = false;

  logged() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final snackBar = SnackBar(
          content: const Text('Coming soon..'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      icon: _isFavorited
          ? const Icon(
              Icons.favorite,
              color: Colors.white,
            )
          : const Icon(
              Icons.favorite_outline_rounded,
              color: Colors.white,
              size: 16,
            ),
    );
  }
}
