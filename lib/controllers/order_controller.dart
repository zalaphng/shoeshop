import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/cart_controller.dart';
import 'package:shoeshop/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoeshop/services/firebase_services.dart';

class OrderController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var orders = <UserOrder>[].obs;

  void placeOrder(CartController cartController) async {
    final orderId = await FirebaseService().getNextOrderId(); // Lấy Id mới

    final user = _auth.currentUser;
    final order = UserOrder(
      id: orderId,
      userId: user!.uid,
      products: cartController.cart.toList(),
      totalPrice: cartController.totalPrice.value,
      status: 0,
      createDate: DateTime.now().toString(),
      updateDate: DateTime.now().toString(),
    );

    final ordersCollection = FirebaseFirestore.instance.collection('Orders');
    await ordersCollection.add(order.toJson());
    cartController.clearCart();
  }

  // void loadOrders() async {
  //   final ordersCollection = FirebaseFirestore.instance.collection('Orders');
  //   final snapshot = await ordersCollection.get();
  //   final ordersList = snapshot.docs.map((doc) => UserOrder.fromJson(doc.data())).toList();
  //   orders.assignAll(ordersList);
  // }

  // real-time

  void loadOrders() {
    final ordersCollection = FirebaseFirestore.instance.collection('Orders');
    ordersCollection.snapshots().listen((snapshot) {
      final ordersList = snapshot.docs.map((doc) => UserOrder.fromJson(doc.data())).toList();
      orders.assignAll(ordersList);
    });
  }

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }
}