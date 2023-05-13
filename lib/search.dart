import 'package:flutter/material.dart';
import 'package:spesnow/filter.dart';
import 'package:spesnow/models/rental.dart';
import 'package:spesnow/pages/filter.dart';
import 'package:spesnow/prop.dart';
import 'package:spesnow/property.dart';
import 'package:spesnow/providers/algolia.dart';
import 'generated/l10n.dart';
import 'providers/spesnow_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

const List<String> sort = <String>['Relevant', 'Lowest price', 'Highest price'];

class Search extends StatefulWidget {
  Search({super.key, required this.search, this.filterParams});

  final String search;
  String? filterParams;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();

  String _sorted = "no";
  String dropdownValue = sort.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _mainScaffoldKey,
      endDrawer: Drawer(
        child: Filter(query: widget.search),
      ),
      appBar: AppBar(
        elevation: 0,
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
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: const Icon(
                    //     Icons.view_module,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.sort, color: Colors.white),
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
                              items: sort.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        // _mainScaffoldKey.currentState?.openEndDrawer();
                        final result = await Navigator.push(
                            context,
                            (MaterialPageRoute(
                                builder: (context) => Filter(
                                      query: widget.search,
                                      filterString: widget.filterParams,
                                    ))));
                        setState(() {
                          widget.filterParams = result;
                        });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.tune,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'FILTERS',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
            if (_sorted == "no") ...[
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                child: FutureBuilder(
                  future: AlgoliaProvider().fetchQueries(
                      widget.search, "rentals", widget.filterParams ?? ""),
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
                        final result = snapshot.data!;
                        final rentals = result['hits'];
                        final queryID = result['queryID'];
                        final nbHits = result['nbHits'];
                        return RentalsList(
                            rentals: rentals, queryID: queryID, nbHits: nbHits);
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
                child: FutureBuilder(
                  future: AlgoliaProvider().fetchQueries(widget.search,
                      "rentals_price_ascending", widget.filterParams ?? ""),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(
                        child: Text('An error has occurred!'),
                      );
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No rentals found'),
                        );
                      } else {
                        final result = snapshot.data!;
                        final rentals = result['hits'];
                        final queryID = result['queryID'];
                        final nbHits = result['nbHits'];
                        return RentalsList(
                            rentals: rentals, queryID: queryID, nbHits: nbHits);
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
                child: FutureBuilder(
                  future: AlgoliaProvider().fetchQueries(widget.search,
                      "rentals_price_descending", widget.filterParams ?? ""),
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
                        final result = snapshot.data!;
                        final rentals = result['hits'];
                        final queryID = result['queryID'];
                        final nbHits = result['nbHits'];
                        return RentalsList(
                            rentals: rentals, queryID: queryID, nbHits: nbHits);
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
  const RentalsList(
      {super.key,
      required this.rentals,
      required this.nbHits,
      required this.queryID});

  final List<dynamic> rentals;
  final String queryID;
  final int nbHits;

  @override
  State<RentalsList> createState() => _RentalsListState();
}

class _RentalsListState extends State<RentalsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(left:8.0),
        //       child: Text(
        //         '${widget.nbHits} Rentals Found',
        //         style: const TextStyle(fontWeight: FontWeight.bold),
        //       ),
        //     ),
        //   ],
        // ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.rentals.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 100), () async {
                      await AlgoliaProvider().sendEvents(
                          widget.queryID,
                          widget.rentals[index]['objectID'],
                          index + 1,
                          "user-1");
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Prop(
                                id: widget.rentals[index]['id'],
                              )),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: const Image(
                          image: AssetImage('images/hero-img.jpg'),
                          height: 80,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 8, 8, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.rentals[index]['district']}, ${widget.rentals[index]['category']}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 4.0),
                                          child: Icon(
                                            Icons.bathtub_outlined,
                                            color: Color.fromARGB(
                                                255, 124, 123, 123),
                                          ),
                                        ),
                                        Text(
                                          (widget.rentals[index]['bathrooms'])
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
                                        (widget.rentals[index]['bedrooms'])
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
                            ),
                            Text(
                                "UGX ${NumberFormat('#,###').format(widget.rentals[index]['price'])} per month"),
                          ],
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
