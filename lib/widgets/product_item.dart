import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/cart_controller.dart';
import 'package:shoeshop/models/productt.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final CartController cartController = Get.find();

  ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(product.imageUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              cartController.addToCart(product);
              Get.snackbar(
                'Added to cart',
                '${product.name} has been added to your cart.',
              );
            },
            child: Text('Add to cart'),
          ),
        ],
      ),
    );
  }
}