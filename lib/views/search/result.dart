import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spesnow/components/algolia_rentals_widget.dart';
import 'package:spesnow/partials/loading_status.dart';
import 'package:spesnow/providers/algolia.dart';
import 'package:spesnow/views/property.dart';
import 'package:spesnow/views/search/filter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';

import '../home/home_page.dart';

const List<String> sort = <String>[
  'Popularity',
  'Lowest price',
  'Highest price'
];

class Search extends StatefulWidget {
  Search(
      {super.key, required this.search, this.priceFilter, this.categoryFilter});
  String? priceFilter;
  String? categoryFilter;
  final String search;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String dropdownValue = sort.first;
  String filterParams = "";
  List rentals = [];
  int nbHits = 0;
  String queryID = "";
  String? userToken;
  LoadingStatus _loadingStatus = LoadingStatus.loading;

  @override
  void initState() {
    final initCategoryFilter = widget.categoryFilter ?? "";
    final initPriceFilter = widget.priceFilter ?? "";
    filterParams = initCategoryFilter + initPriceFilter;
    search("firestore_rentals");
    getUserToken();
    super.initState();
  }

  getUserToken() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          userToken = user.uid;
        });
      }
    });
  }

  search(String index) async {
    try {
      final response = await AlgoliaProvider()
          .fetchQueries(widget.search, index, filterParams);
      setState(() {
        _loadingStatus = LoadingStatus.successful;
        rentals = response['hits'];
        queryID = response['queryID'];
        nbHits = response['nbHits'];
      });
    } catch (e) {
      setState(() {
        _loadingStatus = LoadingStatus.failed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingStatus == LoadingStatus.loading) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: Text(
            widget.search,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              icon: const Icon(Icons.search),
              color: Colors.black,
            ),
          ],
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.black54),
        ),
      );
    } else if (_loadingStatus == LoadingStatus.failed) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: Text(
            widget.search,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              icon: const Icon(Icons.search),
              color: Colors.black,
            ),
          ],
        ),
        body: const Center(
          child: Text(
            "Something went wrong",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.search,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            icon: const Icon(Icons.search),
            color: Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              width: double.infinity,
              height: kToolbarHeight,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownButton(
                      value: dropdownValue,
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.white,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        color: Colors.transparent,
                      ),
                      onChanged: (String? value) {
                        if (value == "Lowest price") {
                          setState(() {
                            dropdownValue = value!;
                            _loadingStatus = LoadingStatus.loading;
                          });
                          search("firestore_rentals_price_asc");
                        } else if (value == "Highest price") {
                          setState(() {
                            dropdownValue = value!;
                          });
                          search("firestore_rentals_price_desc");
                        } else {
                          setState(() {
                            dropdownValue = value!;
                          });
                          search("firestore_rentals");
                        }
                      },
                      items: sort.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FilterPage(
                                      query: widget.search,
                                      parentCategoryFilter:
                                          widget.categoryFilter,
                                      parentPriceFilter: widget.priceFilter,
                                    )));
                        if (result != null) {
                          setState(() {
                            widget.priceFilter = result["priceFilter"];
                            widget.categoryFilter = result["categoryFilter"];
                            filterParams =
                                widget.priceFilter! + widget.categoryFilter!;
                            _loadingStatus = LoadingStatus.loading;
                          });
                          search("firestore_rentals");
                        }
                      },
                      child: Row(
                        children: const [
                          Text(
                            'Filters',
                            style: TextStyle(color: Colors.black),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18.0),
                            child: Icon(
                              Icons.tune,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        nbHits == 1 ? "1 Rental" : '$nbHits Rentals',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                AlgoliaRentalsWidget(
                  rentals: rentals,
                  queryID: queryID,
                  userToken: userToken,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
