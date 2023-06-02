import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/views/auth/page_login.dart';
import 'package:shoeshop/views/cart_page.dart';
import 'package:shoeshop/views/order_list_page.dart';
import 'package:shoeshop/views/product_page.dart';
import 'package:shoeshop/views/profile_page.dart';
import 'package:shoeshop/views/favourite_page.dart';
import 'package:shoeshop/views/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;


  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {

    var isDark = false;
        // MediaQuery.of(context).platformBrightness == Brightness.dark;

    List appBar = [
      AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outlined, color: Colors.redAccent,),
            onPressed: () {
              userController.isLoggedIn
                  ? Get.to(() => FavouritePage())
                  : Get.to(() => PageLogin(
                phoneAuth: false,
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              userController.isLoggedIn
                  ? Get.to(() => CartPage())
                  : Get.to(() => PageLogin(
                        phoneAuth: false,
                      ));
            },
          )
        ],
      ),
      AppBar(title: const Text('Orders')),
      AppBar(title: const Text('Profile'),
        // leading: IconButton(
        //   onPressed: (){},
        //   icon: const Icon(Icons.keyboard_arrow_left),
        // ),
        actions: [
        IconButton(
            onPressed: (){
              showSnackBar(context, "Đang phát triển!", 3);
            },
            icon: Icon(isDark? Icons.sunny : Icons.nightlight)
        )
      ],),
    ];

    List pages = [
      ProductPage(),
      OrderListPage(),
      // ProfilePage(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: appBar[_currentIndex],
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              setState(() {
                _currentIndex = index;
              });
              break;
            case 1:
              if (userController.isLoggedIn) {
                setState(() {
                  _currentIndex = index;
                });
              } else {
                Get.to(() => PageLogin());
              };
              break;
            case 2:
              if (userController.isLoggedIn) {
                setState(() {
                  _currentIndex = index;
                });
              } else {
                Get.to(() => PageLogin());
              };
              break;
          }
        },
      ),
    );
  }
}
