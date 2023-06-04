import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/views/auth/page_login.dart';

class UserInfoPage extends StatefulWidget {
  final String? userId;
  VoidCallback? onDone;


  UserInfoPage({Key? key, this.userId, this.onDone}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  UserController userController = Get.find();
  VoidCallback? onDone;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    onDone = (widget.onDone != null) ? widget.onDone : null;
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String name = nameController.text;
                String phone = phoneController.text;
                String address = addressController.text;

                if (name.isEmpty || phone.isEmpty || address.isEmpty) {
                  showSnackBar(context, "Vui lòng điền đầy đủ thông tin", 3);
                } else {
                  await userController.addUserInfo(name, phone, address);
                  if(onDone != null) {
                    onDone!();
                  };
                }
              },
              child: Text('Add User Info'),
            ),
          ],
        ),
      ),
    );
  }
}