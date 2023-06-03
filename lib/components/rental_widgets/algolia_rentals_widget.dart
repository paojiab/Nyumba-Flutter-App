import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spesnow/providers/algolia.dart';
import 'package:spesnow/views/home/home_page.dart';
import 'package:spesnow/views/property.dart';
import 'package:transparent_image/transparent_image.dart';

class AlgoliaRentalsWidget extends StatelessWidget {
  const AlgoliaRentalsWidget(
      {super.key, required this.rentals, this.queryID, this.userToken});
  final List rentals;
  final String? queryID;
  final String? userToken;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: rentals.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (queryID != null) {
                 Future.delayed(const Duration(milliseconds: 100), () async {
                await AlgoliaProvider().sendEvents(
                    queryID!,
                    rentals[index]['objectID'],
                    index + 1,
                    userToken ?? "anonymous");
              });
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SinglePropertyPage(
                          rental: rentals[index],
                          latitude: rentals[index]["location"][0],
                          longitude: rentals[index]["location"][1],
                        )),
              );
            },
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
                                      itemCount:
                                          rentals[index]['indoorImages'].length,
                                      itemBuilder: (context, i) {
                                        final indoorImages =
                                            rentals[index]["indoorImages"];
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
                                "${rentals[index]['district']}, ${rentals[index]['category']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              // Row(
                              //   children: [
                              //     const Icon(Icons.star, size: 16),
                              //     Text("${rentals[index]['rating']}.0"),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        Text(
                          rentals[index]['bedrooms'] == 1
                              ? "1 Bedroom"
                              : "${rentals[index]['bedrooms']} Bedrooms",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 124, 123, 123),
                          ),
                        ),
                        Text(
                          rentals[index]['bathrooms'] == 1
                              ? "1 Bathroom"
                              : "${rentals[index]['bathrooms']} Bathrooms",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 124, 123, 123),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Text(
                                "UGX ${NumberFormat('#,###').format(rentals[index]['price'])}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                    "per ${rentals[index]['paymentWindow']}"),
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
