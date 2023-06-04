import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/cart_controller.dart';
import 'package:shoeshop/controllers/favourite_controller.dart';
import 'package:shoeshop/controllers/order_controller.dart';
import 'package:shoeshop/controllers/product_controller.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/views/widgets/product_item.dart';



class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductController productController = Get.put(ProductController());

  final CartController cartController = Get.put(CartController());

  final OrderController orderController = Get.put(OrderController());

  final FavouriteController favoriteController = Get.put(FavouriteController());

  final UserController userController = Get.find<UserController>();


  @override
  Widget build(BuildContext context) {

    return Obx(() => GridView.builder(
      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: 2,
      //   childAspectRatio: 0.5,
      // ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 0.7,
      ),
      itemCount: productController.products.length,
      itemBuilder: (context,index) {
        return ProductItem(product: productController.products[index]);
      },
    ));
  }
}