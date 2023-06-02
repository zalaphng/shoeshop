import 'package:get/get.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/models/product.dart';
import 'package:shoeshop/views/auth/page_login.dart';

class CartController extends GetxController {
  UserController userController = Get.find<UserController>();

  var cart = <Product>[].obs;
  var totalPrice = 0.0.obs;

  bool addToCart(Product product) {
    if(userController.isLoggedIn == true) {
      cart.add(product);
      _updateTotalPrice();
      return true;
    } else {
      Get.to(() => PageLogin());
      return false;
    }
  }

  void removeFromCart(Product product) {
      cart.remove(product);
      _updateTotalPrice();
  }

  void _updateTotalPrice() {
    double total = 0;
    for (var product in cart) {
      total += product.price;
    }
    totalPrice.value = total;
  }

  void clearCart() {
    cart.clear();
  }

}