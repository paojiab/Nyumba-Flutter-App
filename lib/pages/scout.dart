import 'package:flutter/material.dart';
import 'package:nyumba/home_page.dart';
import 'package:nyumba/models/rental.dart';
import 'package:nyumba/property.dart';
import 'package:nyumba/providers/location.dart';
import 'package:nyumba/providers/spesnow_provider.dart';
import 'package:http/http.dart' as http;

class ScoutPage extends StatefulWidget {
  const ScoutPage({super.key});

  @override
  State<ScoutPage> createState() => _ScoutPageState();
}

class _ScoutPageState extends State<ScoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: const Text(
          'Scout',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
              child: SizedBox(
                width: double.infinity,
                height: 80,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Current Location',
                          style: TextStyle(
                              color: Color.fromARGB(255, 124, 123, 123),
                              fontSize: 12),
                        ),
                        FutureBuilder(
                            future: getLocation(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text("An error has occurred");
                              } else if (snapshot.hasData) {
                                final location = snapshot.data!;
                                return Text(location.toString());
                              } else {
                                return const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: LinearProgressIndicator(),
                                ));
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                color: Colors.brown,
                height: 45,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    'Rentals near me',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            FutureBuilder(
                future: getLocation(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text((snapshot.error).toString());
                  } else if (snapshot.hasData) {
                    final location = snapshot.data!;
                    return FutureBuilder<List<Rental>>(
                      future: SpesnowProvider().fetchNearestRentals(
                          http.Client(),
                          "${location.longitude}",
                          "${location.latitude}"),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('An error has occurred!'),
                          );
                        } else if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text('No rentals found'),
                              ),
                            );
                          } else {
                            return RentalsList(rentals: snapshot.data!);
                          }
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ));
                  }
                }),
          ],
        ),
      ),
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
        shrinkWrap: true,
        itemCount: widget.rentals.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18, 18, 0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Property(id: widget.rentals[index].id),
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
                        right: 5,
                        child:
                            FavoriteButton(rentalId: widget.rentals[index].id),
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
