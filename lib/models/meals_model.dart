class MealsModel {
  late final String id;
  late final String name;
  late final String description;
  late final String imageUrl;
  late final String price;

  MealsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  MealsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    imageUrl = json['imageUrl'] ?? '';
    price = json['price'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory MealsModel.fromMap(Map<String, dynamic> map) {
    return MealsModel(
      name: map['name'].toString(),
      price: map['price'].toString(),
      id: map['id'].toString(),
      description: map['description'].toString(),
      imageUrl: map['imageUrl'].toString(),
    );
  }
}
