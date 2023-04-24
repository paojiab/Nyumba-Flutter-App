import 'package:flutter/material.dart';

import '../providers/algolia.dart';

class perfectFilters extends StatefulWidget {
  perfectFilters({super.key, required this.query, this.filterString});

  final String query;
  String? filterString;

  @override
  State<perfectFilters> createState() => _perfectFiltersState();
}

class _perfectFiltersState extends State<perfectFilters> {
  bool _isLoading = true;
  var nbHits;
  var priceStats;
  var currentRangeValues;
  Map<String, dynamic>? categories;
  List<bool> _isChecked = [];

  @override
  void initState() {
    _query(widget.filterString ?? "");
    super.initState();
  }

  _query(filterString) async {
    final result = await AlgoliaProvider()
        .fetchQueries(widget.query, "rentals", filterString);

    setState(() {
      _isLoading = false;
      nbHits = result['nbHits'];
      priceStats = result['facets_stats']['price'];
      currentRangeValues = RangeValues(
          priceStats['min'].toDouble(), priceStats['max'].toDouble());
      categories = result['facets']['category'];
      _isChecked = List<bool>.filled(categories!.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (categories == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.clear)),
          backgroundColor: Colors.brown,
          centerTitle: true,
          title: const Text(
            //
            "Filters",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (categories!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.clear)),
          backgroundColor: Colors.brown,
          centerTitle: true,
          title: const Text(
            //
            "Filters",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(
          child: Text('No data found.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.clear)),
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: const Text(
          //
          "Filters",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(fontSize: 16),
                  ),
              
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isChecked = List<bool>.filled(10, false);
                        });
                        final data = _query("");
                  setState(() {
                    categories = data['facets']['category'];
                  });
                      },
                      child: const Text('RESET'),
                    ),
                  ],
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: categories!.length,
            itemBuilder: (context, index) {
              print(categories!.length);

              final key = categories!.keys.toList()[index];
              final value = categories!.values.toList()[index];
              return CheckboxListTile(
                value: _isChecked[index],
                onChanged: (val) {
                  setState(() {
                    _isChecked = List<bool>.filled(categories!.length, false);
                    _isChecked[index] = val!;
                  });
                  final data = _query("category:$key");
                  setState(() {
                    categories = data['facets']['category'];
                  });
                },
                title: Text(
                  key,
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: Text('$value Available'),
              );
            },
          ),
          RangeSlider(
            values: currentRangeValues,
            min: priceStats['min'].toDouble(),
            max: priceStats['max'].toDouble(),
            divisions: 5,
            labels: RangeLabels(
              currentRangeValues.start.round().toString(),
              currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                currentRangeValues = values;
              });
            },
          ),
        ],
      )),
    );
  }
}
