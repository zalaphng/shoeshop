import 'package:flutter/material.dart';
import 'package:shoeshop/helper/others.dart';
import 'package:shoeshop/models/order.dart';
import 'package:shoeshop/models/product.dart';

class OrderDetailPage extends StatelessWidget {

  final UserOrder order;

  const OrderDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id}'),
      ),
      body: ListView.builder(
        itemCount: order.products.length,
        itemBuilder: (context, index) {
          Product product = order.products[index];
          return ListTile(
            leading: Container(
              child: Image.network(
                product.imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(product.name),
            subtitle: Text('${formatCurrency(product.price)}'),
          );
        },
      ),
    );
  }
}
