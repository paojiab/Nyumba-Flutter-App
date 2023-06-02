import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spesnow/views/map/nears.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key, required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late LatLng location;

  late CameraPosition _rental;

  late Marker _rentalMarker;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    location = LatLng(widget.latitude, widget.longitude);
    _rental = CameraPosition(
      target: location,
      zoom: 14.4746,
    );
    _rentalMarker = Marker(
      markerId: const MarkerId('_rental'),
      infoWindow: const InfoWindow(title: 'Rental'),
      icon: markerIcon,
      position: location,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.white,
              width: 40,
              height: 40,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.black,
                    size: 25,
                  )),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.white,
                width: 40,
                height: 40,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => nearByPage(
                                  latitude: widget.latitude,
                                  longitude: widget.longitude)));
                    },
                    icon: const Icon(
                      Icons.near_me,
                      color: Colors.black,
                      size: 25,
                    )),
              ),
            ),
          ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {_rentalMarker},
        initialCameraPosition: _rental,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
