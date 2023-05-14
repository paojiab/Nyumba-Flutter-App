import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spesnow/models/school.dart';
import 'package:spesnow/pages/nears.dart';
import 'package:spesnow/providers/schools_provider.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();

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
       key: _mainScaffoldKey,
        endDrawer: const Drawer(
      child: nearByPage(),
    ),
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
        actions: [
          Container(),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: {_rentalMarker},
            initialCameraPosition: _rental,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 0,
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _mainScaffoldKey.currentState?.openEndDrawer(), child: const Text('Nearby')),
          )),
        ],
      ),
    );
  }
}
