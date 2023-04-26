import 'package:flutter/material.dart';
import 'package:spesnow/providers/algolia.dart';
import 'package:spesnow/search.dart';
import 'generated/l10n.dart';

class Filter extends StatefulWidget {
  Filter({super.key, required this.query, this.filterString});

  final String query;
  String? filterString;

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  bool toggled = false;

  List<bool> _isChecked = List<bool>.filled(10, false);

  late RangeValues currentRangeValues;

  @override
  void initState() {
    if (widget.filterString != null) {
      // toggled = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  if (widget.filterString != null) ...[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          widget.filterString = null;
                          // toggled = false;
                          _isChecked = List<bool>.filled(10, false);
                        });
                      },
                      child: const Text('RESET'),
                    ),
                  ],
                ],
              ),
            ),
            FutureBuilder(
              future: AlgoliaProvider().fetchQueries(
                  widget.query, "rentals", widget.filterString ?? ""),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // print(snapshot.error);
                  return const Center(
                    child: Text('An error has occurred!'),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No data found'),
                    );
                  } else {
                    final result = snapshot.data!;
                    final nbHits = result['nbHits'];
                    final priceStats = result['facets_stats']['price'];
                     currentRangeValues = RangeValues(
                        priceStats['min'].toDouble(),
                        priceStats['max'].toDouble());
                    final Map<String, dynamic> categories =
                        result['facets']['category'];
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            final key = categories.keys.toList()[index];
                            // final key = categories.keys.elementAt(index);
                            final value = categories.values.toList()[index];

                            return CheckboxListTile(
                              value: _isChecked[index],
                              onChanged: (_) {
                                setState(() {
                                  widget.filterString = "category:$key";
                                  _isChecked[index] = true;
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
                       
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, widget.filterString);
                            },
                            child: Text('Save ($nbHits)'),
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


