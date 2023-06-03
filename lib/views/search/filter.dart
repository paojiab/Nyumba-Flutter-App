import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spesnow/partials/loading_status.dart';
import 'package:spesnow/providers/algolia.dart';

class FilterPage extends StatefulWidget {
  const FilterPage(
      {super.key,
      required this.query,
      this.parentCategoryFilter,
      this.parentPriceFilter});
  final String query;
  final String? parentCategoryFilter;
  final String? parentPriceFilter;
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String filterParams = "";
  String categoryFilter = "";
  String priceFilter = "";
  String minPriceFilter = "";
  String maxPriceFilter = "";
  LoadingStatus _loadingStatus = LoadingStatus.loading;
  int nbHits = 0;
  double minPrice = 0;
  double maxPrice = 0;
  RangeValues priceRangeValues = const RangeValues(0, 0);
  List<String> categories = [];
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  int priceAverage = 0;
  @override
  void initState() {
    categoryFilter = widget.parentCategoryFilter ?? "";
    priceFilter = widget.parentPriceFilter ?? "";
    filter();
    super.initState();
  }

  @override
  void dispose() {
    minPriceController;
    maxPriceController;
    super.dispose();
  }

  filter() async {
    filterParams = categoryFilter + priceFilter;
    try {
      final response = await AlgoliaProvider()
          .fetchQueries(widget.query, "firestore_rentals", filterParams);
      setState(() {
        nbHits = response['nbHits'];
        final Map<String, dynamic> categoryFacet =
            response['facets']['category'];
        categories = categoryFacet.keys.toList();
        final Map<String, dynamic> priceStats =
            response['facets_stats']['price'];
        priceAverage = priceStats["avg"];
        minPrice = priceStats["min"].toDouble();
        maxPrice = priceStats["max"].toDouble();
        priceRangeValues = RangeValues(minPrice, maxPrice);
        minPriceController.text = priceStats["min"].toString();
        maxPriceController.text = priceStats["max"].toString();
        _loadingStatus = LoadingStatus.successful;
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
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Filters",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.black54,
          ),
        ),
      );
    } else if (_loadingStatus == LoadingStatus.failed) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Filters",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            ),
          ),
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
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Filters",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.clear,
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TextButton(
                onPressed: () {
                  if (filterParams != "") {
                    setState(() {
                      categoryFilter = "";
                      priceFilter = "";
                      _loadingStatus = LoadingStatus.loading;
                    });
                    filter();
                  }
                },
                child: Text(
                  "Clear all",
                  style: TextStyle(
                      color: filterParams != "" ? Colors.black : Colors.black54,
                      decoration: TextDecoration.underline,
                      fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SizedBox(
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
                    Navigator.pop(context, {
                      "categoryFilter": categoryFilter,
                      "priceFilter": priceFilter
                    });
                  },
                  child: Text(
                      nbHits == 1 ? "Show 1 rental" : "Show $nbHits rentals",
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Rental type",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            categoryFilter = priceFilter.isNotEmpty
                                ? "category:'${categories[index]}' AND "
                                : "category:'${categories[index]}'";
                            _loadingStatus = LoadingStatus.loading;
                            filter();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(color: Colors.black54),
                          ),
                          child: Center(
                            child: Text(categories[index]),
                          ),
                        ),
                      ),
                    );
                  })),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Price range",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "The average rent is UGX ${NumberFormat('#,###').format(priceAverage)}.",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: RangeSlider(
                  activeColor: const Color.fromARGB(255, 46, 46, 46),
                  values: priceRangeValues,
                  onChanged: (values) {
                    setState(() {
                      priceRangeValues = values;
                      final startValue =
                          priceRangeValues.start.round().toString();
                      final endValue = priceRangeValues.end.round().toString();
                      minPriceController.text = startValue;
                      maxPriceController.text = endValue;
                      minPriceFilter = startValue;
                      maxPriceFilter = endValue;
                      if (categoryFilter.isNotEmpty && priceFilter.isEmpty) {
                        categoryFilter += " AND ";
                      }
                      priceFilter = "price:$minPriceFilter TO $maxPriceFilter";
                      filter();
                    });
                  },
                  labels: RangeLabels(
                    priceRangeValues.start.round().toString(),
                    priceRangeValues.end.round().toString(),
                  ),
                  min: minPrice,
                  max: maxPrice,
                  divisions: 5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixText: "UGX ",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black54),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black54),
                            ),
                            labelText: "Minimum",
                          ),
                          textAlign: TextAlign.center,
                          controller: minPriceController,
                          onSubmitted: (String min) {
                            setState(() {
                              minPriceFilter = min;
                              if (categoryFilter.isNotEmpty &&
                                  priceFilter.isEmpty) {
                                categoryFilter += " AND ";
                              }
                              if (minPriceFilter.isNotEmpty &&
                                  maxPriceFilter.isNotEmpty) {
                                priceFilter =
                                    "price:$minPriceFilter TO $maxPriceFilter";
                              } else if (maxPriceFilter.isEmpty) {
                                priceFilter = "price >= $minPriceFilter";
                              }
                              filter();
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixText: "UGX ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black54),
                          ),
                          labelText: "Maximum",
                        ),
                        textAlign: TextAlign.center,
                        controller: maxPriceController,
                        onSubmitted: (String max) {
                          setState(() {
                            maxPriceFilter = max;
                            if (categoryFilter.isNotEmpty &&
                                priceFilter.isEmpty) {
                              categoryFilter += " AND ";
                            }
                            if (minPriceFilter.isNotEmpty &&
                                maxPriceFilter.isNotEmpty) {
                              priceFilter =
                                  "price:$minPriceFilter TO $maxPriceFilter";
                            } else if (maxPriceFilter.isEmpty) {
                              priceFilter = "price <= $minPriceFilter";
                            }
                            filter();
                          });
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
