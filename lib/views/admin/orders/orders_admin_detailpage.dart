import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/admin/order_admin_controller.dart';
import 'package:shoeshop/controllers/admin/product_admin_controller.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/helper/others.dart';
import 'package:shoeshop/models/order.dart';
import 'package:shoeshop/views/widgets/status_widget.dart';

class OrdersAdminDetailPage extends StatelessWidget {
  final UserOrder order;

  OrdersAdminDetailPage({Key? key, required this.order}): super(key: key);
  final productAdminController = Get.find<ProductAdminController>();
  final userController = Get.find<UserController>();
  final orderAdminController = Get.find<OrderAdminController>();

  @override
  Widget build(BuildContext context) {

    final user = userController.usersInfo
        .firstWhere((user) => user.id == order.userId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mã Đơn hàng: ${order.id}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Tên khách hàng: ${user.name}' , style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Địa chỉ khách hàng: ${user.address}' , style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Số điện thoại: ${user.phone}' , style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Tổng tiền: ${formatCurrency(order.totalPrice)}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      StatusWidget(status: getStatusString(order.status), color: getStatusColor(order.status)),
                      SizedBox(height: 8),
                      Text('Tạo ngày: ${order.createDate}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Ngày Cập nhật: ${order.updateDate}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 16),
                      Text('Danh sách sản phẩm đặt hàng:', style: TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: order.products.length,
                        itemBuilder: (context, index) {
                          final product = productAdminController.products.firstWhere((p) => p.id == order.products[index].id);
                          return ListTile(
                              leading: Container(
                                child: Image.network(
                                  product.imageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            title: Text(product.name),
                            subtitle: Text('${formatCurrency(product.price)}'),
                            // Add more details or actions based on your requirements
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(onPressed: () async {
                await orderAdminController.showUpdateStatusDialog(context, order.id!);
                showSnackBar(context, "Đã cập nhật trạng thái thành công!", 2);
                Navigator.of(context).pop();
              }, child: Text("Cập nhật trạng thái")),
            )
          ]
        ),
      ),
    );
  }
}