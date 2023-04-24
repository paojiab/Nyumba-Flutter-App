class SchoolModel {
  final String name;


  const SchoolModel(
      {required this.name,
    });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
        name: json['name'],
        );
  }
}
