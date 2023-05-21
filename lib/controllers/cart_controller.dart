import 'package:get/get.dart';
import 'package:shoeshop/models/productt.dart';

class CartController extends GetxController {
  var cart = <Product>[].obs;

  void addToCart(Product product) {
    cart.add(product);
  }

  void removeFromCart(Product product) {
    cart.remove(product);
  }

  void clearCart() {
    cart.clear();
  }

  double get totalPrice => cart.fold(0, (total, product) => total + product.price);
}