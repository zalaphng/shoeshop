import 'package:shoeshop/models/product.dart';

class UserOrder {
  String? id;
  String userId;
  List<Product> products;
  double totalPrice;
  int status;
  String createDate;
  String updateDate;

  UserOrder(
      {required this.id,
      required this.userId,
      required this.products,
      required this.totalPrice,
      required this.status,
      required this.createDate,
      required this.updateDate,
      });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'products': products.map((product) => product.toJson()).toList(),
        'totalPrice': totalPrice,
        'status': status,
        'create_date': createDate,
        'update_date': updateDate,
      };

  factory UserOrder.fromJson(Map<String, dynamic> json) {
    return UserOrder(
      id: json['id'],
      userId: json['userId'],
      products: (json['products'] as List<dynamic>)
          .map((productJson) => Product.fromJson(productJson))
          .toList(),
      totalPrice: json['totalPrice'],
      status: json['status'],
      createDate: json['create_date'],
      updateDate: json['update_date']
    );
  }
}
