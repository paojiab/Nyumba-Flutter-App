import 'package:flutter/material.dart';
import 'package:spesnow/components/algolia_rentals_widget.dart';
import 'package:spesnow/partials/loading_status.dart';
import 'package:spesnow/providers/algolia.dart';
import 'package:spesnow/providers/location.dart';
import 'package:geocoding/geocoding.dart';

class ScoutPage extends StatefulWidget {
  const ScoutPage({super.key});

  @override
  State<ScoutPage> createState() => _ScoutPageState();
}

class _ScoutPageState extends State<ScoutPage> {
  String? locale = "Show my location";
  double lat = 0;
  double lng = 0;
  LoadingStatus _loadingStatus = LoadingStatus.loading;
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
        _loadingStatus = LoadingStatus.successful;
      });
    } catch (e) {
      setState(() {
        _loadingStatus = LoadingStatus.failed;
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
    if (_loadingStatus == LoadingStatus.loading) {
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
    } else if (_loadingStatus == LoadingStatus.failed) {
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black54),
                ),
                onPressed: () {
                  setState(() {
                    _loadingStatus = LoadingStatus.loading;
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
                            child: Center(
                                child: Text(
                              "Couldn't load rentals",
                              style: TextStyle(fontSize: 16),
                            ))),
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
                      return AlgoliaRentalsWidget(rentals: snapshot.data!);
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
