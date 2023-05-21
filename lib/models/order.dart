import 'package:shoeshop/models/productt.dart';

class UserOrder {
  String? id;
  String userId;
  List<Product> products;
  double totalPrice;

  UserOrder({this.id, required this.userId, required this.products, required this.totalPrice});

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'products': products.map((product) => product.toJson()).toList(),
    'totalPrice': totalPrice,
  };

  factory UserOrder.fromJson(Map<String, dynamic> json) {
    return UserOrder(
      id: json['id'],
      userId: json['userId'],
      products: (json['products'] as List<dynamic>)
          .map((productJson) => Product.fromJson(productJson))
          .toList(),
      totalPrice: json['totalPrice'],
    );
  }
}