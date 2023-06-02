import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class RentalModel {
  final int bathrooms;
  final int bedrooms;
  final int kitchens;
  final int dinningRooms;
  final int price;
  final int rentalUnits;
  final int vacantUnits;
  final int propertyFloors;
  final int rating;
  final String size;
  final String description;
  final String country;
  final String district;
  final String county;
  final String subcounty;
  final String parish;
  final String village;
  final String category;
  final String status;
  final String title;
  final String landlordName;
  final String landlordPhoto;
  final String landlordContact;
  final String discount;
  final String paymentWindow;
  final String downPayment;
  final List indoorImages;
  final List outdoorImages;
  final List amenities;
  final List vacantFloors;
  final bool pets;
  final bool children;
  final bool students;
  final bool furnished;
  final bool teachers;
  final bool parking;
  final bool parties;
  final bool smoking;
  final bool securityGuard;
  final bool gate;
  final bool newlyRenovated;
  final bool sponsored;
  final bool playGround;
  final bool garden;
  final Position location;

  const RentalModel({
    required this.size,
    required this.description,
    required this.amenities,
    required this.bathrooms,
    required this.bedrooms,
    required this.kitchens,
    required this.dinningRooms,
    required this.price,
    required this.rentalUnits,
    required this.vacantUnits,
    required this.propertyFloors,
    required this.rating,
    required this.country,
    required this.district,
    required this.county,
    required this.subcounty,
    required this.parish,
    required this.village,
    required this.category,
    required this.status,
    required this.title,
    required this.landlordName,
    required this.landlordPhoto,
    required this.landlordContact,
    required this.discount,
    required this.paymentWindow,
    required this.downPayment,
    required this.indoorImages,
    required this.outdoorImages,
    required this.vacantFloors,
    required this.pets,
    required this.children,
    required this.students,
    required this.furnished,
    required this.teachers,
    required this.parking,
    required this.parties,
    required this.smoking,
    required this.securityGuard,
    required this.gate,
    required this.newlyRenovated,
    required this.sponsored,
    required this.playGround,
    required this.garden,
    required this.location,
  });

  factory RentalModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return RentalModel(
      size: data?['size'],
      description: data?['description'],
      amenities: data?['amenities'],
      bathrooms: data?['bathrooms'],
      bedrooms: data?['bedrooms'],
      kitchens: data?['kitchens'],
      dinningRooms: data?['dinningRooms'],
      price: data?['price'],
      rentalUnits: data?['rentalUnits'],
      vacantUnits: data?['vacantUnits'],
      propertyFloors: data?['propertyFloors'],
      rating: data?['rating'],
      country: data?['country'],
      district: data?['district'],
      county: data?['county'],
      subcounty: data?['subcounty'],
      parish: data?['parish'],
      village: data?['village'],
      category: data?['category'],
      status: data?['status'],
      title: data?['title'],
      landlordName: data?['landlordName'],
      landlordPhoto: data?['landlordPhoto'],
      landlordContact: data?['landlordContact'],
      discount: data?['discount'],
      paymentWindow: data?['paymentWindow'],
      downPayment: data?['downPayment'],
      indoorImages: data?['indoorImages'],
      outdoorImages: data?['outdoorImages'],
      vacantFloors: data?['vacantFloors'],
      pets: data?['pets'],
      children: data?['children'],
      students: data?['students'],
      furnished: data?['furnished'],
      teachers: data?['teachers'],
      parking: data?['parking'],
      parties: data?['parties'],
      smoking: data?['smoking'],
      securityGuard: data?['securityGuard'],
      gate: data?['gate'],
      newlyRenovated: data?['newlyRenovated'],
      sponsored: data?['sponsored'],
      playGround: data?['playGround'],
      garden: data?['garden'],
      location: data?['location'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'size': size,
      'description': description,
      'amenities': amenities,
      'bathrooms': bathrooms,
      'bedrooms': bedrooms,
      'kitchens': kitchens,
      'dinningRooms': dinningRooms,
      'price': price,
      'rentalUnits': rentalUnits,
      'vacantUnits': vacantUnits,
      'propertyFloors': propertyFloors,
      'rating': rating,
      'country': country,
      'district': district,
      'county': county,
      'subcounty': subcounty,
      'parish': parish,
      'village': village,
      'category': category,
      'status': status,
      'title': title,
      'landlordName': landlordName,
      'landlordPhoto': landlordPhoto,
      'landlordContact': landlordContact,
      'discount': discount,
      'paymentWindow': paymentWindow,
      'downPayment': downPayment,
      'indoorImages': indoorImages,
      'outdoorImages': outdoorImages,
      'vacantFloors': vacantFloors,
      'pets': pets,
      'children': children,
      'students': students,
      'furnished': furnished,
      'teachers': teachers,
      'parking': parking,
      'parties': parties,
      'smoking': smoking,
      'securityGuard': securityGuard,
      'gate': gate,
      'newlyRenovated': newlyRenovated,
      'sponsored': sponsored,
      'playGround': playGround,
      'garden': garden,
      'location': location,
    };
  }
}
