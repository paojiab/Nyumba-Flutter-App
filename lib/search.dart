import 'package:flutter/material.dart';
import 'package:nyumba/filter.dart';
import 'package:nyumba/models/rental.dart';
import 'package:nyumba/prop.dart';
import 'package:nyumba/property.dart';
import 'generated/l10n.dart';
import 'providers/spesnow_provider.dart';
import 'package:http/http.dart' as http;

const List<String> sort = <String>['Relevant', 'Lowest price', 'Highest price'];

class Search extends StatefulWidget {
  const Search({super.key, required this.search});

  final String search;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _sorted = "no";
  String dropdownValue = sort.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(widget.search),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            icon: const Icon(Icons.search),
            color: Colors.white,
          ),
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
            Container(
              color: Colors.brown,
              width: double.infinity,
              height: kToolbarHeight,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.view_module,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(canvasColor: Colors.brown),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          elevation: 16,
                          style: const TextStyle(color: Colors.white),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            if (value == "Lowest price") {
                              setState(() {
                                dropdownValue = value!;
                                _sorted = "lp";
                              });
                            } else if (value == "Highest price") {
                              setState(() {
                                dropdownValue = value!;
                                _sorted = "hp";
                              });
                            } else {
                              setState(() {
                                dropdownValue = value!;
                                _sorted = "no";
                              });
                            }
                          },
                          items: sort
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const Filter())));
                        },
                        child: const Text(
                          'FILTERS',
                          style: TextStyle(color: Colors.white),
                        )),
                  ]),
            ),
            if (_sorted == "no") ...[
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                child: FutureBuilder<List<Rental>>(
                  future: SpesnowProvider()
                      .fetchSearchRentals(http.Client(), widget.search),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // print(snapshot.error);
                      return const Center(
                        child: Text('An error has occurred!'),
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ] else if (_sorted == "lp") ...[
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                child: FutureBuilder<List<Rental>>(
                  future: SpesnowProvider()
                      .fetchSortedRentals(http.Client(), widget.search, "asc"),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // print(snapshot.error);
                      return const Center(
                        child: Text('An error has occurred!'),
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ] else if (_sorted == "hp") ...[
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                child: FutureBuilder<List<Rental>>(
                  future: SpesnowProvider()
                      .fetchSortedRentals(http.Client(), widget.search, "desc"),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // print(snapshot.error);
                      return const Center(
                        child: Text('An error has occurred!'),
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
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
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.rentals.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Prop(
                              id: widget.rentals[index].id,
                            )),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: const Image(
                              image: AssetImage('images/hero-img.jpg'),
                              height: 60,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 8, 8, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.rentals[index].district}, ${widget.rentals[index].category}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 4.0),
                                            child: Icon(
                                              Icons.bathtub_outlined,
                                              color: Color.fromARGB(
                                                  255, 124, 123, 123),
                                            ),
                                          ),
                                          Text(
                                            (widget.rentals[index].bathrooms)
                                                .toString(),
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 124, 123, 123),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 4.0),
                                          child: Icon(
                                            Icons.bed,
                                            color: Color.fromARGB(
                                                255, 124, 123, 123),
                                          ),
                                        ),
                                        Text(
                                          (widget.rentals[index].bedrooms)
                                              .toString(),
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 124, 123, 123),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                    "UGX ${widget.rentals[index].price} per month"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () async {},
                          icon: const Icon(Icons.favorite_border),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}
