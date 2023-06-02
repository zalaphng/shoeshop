import 'package:flutter/material.dart';
import 'package:shoeshop/models/product.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final Function? onRemove;

  CartItem({Key? key, required this.product, this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            child: Image.network(
              product.imageUrl!,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  '${product.price}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_shopping_cart),
            onPressed: () {
              if (onRemove != null) {
                onRemove!();
              }
            },
          ),
        ],
      ),
    );
  }
}