import 'package:flutter/material.dart';
import 'package:spesnow/components/firestore_rental_widget.dart';
import 'package:spesnow/providers/firestore_provider.dart';

class HomepageRentals extends StatelessWidget {
  const HomepageRentals({super.key, required this.rentalId});
  final String rentalId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firestoreProvider().getRental(rentalId),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const SizedBox(
              width: double.infinity,
              height: 500,
              child: Center(
                child: Text(
                  "No rentals found",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          } else {
            final rental = snapshot.data!;
            return FirestoreRentalWidget(rental: rental);
          }
        } else if (snapshot.hasError) {
          return const SizedBox(
            width: double.infinity,
            height: 500,
            child: Center(
              child: Icon(
                Icons.error,
                color: Colors.black54,
              ),
            ),
          );
        }
        return const SizedBox(
          width: double.infinity,
          height: 500,
          child: Center(
            child: Text(
              "Loading",
              style: TextStyle(color: Colors.transparent),
            ),
          ),
        );
      }),
    );
  }
}
