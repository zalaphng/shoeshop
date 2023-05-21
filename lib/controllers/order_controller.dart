import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/cart_controller.dart';
import 'package:shoeshop/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var orders = <UserOrder>[].obs;

  void placeOrder(CartController cartController) async {
    final user = _auth.currentUser;
    final order = UserOrder(
      userId: user!.uid, // Thay đổi thành userId của người dùng đang đăng nhập
      products: cartController.cart.toList(),
      totalPrice: cartController.totalPrice,
    );

    final ordersCollection = FirebaseFirestore.instance.collection('orders');
    await ordersCollection.add(order.toJson());
    cartController.clearCart();
  }

  void loadOrders() async {
    final ordersCollection = FirebaseFirestore.instance.collection('orders');
    final snapshot = await ordersCollection.get();
    final ordersList = snapshot.docs.map((doc) => UserOrder.fromJson(doc.data())).toList();
    orders.assignAll(ordersList);
  }
}