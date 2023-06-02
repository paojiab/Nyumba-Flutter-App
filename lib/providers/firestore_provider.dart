import 'package:cloud_firestore/cloud_firestore.dart';

class firestoreProvider {
  final db = FirebaseFirestore.instance;
  List<String> docIds = [];

  Future<List<String>> getRentalIds() async {
   
      QuerySnapshot querySnapshot = await db.collection("Rentals").get();
      for (var docSnapshot in querySnapshot.docs) {
        String id = docSnapshot.id;
        docIds.add(id);
      }
    return (docIds);
  }

   Future<List<String>> getSpecificRentalIds(String term) async {
   
      QuerySnapshot querySnapshot = await db.collection("Rentals").where("category", isEqualTo: term).get();
      for (var docSnapshot in querySnapshot.docs) {
        String id = docSnapshot.id;
        docIds.add(id);
      }
    return (docIds);
  }

  Future getRental(String rentalId) async {
    try {
      final querySnapshot = await db.collection("Rentals").doc(rentalId).get();
      final rental = querySnapshot.data() as Map<String, dynamic>;
      return rental;
    } catch (e) {
      print("Error getting document: $e");
    }
  }

  Future getRentals() async {
    // db.collection("Rentals").get().then(
    //   (querySnapshot) {
    //     print("Successfully completed");
    //     for (var docSnapshot in querySnapshot.docs) {
    //       Map<String, dynamic> data = docSnapshot.data();
    //       String id = docSnapshot.id;
    //       List rental = [];
    //       rental.add(id);
    //       rental.add(data);
    //       // print('${docSnapshot.id} => ${docSnapshot.data()}');
    //       // print(rental[1]['title']);
    //     }
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );
    // print(rentalList);
    try {
      QuerySnapshot querySnapshot = await db.collection("Rentals").get();
      final List rentals =
          querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
      return rentals;
    } catch (e) {
      print("Error completing: $e");
    }
  }
}
