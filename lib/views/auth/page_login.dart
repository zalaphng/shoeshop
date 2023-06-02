import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/user_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoeshop/models/user.dart';
import 'package:shoeshop/utils/image_path.dart';
import 'package:shoeshop/views/auth/page_register.dart';
import 'package:shoeshop/views/auth/user_info_page.dart';
import 'package:shoeshop/views/layouts/master_layouts.dart';
import 'package:shoeshop/views/splashscreen.dart';

UserController userController = Get.find<UserController>();


class PageLogin extends StatefulWidget {

  PageLogin({Key? key, this.phoneAuth = true}) : super(key: key);

  final phoneAuth;

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool _obscurePassword = true;

  TextEditingController txtEmail = TextEditingController();

  TextEditingController txtPassword = TextEditingController();

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
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                ),
                autofillHints: [AutofillHints.email, txtEmail.text],
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
              SizedBox(
                height: 20,
              ),
              StyledElevatedButton(
                icon: Icons.email_outlined,
                title: "Sign in with email",
                onPressed: () {
                  if (txtEmail.text != "" && txtPassword.text != "") {
                    signInWithEmailPassword(context,
                        email: txtEmail.text,
                        password: txtPassword.text,
                        onSigned: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const SplashScreen())),);
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account"),
                  TextButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => PageRegister())),
                      child: Text("Register"))
                ],
              ),
              StyledElevatedButton(
                icon: Icons.search,
                title: "Sign in with Google",
                onPressed: () async {
                  signInWithGoogle(context,);
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StyledElevatedButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData? icon;
  final String title;

  StyledElevatedButton(
      {super.key, this.onPressed, this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
          onPressed: () async {
            if (onPressed != null) {
              onPressed!();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (icon != null)
                  ? Icon(icon as IconData?)
                  : SizedBox(
                      width: 1,
                    ),
              SizedBox(width: 10),
              Text(title)
            ],
          )),
    );
  }
}

Future<void> registerEmailPassword(BuildContext context,
    {required String email,
    required String password,
    String? registeringMessage,
    String? registeredMessage}) async {
  try {
    showSnackBar(
        context, registeredMessage ?? "Đang đăng ký tài khoản...", 30);
    var user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    if (user != null) {
      await userController.registerUser(user.user!.uid);
      showSnackBar(
          context, registeredMessage ?? "Tài khoản của bạn đã được đăng ký!", 3);
    }
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.code, 5);
  }
}

void signInWithEmailPassword(BuildContext context,
    {required String email,
    required String password,
    String? registeringMessage,
    void Function()? onSigned,
    String? signinMessage,
    String? signedMessage}) async {
  try {

    showSnackBar(context, signinMessage ?? "Đang đăng nhập...", 60);
    var userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (userCredential != null) {

      await userController.login();
      showSnackBar(
        context,
        "Chào mừng trở lại, ${userController.currentUser!.name}",
        5,
      );

      if (onSigned != null) {
        onSigned();
      }
    }
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.code, 5);
  } catch (e) {
    print(e);
  }
}

Future<void> signInWithGoogle(BuildContext context, {
  String? registeringMessage,
  void Function()? onSigned,
  String? signinMessage,
  String? signedMessage,
}) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    var userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      var userRef = FirebaseFirestore.instance.collection('Users').doc(uid);
      var userSnapshot = await getUserSnapshot(userRef);
      print(userSnapshot.data());

      if (userSnapshot.data() == null) {
        showSnackBar(context, "Vui lòng nhập thông tin!", 5);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserInfoPage(
              userId: uid,
              onDone: () async {
                showSnackBar(context, "Đã thêm thông tin thành công!", 5);
                if (onSigned != null) {
                  onSigned();
                }
                await userController.login();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                );
              },
            ),
          ),
        );
      } else {
        await userController.login();
        showSnackBar(
          context,
          "Chào mừng trở lại, ${userController.currentUser!.name}",
          5,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
      }
    }
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.code, 5);
  } catch (e) {
    print(e);
  }
}

Future<DocumentSnapshot> getUserSnapshot(DocumentReference userRef) async {
  return await userRef.get();
}

void signInWithPhoneNumber(BuildContext context,
    {void Function()? onSigned,
    String? signIningMessage,
    String? signedMessage,
    Future<String?> Function()? smsCodePrompt,
    int timeOut = 30,
    required phoneNumber,
    String? smsTestCode}) {
  FirebaseAuth.instance.verifyPhoneNumber(
    verificationCompleted: (phoneAuthCredential) async {},
    verificationFailed: (error) {
      showSnackBar(context, error.code, 5);
    },
    codeAutoRetrievalTimeout: (verificationId) {
      showSnackBar(context, "time out", 5);
    },
    codeSent: (verificationId, forceResendingToken) async {
      print("Verification ID: $verificationId");
      String? smsCode = smsTestCode;
      if (smsCodePrompt != null) smsCode = await smsCodePrompt();
      if (smsCode != null) {
        var credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        try {
          var userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          if (userCredential != null) {
            showSnackBar(
                context, signedMessage ?? "Sign in not successfully", 5);
            if (onSigned != null) onSigned();
          } else
            showSnackBar(
                context, signedMessage ?? "Sign in not successfully", 5);
        } on FirebaseAuthException catch (e) {
          showSnackBar(context, signedMessage ?? "Sign in not successfully", 5);
        }
      } else
        showSnackBar(context, signedMessage ?? "Sign in not successfully", 5);
    },
  );
}
