import 'package:flutter/material.dart';
import 'package:spesnow/providers/schools_provider.dart';

class nearByPage extends StatefulWidget {
  const nearByPage({super.key});

  @override
  State<nearByPage> createState() => _nearByPageState();
}

class _nearByPageState extends State<nearByPage> {
  bool _hospitals = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title:
            _hospitals ? const Text('Hospitals') : const Text('Schools'),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (() => Navigator.pop(context)),
          icon: const Icon(Icons.clear),
        ),
        actions: [
          IconButton(
              onPressed: () {
                  setState(() {
                    _hospitals = !_hospitals;
                  });
              },
              icon: const Icon(Icons.swap_vert))
        ],
      ),
      body: FutureBuilder(
          future: SchoolProvider().getNearbySchools(_hospitals ? "hospital" : "school"),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Nothing nearby Found'),
                );
              }
              final schools = snapshot.data!;
              return ListView.builder(
                  itemCount: schools.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: _hospitals ? const Icon(Icons.local_hospital):const Icon(Icons.school),
                      title: Text(schools[index].name),
                    );
                  });
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("An error has ocurred"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          })),
    );
  }
}
