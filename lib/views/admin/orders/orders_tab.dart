import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/admin/order_admin_controller.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/helper/others.dart';
import 'package:shoeshop/views/admin/orders/orders_admin_detailpage.dart';
import 'package:shoeshop/views/widgets/status_widget.dart';

class OrdersTab extends StatelessWidget {
  final int status;

  OrdersTab({Key? key, required this.status}) : super(key: key);

  final orderAdminController = Get.find<OrderAdminController>();
  final userController = Get.find<UserController>();


  @override
  Widget build(BuildContext context) {

    return Obx(() {
      final filteredOrders = orderAdminController.orders
          .where((order) => order.status == status)
          .toList();

      return ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];

          final user = userController.usersInfo
              .firstWhere((user) => user.id == order.userId);
          // Build UI for each order item
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                onTap: () => Get.to(OrdersAdminDetailPage(order: order)),
                title: Text(order.id!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name!),
                    Text('Created At: ${order.createDate}'),
                    Text('Total Price: ${formatCurrency(order.totalPrice)}'),
                    StatusWidget(status: getStatusString(order.status), color: getStatusColor(order.status)),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await orderAdminController.showUpdateStatusDialog(context, order.id!);
                    showSnackBar(context, "Đã cập nhật trạng thái thành công!", 2);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Cập nhật',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

}