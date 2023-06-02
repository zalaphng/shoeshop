import 'package:shoeshop/utils/image_path.dart';
import 'package:shoeshop/views/auth/page_login.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoeshop/views/auth/user_info_page.dart';

class PageRegister extends StatefulWidget {
  PageRegister({Key? key}) : super(key: key);

  @override
  State<PageRegister> createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegister> {
  bool _obscurePassword = true;
  bool _obscureRePassword = true;

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtRePassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                child: Column(
                  children: [
                    Image.asset(ImagePath.imgLogo),
                    Text("ShoeShop", style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold),),
                  ],
                ),),
              TextField(
                controller: txtEmail,
                decoration: InputDecoration(
                  labelText: "Email:",
                ),
              ),
              TextField(
                controller: txtPassword,
                decoration: InputDecoration(
                  labelText: "Your Password:",
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                enableSuggestions: false,
                autocorrect: false,
              ),
              TextField(
                controller: txtRePassword,
                decoration: InputDecoration(
                  labelText: "Retype your password:",
                  suffixIcon: IconButton(
                    icon: Icon(_obscureRePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureRePassword = !_obscureRePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureRePassword,
                enableSuggestions: false,
                autocorrect: false,
              ),
              SizedBox(
                height: 10,
              ),
              StyledElevatedButton(
                icon: Icons.key,
                title: "Register with Email",
                onPressed: () async {
                  if (txtEmail.text != "" &&
                      txtPassword.text != "" &&
                      txtRePassword.text != "") {
                    if (txtPassword.text == txtRePassword.text) {
                      var user = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: txtEmail.text, password: txtPassword.text);
                      if (user != null) {
                        String userId = user.user!.uid; // Lấy ID của người dùng vừa tạo
                        showSnackBar(context, "Vui lòng nhập thông tin", 3);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UserInfoPage(userId: userId, onDone: () {
                            showSnackBar(context, "Đã đăng ký thành công! Vui lòng đăng nhập", 5);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PageLogin(),));
                          },)),
                        );
                      }
                    }
                  }
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Back"))
            ],
          ),
        ),
      ),
    );
    ;
  }
}
