import 'package:flutter/material.dart';
import 'package:shoeshop/controllers/cart_controller.dart';
import 'package:shoeshop/controllers/order_controller.dart';
import 'package:get/get.dart';
import 'package:shoeshop/views/widgets/cart_item.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Obx(() => ListView.builder(
            itemCount: cartController.cart.length,
            itemBuilder: (context, index) {
              return CartItem(
                product: cartController.cart[index],
                onRemove: () =>
                    cartController.removeFromCart(cartController.cart[index]),
              );
            },
          )),
      bottomNavigationBar: Obx(() =>
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    cartController.totalPrice.value.toStringAsFixed(2),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (cartController.cart.isEmpty) {
                      Get.snackbar(
                        'Cart is empty',
                        'You need to add items to your cart before checking out.',
                      );
                    } else {
                      orderController.placeOrder(cartController);
                      Get.snackbar(
                        'Order placed',
                        'Your order has been placed successfully.',
                        duration: Duration(seconds: 5),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: Text('Place order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
