import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/views/layouts/master_layouts.dart';
import 'package:shoeshop/views/splashscreen.dart';
import 'package:shoeshop/views/widgets/profile_menu_item.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(title: "Logout", icon: Icons.logout, onPress: () {
          FirebaseAuth.instance.signOut();
          userController.logout();
          showSnackBar(context, "Đã đăng xuất thành công!", 3);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashScreen()),);
        },)
      ],
    );
  }
}