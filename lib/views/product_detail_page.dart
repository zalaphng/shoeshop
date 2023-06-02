import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/cart_controller.dart';
import 'package:shoeshop/controllers/favourite_controller.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/helper/others.dart';
import 'package:shoeshop/models/product.dart';
import 'package:shoeshop/views/auth/page_login.dart';
import 'package:shoeshop/views/layouts/master_layouts.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final cartController = Get.find<CartController>();
  final userController = Get.find<UserController>();
  final favouriteController = Get.find<FavouriteController>();
  final isFavourite = RxBool(false);
  final uid = FirebaseAuth.instance.currentUser?.uid;

  ProductDetailPage({Key? key, required this.product}) : super(key: key) {

    favouriteController.favourites.listen((List<String> favourites) {
      isFavourite.value = favourites.contains(product.id);
    });

    getIsFavourite();
  }

  void getIsFavourite() async {
    if (uid != null) {
      isFavourite.value =
      await favouriteController.isFavourite(uid!, product.id);
    }
  }

  void toggleFavourite(BuildContext context, String name) async {
    if (uid != null) {
      if (isFavourite.value) {
        favouriteController.removeFavourite(uid!, product.id);
        showSnackBar(context, "Xóa ${name} vào danh sách yêu thích!", 1);
      } else {
        favouriteController.addFavourite(uid!, product.id);
        showSnackBar(context, "Thêm ${name} vào danh sách yêu thích!", 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                product.imageUrl!,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Obx(() => IconButton(
                  icon: Icon(
                    isFavourite.value ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () => toggleFavourite(context, product.name),
                )),
              ]
            ),
            SizedBox(height: 8),
            Text(
              '${formatCurrency(product.price)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (userController.isLoggedIn == true) {
                    cartController.addToCart(product);
                    showSnackBar(context, "Đã thêm ${product.name} vào giỏ hàng!", 2);
                    Get.offAll(() => HomePage());
                  } else {
                    Get.to(() => PageLogin());
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 8),
                    Text('Add to cart'),
                    Icon(Icons.shopping_cart),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}