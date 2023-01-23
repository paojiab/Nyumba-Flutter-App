
class Category {
  final int id;
  final String name;
  final String image;
  final String? desc;
  final List? rentals;

  const Category({
    required this.id,
    required this.name,
    required this.image,
    required this.desc,
    required this.rentals,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      desc: json['desc'],
      rentals: json['rentals'],
    );
  }
}
