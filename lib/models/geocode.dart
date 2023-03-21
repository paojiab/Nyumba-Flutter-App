class Geocode {
  final String street;
  final String country;
  final String locality;

  const Geocode({
    required this.street,
    required this.country,
    required this.locality,
  });

  factory Geocode.fromJson(Map<String, dynamic> json) {
    return Geocode(
      street: json['Street'], 
    country: json['Country'],
    locality: json['Locality'],
    );
  }
}
