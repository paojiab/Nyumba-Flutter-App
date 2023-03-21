import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:spesnow/models/rental.dart';
import 'package:spesnow/pages/subscribe.dart';
import 'package:spesnow/providers/spesnow_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

 final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: futureRental,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // height: 250,
                          child: CarouselSlider(
                        options: CarouselOptions(),
                        items: imgList
                            .map((item) => Container(
                                  child: Center(
                                      child: Image.network(item,
                                          fit: BoxFit.cover, width: 1000)),
                                ))
                            .toList(),
                      )),
                      // Image.asset(
                      //   "images/hero-img.jpg",
                      //   width: double.infinity,
                      //   height: 250,
                      //   fit: BoxFit.cover,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${snapshot.data!.category} for rent",
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
                            // child: Text(_subscribed
                            //     ? snapshot.data!.landlordTel
                            //     : "Schedule Tour"),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text('Schedule Tour'),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Text(
                                        '1',
                                        style: TextStyle(color: Colors.yellow),
                                      ),
                                    ),
                                    Icon(
                                      Icons.key,
                                      color: Colors.yellow,
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                  'Teachers',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Not Allowed',
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
                                  'Students',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Not Allowed',
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
                                  'Children',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Not Allowed',
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
                       const Divider(
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Outdoor Photos',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Amenities & Highlights',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('\u2022 Swimming Pool'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('\u2022 Gym'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('\u2022 Cabinets'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('\u2022 Laundry Machine'),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
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

 final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'No. ${imgList.indexOf(item)} image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
