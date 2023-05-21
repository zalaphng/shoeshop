import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/main.dart';
import 'package:shoeshop/screens/page_register.dart';
import 'package:shoeshop/services/connect_services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PageLogin extends StatefulWidget {
  PageLogin({Key? key}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

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
                labelText: "Email",
              ),
            ),
            TextField(
              controller: txtPassword,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            SizedBox(
              height: 10,
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
                              builder: (context) => MyApp())));
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account"),
                TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => PageRegister())),
                    child: Text("Register"))
              ],
            ),
            StyledElevatedButton(
              icon: Icons.search,
              title: "Sign in with Google",
              onPressed: () async {
                signInWithGoogle(context,
                    onSigned: () =>
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => MyApp())));
              }
            ),
            StyledElevatedButton(
              icon: Icons.phone,
              title: "Register with Phone",
              onPressed: () async {
                var phoneNumber = await showPromptSMSCodeInput(
                    context, "Nhập số điện thoại: ");
                signInWithPhoneNumber(
                  context,
                  phoneNumber: phoneNumber,
                  onSigned: () =>
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MyApp(),
                  )),
                );
              },
            ),
          ],
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

class PageHome extends StatelessWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page Home"),
      ),
      body: Container(
        child: Column(
          children: [
            Text("${FirebaseAuth.instance.currentUser?.toString()}"),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => PageLogin(),
                      ),
                      (route) => false);
                },
                child: Text("Sign out"))
          ],
        ),
      ),
    );
  }
}

Future<String?> showPromptSMSCodeInput(
    BuildContext context, String dispMessage) async {
  TextEditingController sms = TextEditingController();
  AlertDialog dialog = AlertDialog(
    title: const Text("Xác nhận"),
    content: TextField(
      controller: sms,
      decoration: InputDecoration(labelText: "SMS Code"),
      keyboardType: TextInputType.number,
    ),
    actions: [
      ElevatedButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(null),
          child: Text("Hủy")),
      ElevatedButton(
          onPressed: () =>
              Navigator.of(context, rootNavigator: true).pop(sms.text),
          child: Text("OK"))
    ],
  );
  String? res = await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => dialog,
  );
  return res;
}

void registerEmailPassword(BuildContext context,
    {required String email,
    required String password,
    String? registeringMessage,
    String? registeredMessage}) {
  try {
    showSnackBar(
        context, registeredMessage ?? "Registering your account...", 30);
    var user = FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    if (user != null) {
      showSnackBar(
          context, registeredMessage ?? "Your account have registered", 5);
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
    showSnackBar(context, signinMessage ?? "Signing in...", 60);
    var userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (userCredential != null) {
      showSnackBar(context, signedMessage ?? "SignIn successful", 5);
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

void signInWithGoogle(BuildContext context,
    {String? registeringMessage,
    void Function()? onSigned,
    String? signinMessage,
    String? signedMessage}) async {
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
      showSnackBar(context, signedMessage ?? "Sign successful", 5);
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
