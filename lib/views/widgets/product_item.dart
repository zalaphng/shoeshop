import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/cart_controller.dart';
import 'package:shoeshop/controllers/favourite_controller.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/helper/others.dart';
import 'package:shoeshop/models/product.dart';
import 'package:shoeshop/views/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final CartController cartController = Get.find();
  final FavouriteController favouriteController = Get.find();
  final UserController userController = Get.find();
  final isFavourite = RxBool(false);
  final uid = FirebaseAuth.instance.currentUser?.uid;

  ProductItem({Key? key, required this.product}) : super(key: key) {

    favouriteController.favourites.listen((List<String> favourites) {
      isFavourite.value = favourites.contains(product.id);
    });

    getIsFavourite();
  }

  void getIsFavourite() async {
    if (userController.isLoggedIn != false) {
      if (uid != null) {
        isFavourite.value =
        await favouriteController.isFavourite(uid!, product.id);
      }
    }
  }

  void toggleFavourite(BuildContext context, String name) async {
    if (userController.isLoggedIn != false){
      if (uid != null) {
        if (isFavourite.value) {
          favouriteController.removeFavourite(uid!, product.id);
          showSnackBar(context, "Xóa ${name} vào danh sách yêu thích!", 1);
        } else {
          favouriteController.addFavourite(uid!, product.id);
          showSnackBar(context, "Thêm ${name} vào danh sách yêu thích!", 1);
        }
      }
    } else {
      showSnackBar(context, "Chưa đăng nhập!", 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            child: Wrap(
              children: [
                // SizedBox(
                //   height: 200,
                //   child: Image.network(product.imageUrl!),
                // ),
                CachedNetworkImage(
                  height: 200,
                  width: 200,
                  imageUrl: product.imageUrl!,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontSize: 16,),
                    ),
                    const Spacer(),
                    Obx(() => IconButton(
                      onPressed: () => toggleFavourite(context, product.name),
                      icon: Icon(
                        isFavourite.value
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    )),
                  ]),
                ),
              ],
            ),
            onTap: () {
              Get.to(() => ProductDetailPage(product: product));
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Row(
              children: [
                Text(
                  '${formatCurrency(product.price)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    cartController.addToCart(product);
                    showSnackBar(context, "Đã thêm ${product.name} vào giỏ hàng!", 2);
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


