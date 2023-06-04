import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/views/splashscreen.dart';
import 'package:shoeshop/views/update_profile_screen.dart';
import 'package:shoeshop/views/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    // child: Image.network(userController.currentUser!.imageUrl)
                    child: CachedNetworkImage(
                      imageUrl: userController.currentUser!.imageUrl,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.lightBlueAccent,
                        ),
                        child: const Icon(Icons.add_box_outlined, size: 20, color: Colors.white,)),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Text(userController.currentUser!.name!, style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: 5,),
              Text(FirebaseAuth.instance.currentUser!.email!, style: Theme.of(context).textTheme.bodyMedium,),
              const SizedBox(height: 20,),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => UpdateProfileScreen(currentUser: userController.currentUser,)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    side: BorderSide.none,
                    shape: const StadiumBorder()),
                  child: const Text("Edit Profile", style: TextStyle(color: Colors.white),),
                ),
              ),
              const SizedBox(height: 30,),
              const Divider(),
              const SizedBox(height: 10),

              //Menu
              ProfileMenuWidget(title: "Setting", icon: Icons.settings, onPress: (){
                showSnackBar(context, "Đang phát triển!", 3);
              },),
              ProfileMenuWidget(title: "Billing Detail", icon: Icons.wallet, onPress: (){
                showSnackBar(context, "Đang phát triển!", 3);
              },),
              ProfileMenuWidget(title: "User Management", icon: Icons.edit_note, onPress: (){
                showSnackBar(context, "Đang phát triển!", 3);
              },),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: "Infomation", icon: Icons.info_outline, onPress: (){
                showSnackBar(context, "Đang phát triển!", 3);
              },),
              ProfileMenuWidget(
                title: "Logout",
                icon: Icons.logout,
                textColor: Colors.red,
                endIcon: false,
                onPress: (){
                  FirebaseAuth.instance.signOut();
                  userController.logout();
                  showSnackBar(context, "Đã đăng xuất thành công!", 3);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashScreen()),);
                },),
            ],
          ),
        ),
      )
    );
  }
}


