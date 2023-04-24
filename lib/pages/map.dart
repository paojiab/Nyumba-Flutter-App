import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spesnow/models/school.dart';
import 'package:spesnow/providers/schools_provider.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _rental = CameraPosition(
    target: LatLng(0.0524447, 32.4613937),
    zoom: 14.4746,
  );

  static const Marker _rentalMarker = Marker(
    markerId: MarkerId('_rental'),
    infoWindow: InfoWindow(title: 'Rental'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(0.0524447, 32.4613937),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: const Text('Map'),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: {_rentalMarker},
                initialCameraPosition: _rental,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            FutureBuilder<List<SchoolModel>>(
              future: SchoolProvider().getNearbySchools(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Something went wrong!'),
                    ),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No schools found'),
                    );
                  } else {
                    return SchoolsList(schools: snapshot.data!);
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
            ),
          ],
        ),
      ),
    );
  }
}

class SchoolsList extends StatelessWidget {
  const SchoolsList({super.key, required this.schools});
  final List<SchoolModel> schools;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: schools.length,
        itemBuilder: (context, index) {
          return DataTable(columns: const [
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ], rows: [
            DataRow(
              cells: [
                DataCell(
                  Text(schools[index].name),
                ),
              ],
            ),
          ]);
        });
  }
}
