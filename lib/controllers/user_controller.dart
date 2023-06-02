import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoeshop/controllers/admin/product_admin_controller.dart';
import 'package:shoeshop/controllers/cart_controller.dart';
import 'package:shoeshop/controllers/order_controller.dart';
import 'package:shoeshop/views/admin/admin_mainscreen.dart';
import 'package:shoeshop/views/layouts/master_layouts.dart';
import 'package:shoeshop/models/user.dart';

import 'admin/order_admin_controller.dart';

class UserController extends GetxController {

  CustomUser? currentUser;

  var usersInfo = <CustomUser>[].obs;

  bool isLoggedIn = false;

  // bool isAdmin = false;

  @override
  void onInit() {
    print(isLoggedIn);
    super.onInit();
    // logout();
    checkLogin();
    // checkAdmin();
    loadUsers();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;
        currentUser = CustomUser.fromJson({...data, 'id': user.uid});
        update();
      }
    }
  }

  void updateCurrentUser(String fullName, String phone, String address) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userRef = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);
        await userRef.update({
          'name': fullName,
          'phone': phone,
          'address': address,
        });

        this.currentUser = CustomUser(
          id: currentUser.uid,
          name: fullName,
          address: address,
          imageUrl: this.currentUser!.imageUrl,
          phone: phone,
        );

        update();
      }
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  void addUserInfo(String fullName, String phone, String address) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userRef =
        FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);
        final userDoc = await userRef.get();

        if (userDoc.exists) {
          // Tài liệu đã tồn tại, không cần thêm mới
          print('User info already exists');
        } else {
          // Tài liệu chưa tồn tại, thêm mới thông tin người dùng
          await userRef.set({
            'isAdmin': false,
            'name': fullName,
            'phone': phone,
            'address': address,
            'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/myfirebase-703c7.appspot.com/o/users%2FDefault_pfp.svg.png?alt=media&token=004f1e7c-cc3e-4a8b-9198-88d5e04b7f75'
          });

          print('User info added successfully');
        }
      }
    } catch (e) {
      print('Error adding user info: $e');
    }
  }

  void loadUsers() async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection('Users');
      final snapshot = await usersCollection.get();

      final userList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final id = doc.id;
        return CustomUser.fromJson({...data, 'id': id});
      }).toList();

      usersInfo.assignAll(userList);
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error loading users: $e');
    }
  }

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    update();
  }

  // void checkAdmin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   isAdmin = prefs.getBool('isAdmin') ?? false;
  //   update();
  // }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    isLoggedIn = true;
    await getCurrentUser();
    update();
  }

  // void admin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isAdmin', true);
  //   isAdmin = true;
  //   update();
  // }

  Future<void> registerUser(String userId) async {
    final userRef = FirebaseFirestore.instance.collection('Users').doc(userId);
    await userRef.set({
      'isAdmin': false,
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    isLoggedIn = false;
    currentUser = null;
    update();
  }

  void navigateTo(BuildContext context) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      bool isAdmin = value['isAdmin'] as bool;
      if(isAdmin){
        Get.lazyPut<ProductAdminController>(() => ProductAdminController());
        Get.lazyPut<OrderAdminController>(() => OrderAdminController());
        Get.offAll(() => const AdminMainScreen());
      }else{
        Get.lazyPut<CartController>(() => CartController());
        Get.lazyPut<OrderController>(() => OrderController());
        Get.offAll(() => const HomePage());
      }
    });
  }
}