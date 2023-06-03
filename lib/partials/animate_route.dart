import 'package:flutter/widgets.dart';
import 'package:spesnow/views/property.dart';

class AnimateRoute {
  Route topToBottom(rental, latitude, longitude) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SinglePropertyPage(
      rental: rental,
      latitude: latitude,
      longitude: longitude,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
}