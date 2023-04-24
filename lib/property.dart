import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spesnow/models/rental.dart';
import 'package:spesnow/pages/book.dart';
import 'package:spesnow/providers/spesnow_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1592595896551-12b371d546d5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8cmVhbCUyMGVzdGF0ZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1565402170291-8491f14678db?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cmVhbCUyMGVzdGF0ZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8cmVhbCUyMGVzdGF0ZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHJlYWwlMjBlc3RhdGV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1448630360428-65456885c650?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fHJlYWwlMjBlc3RhdGV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
  'https://images.unsplash.com/photo-1599809275671-b5942cabc7a2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fHJlYWwlMjBlc3RhdGV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60'
];

class Property extends StatefulWidget {
  const Property({super.key, required this.id});

  final int id;

  @override
  State<Property> createState() => _PropertyState();
}

class _PropertyState extends State<Property> {
  late Future<Rental> futureRental;

  bool _subscribed = false;
  bool _isFavorited = false;
  bool _isLoggedIn = false;

  int _current = 0;
  final CarouselController _controller = CarouselController();
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          '${imgList.indexOf(item)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ))
      .toList();

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
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          S.of(context).property,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (_isLoggedIn) {
                if (_isFavorited) {
                  await SpesnowProvider().removeFavorite(widget.id);
                  setState(() {
                    _isFavorited = false;
                  });
                  const snackBar = SnackBar(
                    content: Text('Rental removed from favorites'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (!_isFavorited) {
                  await SpesnowProvider().addFavorite(widget.id);
                  setState(() {
                    _isFavorited = true;
                  });
                  const snackBar = SnackBar(
                    content: Text('Rental added to favorites'),
                    backgroundColor: Colors.green,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } else {
               const snackBar = SnackBar(
                    content: Text('You must login first'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: _isFavorited
                ? const Icon(Icons.favorite, color: Colors.white)
                : const Icon(Icons.favorite_outline, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Rental>(
          future: futureRental,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return Text(snapshot.data!.title);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: Column(children: [
                      Expanded(
                        child: CarouselSlider(
                          items: imageSliders,
                          carouselController: _controller,
                          options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
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
                              width: 12.0,
                              height: 12.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black)
                                      .withOpacity(
                                          _current == entry.key ? 0.9 : 0.4)),
                            ),
                          );
                        }).toList(),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.brown),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.title,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Ush ${snapshot.data!.price} per ${snapshot.data!.timeframe}",
                                style: const TextStyle(
                                    color: Colors.brown, fontSize: 16),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_pin),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                        "${snapshot.data!.district}, ${snapshot.data!.country}"),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.lock_clock),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                        "Updated ${snapshot.data!.updatedAt}"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.brown),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 70,
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage('images/profile.jpg'),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data!.landlord),
                                Row(
                                  children: const [
                                    Icon(Icons.verified, color: Colors.brown),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        'Verified Landlord',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 167,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (!_subscribed) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BookPage()),
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(Icons.phone),
                                        Text(_subscribed
                                            ? snapshot.data!.landlordTel
                                            : S.of(context).unlock),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.brown),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      (snapshot.data!.bedrooms).toString(),
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                    Row(
                                      children: const [
                                        Icon(Icons.bed, color: Colors.brown),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: Text('Bed(s)'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      (snapshot.data!.bathrooms).toString(),
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                    Row(
                                      children: const [
                                        Icon(Icons.bathtub_outlined,
                                            color: Colors.brown),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: Text('Bath(s)'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Property Type',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(snapshot.data!.category),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Property Size',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(snapshot.data!.size ?? '-'),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Kitchens',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text((snapshot.data!.kitchens)
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Pets',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Smoking',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Parties',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data!.parties == 1
                                              ? 'Allowed'
                                              : 'Not Allowed',
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: const [
                                  //       Text(
                                  //         'Parking',
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.bold),
                                  //       ),
                                  //       Text('Yes'),
                                  //     ],
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Furnished',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data!.furnished == 1
                                              ? 'Yes'
                                              : 'No',
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: const [
                                  //       Text(
                                  //         'Year Built',
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.bold),
                                  //       ),
                                  //       Text('2004'),
                                  //     ],
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Newly Renovated',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data!.renovated == 1
                                              ? 'Yes'
                                              : 'No',
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: const [
                                  //       Text(
                                  //         'Swimming Pool',
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.bold),
                                  //       ),
                                  //       Text('No'),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: const [
                                  //       Text(
                                  //         'Gym',
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.bold),
                                  //       ),
                                  //       Text('No'),
                                  //     ],
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Security Guard',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data!.guard == 1
                                              ? 'Yes'
                                              : 'No',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.brown),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'NEARBY SCHOOLS',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        'Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Level',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Distance',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                  rows: const [
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          Text('Entebbe Secondary School'),
                                        ),
                                        DataCell(
                                          Text('Secondary'),
                                        ),
                                        DataCell(
                                          Text('0.1 miles'),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          Text('Rainbow Christian School'),
                                        ),
                                        DataCell(
                                          Text('Primary'),
                                        ),
                                        DataCell(
                                          Text('0.5 miles'),
                                        ),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.brown),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'COMMUTE',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text('Change destination'),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    'Destination: Entebbe International Airport'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: const [
                                        Icon(Icons.car_rental),
                                        Text('12 min by car')
                                      ],
                                    ),
                                    Column(
                                      children: const [
                                        Icon(Icons.train),
                                        Text('34 min by transit')
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: const [
                                        Icon(Icons.bike_scooter),
                                        Text('22 min by bike')
                                      ],
                                    ),
                                    Column(
                                      children: const [
                                        Icon(Icons.egg),
                                        Text('1h 10m on foot')
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
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const Center(
                child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: CircularProgressIndicator(),
            ));
          },
        ),
      ),
    );
  }
}
