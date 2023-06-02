import 'package:flutter/material.dart';
import 'package:spesnow/providers/schools_provider.dart';

class nearByPage extends StatefulWidget {
  const nearByPage(
      {super.key, required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;
  @override
  State<nearByPage> createState() => _nearByPageState();
}

class _nearByPageState extends State<nearByPage> {
  bool _hospitals = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: _hospitals
            ? const Text(
                'Nearby Hospitals',
                style: TextStyle(color: Colors.black),
              )
            : const Text(
                'Nearby Schools',
                style: TextStyle(color: Colors.black),
              ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              setState(() {
                _hospitals = !_hospitals;
              });
            },
            icon: const Icon(
              Icons.swipe_vertical_sharp,
              color: Colors.black,
            )),
        actions: [
          IconButton(
            onPressed: (() => Navigator.pop(context)),
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: SchoolProvider()
              .getNearbySchools(_hospitals ? "hospital" : "school", widget.latitude, widget.longitude),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Nothing nearby Found',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
              final schools = snapshot.data!;
              return ListView.builder(
                  itemCount: schools.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text("${index + 1}."),
                      title: Text(schools[index].name),
                    );
                  });
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("An error has ocurred"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(color: Colors.black54),
            );
          })),
    );
  }
}
