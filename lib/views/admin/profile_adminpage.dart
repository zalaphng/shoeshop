import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/views/layouts/master_layouts.dart';
import 'package:shoeshop/views/splashscreen.dart';
import 'package:shoeshop/views/widgets/profile_menu_item.dart';

class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({Key? key}) : super(key: key);

  @override
  State<ProfileAdminPage> createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Column(
        children: [
          ProfileMenuItem(title: "Logout", icon: Icons.logout, onPress: () {
            FirebaseAuth.instance.signOut();
            userController.logout();
            Get.off(const SplashScreen());
          },)
        ],
      ),
    );
  }
}

