import 'package:flutter/material.dart';
import 'package:spesnow/models/rental.dart';
import 'package:spesnow/notification.dart';
import 'package:spesnow/prop.dart';
import 'generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'package:spesnow/providers/spesnow_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RentalCategory {
  final String name;
  final String image;

  RentalCategory(this.name, this.image);
}

final categories = [
  RentalCategory("Apartment", "images/apartment.png"),
  RentalCategory("Muzigo", "images/muzigo.png"),
  RentalCategory("Single Unit", "images/single-unit.png"),
  RentalCategory("Commercial", "images/commercial.png"),
  RentalCategory("Multipurpose", "images/multipurpose.png"),
];

final List<String> imgList = [
  'images/a1.png',
  'images/a2.png',
];

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  int _current = 0;
  final CarouselController _controller = CarouselController();
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                    // Image.network(item, fit: BoxFit.cover, width: 1000.0),
                  ],
                )),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.brown,
        title: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: SizedBox(
              height: 40,
              child: TextField(
                readOnly: true,
                style: const TextStyle(fontSize: 13.5),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Result(id: categories[index].id),
                        //   ),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage(categories[index].image),
                              width: 75,
                              height: 65,
                            ),
                            Text(
                              categories[index].name,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: Column(children: [
                Expanded(
                  child: CarouselSlider(
                    items: imageSliders,
                    carouselController: _controller,
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: false,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 7.0,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.brown)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ]),
            ),
            FutureBuilder<List<Rental>>(
              future: SpesnowProvider().fetchLatestRentals(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Something went wrong!'),
                    ),
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
                    child: Padding(
                      padding: EdgeInsets.only(top:25.0),
                      child: CircularProgressIndicator(),
                    ),
                   
                  );
                }
              },
            ),
          ],
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
        physics: const NeverScrollableScrollPhysics(),
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
                        child: ClipRRect(
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
