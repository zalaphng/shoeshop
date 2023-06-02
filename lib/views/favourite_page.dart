import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/favourite_controller.dart';
import 'package:shoeshop/controllers/product_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/models/product.dart';
import 'package:shoeshop/views/product_detail_page.dart';

class FavouritePage extends StatelessWidget {
  final FavouriteController favouriteController = Get.find();
  final ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {

    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: StreamBuilder<List<String>>(
        stream: favouriteController.getFavourites(userId),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<String> favorites = snapshot.data ?? [];

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (BuildContext context, int index) {
              String productId = favorites[index];
              Product product = productController.products.firstWhere((product) => product.id == productId);

              return ListTile(
                leading: Image.network(
                  product.imageUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailPage(product: product,)),
                ),
                trailing: IconButton(
                  onPressed: () {
                    favouriteController.removeFavourite(userId, productId);
                    showSnackBar(context, "Xóa ${product.name} vào danh sách yêu thích!", 1);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}