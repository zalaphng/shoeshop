import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/cart_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoeshop/services/firebase_services.dart';

class OrderAdminController extends GetxController {
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
      updateDate: DateTime.now().toString()
    );

    final ordersCollection = FirebaseFirestore.instance.collection('Orders');
    await ordersCollection.add(order.toJson());
    cartController.clearCart();
  }

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

  void updateOrderStatus(String orderId, int status) async {
    final orderCollection = FirebaseFirestore.instance.collection('Orders');
    final querySnapshot = await orderCollection.where('id', isEqualTo: orderId).get();

    if (querySnapshot.docs.isNotEmpty) {
      final orderDoc = querySnapshot.docs.first;
      await orderDoc.reference.update({
        'status': status,
        'update_date': DateTime.now().toString(),
      });
    }

  }

  Future<int?> showUpdateStatusDialog(BuildContext context, String orderId) async {
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cập nhật trạng thái đơn hàng'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  updateOrderStatus(orderId, 0);
                  Navigator.pop(context, 0); // Trả về giá trị 0 khi nhấn nút "Chờ Duyệt"
                },
                child: Text('Chờ Duyệt'),
              ),
              SizedBox(width: 5,),
              ElevatedButton(
                onPressed: () {
                  updateOrderStatus(orderId, 1);
                  Navigator.pop(context, 1); // Trả về giá trị 1 khi nhấn nút "Đang giao"
                },
                child: Text('Đang giao'),
              ),
              SizedBox(width: 5,),
              ElevatedButton(
                onPressed: () {
                  updateOrderStatus(orderId, 2);
                  Navigator.pop(context, 2); // Trả về giá trị 2 khi nhấn nút "Đã giao"
                },
                child: Text('Đã giao'),
              ),
            ],
          ),
        );
      },
    );
  }


}