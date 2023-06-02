class CustomUser {
  String id;
  String name;
  String address;
  String imageUrl;
  String phone;

  CustomUser({required this.id, required this.name, required this.address, required this.imageUrl, required this.phone});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'imageUrl': imageUrl,
        'phone': phone,
      };

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      imageUrl: json['imageUrl'],
      phone: json['phone']
    );
  }
}
