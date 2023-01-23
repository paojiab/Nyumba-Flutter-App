
class Rental {
  final int id;
  final String title;
  final String category;
  final int bedrooms;
  final int bathrooms;
  final int kitchens;
  final int price;
  final String timeframe;
  final int promoted;
  final String village;
  final String parish;
  final String subcounty;
  final String? municipality;
  final String district;
  final String country;
  final String updatedAt;
  final int? pets;
  final int? parties;
  final int? smoking;
  final int? furnished;
  final int? renovated;
  final int? guard;
  final String? size;
  final String landlord;
  final String? landlordPhoto;

  const Rental({
    required this.id,
    required this.title,
    required this.category,
    required this.bedrooms,
    required this.bathrooms,
    required this.kitchens,
    required this.price,
    required this.timeframe,
    required this.promoted,
    required this.village,
    required this.parish,
    required this.subcounty,
    required this.municipality,
    required this.district,
    required this.country,
    required this.updatedAt,
    required this.pets,
    required this.parties,
    required this.smoking,
    required this.furnished,
    required this.renovated,
    required this.guard,
    required this.size,
    required this.landlord,
     required this.landlordPhoto,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      bathrooms: json['bathrooms'],
      bedrooms: json['bedrooms'],
      kitchens: json['kitchens'],
      price: json['price'],
      timeframe: json['timeframe'],
      promoted: json['promoted'],
      village: json['village'],
      parish: json['parish'],
      subcounty: json['subcounty'],
      municipality: json['municipality'],
      district: json['district'],
      country: json['country'],
      updatedAt: json['updatedAt'],
      pets: json['pets'],
      parties: json['parties'],
      smoking: json['smoking'],
      furnished: json['furnished'],
      renovated: json['renovated'],
      guard: json['guard'],
      size: json['size'],
      landlord: json['landlord'],
      landlordPhoto: json['landlordPhoto'],
    );
  }
}
