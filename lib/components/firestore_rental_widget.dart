import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spesnow/partials/animate_route.dart';
import 'package:spesnow/views/home/home_page.dart';
import 'package:transparent_image/transparent_image.dart';

class FirestoreRentalWidget extends StatelessWidget {
  const FirestoreRentalWidget(
      {super.key,
      required this.rental,});
  final Map<String, dynamic> rental;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(AnimateRoute().topToBottom(rental, rental["location"].latitude, rental["location"].longitude)),
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
                                itemCount: rental['indoorImages'].length,
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
                                    image: rental['indoorImages'][index],
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
                          "${rental['district']}, ${rental['category']}",
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
                    rental['bedrooms'] == 1
                        ? "1 Bedroom"
                        : "${rental['bedrooms']} Bedrooms",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 124, 123, 123),
                    ),
                  ),
                  Text(
                    rental['bathrooms'] == 1
                        ? "1 Bathroom"
                        : "${rental['bathrooms']} Bathrooms",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 124, 123, 123),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Text(
                          "UGX ${NumberFormat('#,###').format(rental['price'])}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text("per ${rental['paymentWindow']}"),
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
}
