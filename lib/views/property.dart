import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spesnow/providers/firebase_auth_provider.dart';
import 'package:spesnow/views/auth/sign_in.dart';
import 'package:spesnow/views/auth/verify_email.dart';
import 'package:spesnow/components/bottom_modal_keys.dart';
import 'package:spesnow/views/book.dart';
import 'package:spesnow/views/map/map.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SinglePropertyPage extends StatefulWidget {
  const SinglePropertyPage(
      {super.key,
      required this.rental,
      required this.latitude,
      required this.longitude});
  final double latitude;
  final double longitude;
  final Map<String, dynamic> rental;
  @override
  State<SinglePropertyPage> createState() => _SinglePropertyPageState();
}

class _SinglePropertyPageState extends State<SinglePropertyPage> {
  bool _isUnlocked = false;
  late int keys;
  bool _isLoggedIn = false;
  Map<String, dynamic> _user = {};

  @override
  void initState() {
    _getKeys();
    _checkLogin();
    super.initState();
  }

  _getKeys() async {
    final prefs = await SharedPreferences.getInstance();
    keys = prefs.getInt('keys') ?? 0;
  }

  _checkLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          _isLoggedIn = false;
        });
      } else {
        _user = firebaseAuth().getUser();
        setState(() {
          _isLoggedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 70.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color.fromARGB(255, 226, 226, 226)),
          ),
        ),
        child: !_isUnlocked
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Unlock details',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black54),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Unlock', style: TextStyle(fontSize: 16)),
                          Row(
                            children: const [
                              Text(
                                "5",
                                style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: Icon(
                                  Icons.vpn_key,
                                  color: Colors.yellow,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (!_isLoggedIn) {
                          showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) => const Login(),
                          );
                        } else if (_isLoggedIn) {
                          if (!_user['emailVerified']) {
                            showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => const verifyEmailPage(),
                            );
                          } else if (keys < 5) {
                            showBottomModalKeys(
                                context, _user["name"], _user["email"]);
                          } else {
                            showUnlockDialog();
                          }
                        }
                      },
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Book a Tour',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.brown),
                      ),
                      child: const Text('Book', style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          _isUnlocked
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapSample(
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.map_outlined,
                            color: Colors.black, size: 16),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: Colors.white,
              ),
              child: Center(
                child: IconButton(
                  onPressed: () {
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
                  icon: const Icon(Icons.favorite_outline_rounded,
                      size: 16, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            child: Center(
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 16,
                  )),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          final prefs = await SharedPreferences.getInstance();
          setState(() {
            keys = prefs.getInt('keys') ?? 0;
          });
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 320,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.rental["indoorImages"].length,
                    itemBuilder: ((context, index) {
                      final indoorImages = widget.rental["indoorImages"];
                      return Stack(
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 226, 226, 226),
                          ),
                          FadeInImage.memoryNetwork(
                            width: 360,
                            height: 320,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: const Color.fromARGB(255, 226, 226, 226),
                              width: 360,
                              height: 320,
                              child: const Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            placeholder: kTransparentImage,
                            image: indoorImages[index],
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                              bottom: 10,
                              right: 5,
                              child: Container(
                                  width: 40,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "${index + 1}/${indoorImages.length}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )))),
                        ],
                      );
                    })),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 8.0),
                child: Text(
                  "${widget.rental['title']}.",
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 8, 8, 0),
                child: Text(
                    "${widget.rental['district']}, ${widget.rental['county']}"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 8, 8, 8),
                child: Text(
                  "UGX ${NumberFormat('#,###').format(widget.rental['price'])} a ${widget.rental['paymentWindow']}",
                  style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.fromLTRB(18.0, 8, 18, 8),
                child: Text(
                  "Landlord is currently running a 25% discount on 1 year payments.",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 110,
                      height: 115,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: const Border(
                          top: BorderSide(color: Colors.black54),
                          bottom: BorderSide(color: Colors.black54),
                          left: BorderSide(color: Colors.black54),
                          right: BorderSide(color: Colors.black54),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.bed),
                          ),
                          Text(widget.rental['bedrooms'] == 1
                              ? "1 Bedroom"
                              : "${widget.rental['bedrooms']} Bedrooms"),
                        ],
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 115,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: const Border(
                          top: BorderSide(color: Colors.black54),
                          bottom: BorderSide(color: Colors.black54),
                          left: BorderSide(color: Colors.black54),
                          right: BorderSide(color: Colors.black54),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.bathtub_outlined),
                          ),
                          Text(widget.rental['bathrooms'] == 1
                              ? "1 Bathroom"
                              : "${widget.rental['bathrooms']} Bathrooms"),
                        ],
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 115,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: const Border(
                          top: BorderSide(color: Colors.black54),
                          bottom: BorderSide(color: Colors.black54),
                          left: BorderSide(color: Colors.black54),
                          right: BorderSide(color: Colors.black54),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.kitchen),
                          ),
                          Text(widget.rental['kitchens'] == 1
                              ? "1 Kitchen"
                              : "${widget.rental['kitchens']} Kitchens"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Card(
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                            255, 226, 226, 226),
                                        backgroundImage: NetworkImage(
                                            widget.rental['landlordPhoto']),
                                        radius: 50,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 5,
                                        child: Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            color: Colors.brown,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.verified_user,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.rental['landlordName'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  const Text(
                                    "Verified Landlord",
                                    style: TextStyle(
                                      letterSpacing: 1.5,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                          "Property Rules",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18.0, 0, 8, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "No pets",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "No parties or events",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "No smoking",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "No students",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "No teachers",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "No children",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "1 resident maximum",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "6 months down payment",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                          "Amenities",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18.0, 0, 8, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.local_parking,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Free Parking",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.wifi,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Wifi",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.tv,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "TV",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.camera_outdoor,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Security cameras",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.local_laundry_service_outlined,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Laundry machine",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.local_florist,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Garden",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.elevator_outlined,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Lift",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.pool,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Swimming pool",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.sports_gymnastics,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Gym",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.fence,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Gate",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.chair,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Furnished",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.ac_unit,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Air conditioning",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.apartment,
                                  size: 22,
                                  color: Colors.black54,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Balcony",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 100, 100, 100),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                          "Outdoor",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 320,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: widget.rental['outdoorImages'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      color: const Color.fromARGB(
                                          255, 226, 226, 226),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.memoryNetwork(
                                        imageErrorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          color: const Color.fromARGB(
                                              255, 226, 226, 226),
                                          width: 320,
                                          height: 320,
                                          child: const Center(
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                        placeholder: kTransparentImage,
                                        image: widget.rental['outdoorImages']
                                            [index],
                                        fit: BoxFit.cover,
                                        width: 320,
                                        height: 320,
                                      ),
                                    ),
                                    Positioned(
                                        top: 5,
                                        right: 5,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                              width: 40,
                                              height: 20,
                                              color: Colors.black54,
                                              child: Center(
                                                child: Text(
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                  "${index + 1}/${widget.rental['outdoorImages'].length}",
                                                ),
                                              )),
                                        ))
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  !_isUnlocked
                      ? Positioned.fill(
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                // color: Colors.grey.withOpacity(0.5),
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showUnlockDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Set the desired border radius
          ),
          title: const Text(
            'Are you sure you want to proceed?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          content: Text(
            "5 keys will be deducted from your wallet. You have $keys keys left.",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          contentPadding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
          actions: [
            Column(
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black54),
                        ),
                        child: const Text(
                          'Unlock',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          Future.delayed(const Duration(milliseconds: 10),
                              () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setInt('keys', keys - 5);
                          });
                          setState(() {
                            _isUnlocked = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black,
                              content: const Text('Rental has been unlocked'),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
