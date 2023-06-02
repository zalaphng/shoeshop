import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/models/user.dart';
import 'package:shoeshop/views/auth/page_login.dart';
import 'package:shoeshop/views/splashscreen.dart';


class UpdateProfileScreen extends StatelessWidget {
  CustomUser? currentUser;

  UpdateProfileScreen({Key? key, required this.currentUser}) : super(key: key);

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    fullNameController.text = currentUser!.name;
    phoneController.text = currentUser!.phone;
    addressController.text = currentUser!.address;

    return Scaffold(
        appBar: AppBar(
        leading: IconButton(
        onPressed: () => Get.back (),
        icon: const Icon(Icons.chevron_left),
        ),
        title: Text("Edit Profile"),
        ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          padding: const EdgeInsets.all(3),
          child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child:Image.network(currentUser!.imageUrl)),
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
                const SizedBox(height: 50,),
                Form(child: Column(
                  children: [
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(label: Text("Full name"), prefixIcon: Icon(Icons.person)),
                    ),
                    const SizedBox(height: 20,),
                    // TextFormField(
                    //   decoration: const InputDecoration(label: Text("Email"), prefixIcon: Icon(Icons.email_outlined)),
                    // ),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(label: Text("Phone"), prefixIcon: Icon(Icons.phone)),
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(label: Text("Address"), prefixIcon: Icon(Icons.edit_road_outlined)),
                    ),
                    // TextFormField(
                    //   decoration: const InputDecoration(label: Text("Password"), prefixIcon: Icon(Icons.fingerprint)),
                    // ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          String fullName = fullNameController.text;
                          String phone = phoneController.text;
                          String address = addressController.text;

                          userController.updateCurrentUser(fullName, phone, address);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashScreen()),);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Edit Profile", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text.rich(
                            TextSpan(
                              text: "Join ",
                              style: TextStyle(fontSize: 12),
                              children: [
                                TextSpan(text: "23/5/2023", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                              ],
                            ),
                        ),
                      ],
                    )
                  ],
                )
                )
            ],
          ),
        ),
      ),
    );
  }
}
