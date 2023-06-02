import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/services/connect_services.dart';
import 'package:shoeshop/views/splashscreen.dart';

void main() => runApp(MyAppGetX());

class MyAppGetX extends StatelessWidget {
  const MyAppGetX({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MyApp',
      debugShowCheckedModeBanner: false,
      home: MyFirebaseConnect(
          builder: (context) => const SplashScreen(),
          errorMessage: 'Error!',
          connectingMessage: 'Connecting...'),
    );
  }
}