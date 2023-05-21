import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/cart_controller.dart';
import 'package:shoeshop/controllers/order_controller.dart';
import 'package:shoeshop/controllers/product_controller.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/views/cartpage.dart';
import 'package:shoeshop/widgets/product_item.dart';

class HomePage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());
  final OrderController orderController = Get.put(OrderController());
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        actions: [

          Obx(() => userController.isLoggedIn
              ? IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Get.to(CartPage());
            },
          )
              : Container()),

          // IconButton(
          //   icon: Icon(Icons.shopping_cart),
          //   onPressed: () {
          //     Get.to(CartPage());
          //   },
          // ),
        ],
      ),
      body: Obx(() => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: productController.products.length,
        itemBuilder: (context,index) {
          return ProductItem(product: productController.products[index]);
        },
      )),
    );
  }
}