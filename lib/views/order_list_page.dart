import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/order_controller.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/helper/others.dart';
import 'package:shoeshop/models/order.dart';
import 'package:shoeshop/views/order_detail_page.dart';
import 'package:shoeshop/views/widgets/status_widget.dart';

class OrderListPage extends StatelessWidget {
  OrderListPage({Key? key}) : super(key: key);

  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (orderController.orders.isEmpty) {
        return const Center(
          child: Text('No orders found.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        );
      } else {
        return ListView.builder(
          itemCount: orderController.orders.length,
          itemBuilder: (context, index) {
            UserOrder order = orderController.orders[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(order: order),));
              },
              child: ListTile(
                leading: Text('${index+1}', style: const TextStyle(color: Colors.blueAccent, fontSize: 25, fontWeight: FontWeight.bold),),
                title: Text('Order #${index+1}'),
                subtitle: Text('Total: ${formatCurrency(order.totalPrice)}'),
                trailing: StatusWidget(status: getStatusString(order.status), color: getStatusColor(order.status)),
              ),
            );
          },
        );
      }
    });
  }
}

