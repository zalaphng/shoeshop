import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/cart_controller.dart';
import 'package:shoeshop/controllers/order_controller.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/utils/image_path.dart';
import 'package:shoeshop/views/layouts/master_layouts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late UserController userController;

  @override
  Widget build(BuildContext context) {

    userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          ImagePath.imgLogo,
          width: 96,
          height: 96,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // tạo một callback sau khi vẽ xong splashscreen

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (userController.isLoggedIn == false) {
          Get.lazyPut<CartController>(() => CartController());
          Get.lazyPut<OrderController>(() => OrderController());
          Get.offAll(() => const HomePage());
        } else {
          userController.navigateTo(context);
        }
      });
    });
  }
}
