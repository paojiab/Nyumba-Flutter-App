import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spesnow/views/home/home_page.dart';
import 'package:spesnow/providers/algolia.dart';
import 'package:spesnow/providers/location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:spesnow/views/property.dart';
import 'package:transparent_image/transparent_image.dart';

class ScoutPage extends StatefulWidget {
  const ScoutPage({super.key});

  @override
  State<ScoutPage> createState() => _ScoutPageState();
}

class _ScoutPageState extends State<ScoutPage> {
  String? locale = "Show my location";
  double lat = 0;
  double lng = 0;
  int isLoading = 1;
  bool showing = false;

  @override
  void initState() {
    locate();
    super.initState();
  }

  locate() async {
    try {
      final cords = await getLocation();
      setState(() {
        lat = cords.latitude;
        lng = cords.longitude;
        isLoading = 0;
      });
    } catch (e) {
      setState(() {
        isLoading = 2;
      });
    }
  }

  _uncover() async {
    setState(() {
      showing = true;
    });
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    final locality = placemarks[0].locality;
    final street = placemarks[0].street;
    setState(() {
      locale = "$locality, $street";
      showing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == 1) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "...",
            style: TextStyle(color: Colors.black),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              color: Colors.black54,
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );
    } else if (isLoading == 2) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "...",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                "Allow location permission for Spesnow in settings if you've permanently denied our request.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.black54),
                    ),
                onPressed: () {
                  setState(() {
                    isLoading = 1;
                  });
                  locate();
                },
                child: const Text("Try again"),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: GestureDetector(
          onTap: () => _uncover(),
          child: !showing
              ? Text(
                  "$locale",
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                )
              : const Text(
                  "...",
                  style: TextStyle(color: Colors.black),
                ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                child: Text(
                  'Scout',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Rentals near me (5 KM)",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              FutureBuilder<dynamic>(
                future:
                    AlgoliaProvider().nearestRentals({"lat": lat, "lng": lng}),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: double.infinity,
                            height: 450,
                            child:
                                Center(child: Text("Couldn't load rentals", style: TextStyle(fontSize: 16),))),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: double.infinity,
                            height: 450,
                            child: Center(
                                child: Text(
                              'No rentals found',
                              style: TextStyle(fontSize: 16),
                            ))),
                      );
                    } else {
                      return RentalsList(rentals: snapshot.data!);
                    }
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 450,
                        child: Center(
                          child:
                              CircularProgressIndicator(color: Colors.black54),
                        ),
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

class RentalsList extends StatefulWidget {
  const RentalsList({super.key, required this.rentals});
  final List rentals;

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
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SinglePropertyPage(
                        rental: widget.rentals[index],
                        latitude: widget.rentals[index]["location"][0],
                        longitude: widget.rentals[index]["location"][1],
                      )),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 12.0, 18, 0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: SizedBox(
                            height: 300,
                            child: Stack(
                              children: [
                                Container(
                                  color:
                                      const Color.fromARGB(255, 226, 226, 226),
                                ),
                                Scrollbar(
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: widget
                                          .rentals[index]['indoorImages']
                                          .length,
                                      itemBuilder: (context, i) {
                                        final indoorImages = widget
                                            .rentals[index]["indoorImages"];
                                        return FadeInImage.memoryNetwork(
                                          imageErrorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            color: const Color.fromARGB(
                                                255, 226, 226, 226),
                                            child: const Center(
                                              child: Icon(
                                                Icons.error,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                          placeholder: kTransparentImage,
                                          image: indoorImages[i],
                                          fit: BoxFit.cover,
                                          height: 300,
                                          width: 330,
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22.0),
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.black54,
                            child: const FavoriteButton(rentalId: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, bottom: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${widget.rentals[index]['district']}, ${widget.rentals[index]['category']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              // Row(
                              //   children: [
                              //     const Icon(Icons.star, size: 16),
                              //     Text("${widget.rentals[index]['rating']}.0"),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        Text(
                    widget.rentals[index]['bedrooms'] == 1 ?
                    "1 Bedroom":
                    "${widget.rentals[index]['bedrooms']} Bedrooms",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 124, 123, 123),
                    ),
                  ),
                  Text(
                    widget.rentals[index]['bathrooms'] == 1 ?
                    "1 Bathroom":
                    "${widget.rentals[index]['bathrooms']} Bathrooms",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 124, 123, 123),
                    ),
                  ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Text(
                                "UGX ${NumberFormat('#,###').format(widget.rentals[index]['price'])}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                    "per ${widget.rentals[index]['paymentWindow']}"),
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
          );
        });
  }
}
