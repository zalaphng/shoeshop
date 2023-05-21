import 'package:shoeshop/screens/page_login.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
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
                  icon: Icon(_obscureRePassword ? Icons.visibility_off : Icons.visibility),
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
                if (txtEmail.text != "" && txtPassword.text != "" && txtRePassword.text != "") {
                  if (txtPassword.text == txtRePassword.text) {
                    var user = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                        email: txtEmail.text, password: txtPassword.text);
                    if (user != null) {
                      showSnackBar(context, "Đã đăng ký thành công!", 5);
                    }
                  }
                }
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PageLogin(),
                      ));
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}
