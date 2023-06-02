import 'package:flutter/material.dart';
import 'package:spesnow/providers/firestore_provider.dart';
import 'package:intl/intl.dart';
import 'package:spesnow/views/property.dart';
import 'home_page.dart';
import 'package:transparent_image/transparent_image.dart';

class HomepageRentals extends StatelessWidget {
  HomepageRentals({super.key, required this.rentalId});
  String rentalId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firestoreProvider().getRental(rentalId),
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
            final rental = snapshot.data!;
            return SingleRental(rental: rental, id: rentalId);
          }
        } else if (snapshot.hasError) {
          return const SizedBox(
            width: double.infinity,
            height: 500,
            child: Center(
              child: Icon(
                Icons.error,
                color: Colors.black54,
              ),
            ),
          );
        }
        return const SizedBox(
          width: double.infinity,
          height: 500,
          child: Center(
            child: Text(
              "Loading",
              style: TextStyle(color: Colors.transparent),
            ),
          ),
        );
      }),
    );
  }
}

class SingleRental extends StatefulWidget {
  const SingleRental({super.key, required this.rental, required this.id});
  final Map<String, dynamic> rental;
  final String id;
  @override
  State<SingleRental> createState() => _SingleRentalState();
}

class _SingleRentalState extends State<SingleRental> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(_createRoute()),
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
                            color: const Color.fromARGB(255, 226, 226, 226),
                          ),
                          Scrollbar(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: widget.rental['indoorImages'].length,
                                itemBuilder: (context, index) {
                                  return FadeInImage.memoryNetwork(
                                    imageErrorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: 300,
                                      width: 330,
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
                                    image: widget.rental['indoorImages'][index],
                                    fit: BoxFit.cover,
                                    width: 330,
                                    height: 300,
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
                          "${widget.rental['district']}, ${widget.rental['category']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Row(
                        //   children: [
                        //     const Icon(Icons.star, size: 16),
                        //     Text("${widget.rental['rating']}.0"),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Text(
                    widget.rental['bedrooms'] == 1 ?
                    "1 Bedroom":
                    "${widget.rental['bedrooms']} Bedrooms",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 124, 123, 123),
                    ),
                  ),
                  Text(
                    widget.rental['bathrooms'] == 1 ?
                    "1 Bathroom":
                    "${widget.rental['bathrooms']} Bathrooms",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 124, 123, 123),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Text(
                          "UGX ${NumberFormat('#,###').format(widget.rental['price'])}",
                          style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text("per ${widget.rental['paymentWindow']}"),
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
  }

   Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SinglePropertyPage(
                    rental: widget.rental,
                    latitude: widget.rental["location"].latitude,
                    longitude: widget.rental["location"].longitude,
                  ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
}


