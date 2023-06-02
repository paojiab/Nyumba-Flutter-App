import 'package:geolocator/geolocator.dart';

Future<Position> getLocation() async {
  bool gpsEnabled;
  LocationPermission permission;

// check if gps is enabled
  gpsEnabled = await Geolocator.isLocationServiceEnabled();

  // if GPS is not enabled
  // if (!gpsEnabled) {
  //   return Future.error('Location services are disabled.');
  // }

// if GPS is enabled, check location permission
  permission = await Geolocator.checkPermission();

  // if permission is denied, re-request permission
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  // if permission is denied
    // if (permission == LocationPermission.denied) {
    //   return Future.error('Location permissions are denied');
    // }
  }
  // if permission is denied forever
  // if (permission == LocationPermission.deniedForever) {
  //   return Future.error(
  //       'Location permissions are permanently denied, we cannot request permissions.');
  // }
  
  Position position = await Geolocator.getCurrentPosition();
  return position;
}
