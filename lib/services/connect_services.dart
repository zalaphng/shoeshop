import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyFirebaseConnect extends StatefulWidget {
  final String? errorMessage;
  final String? connectingMessage;
  final Widget Function(BuildContext context)? builder;
  const MyFirebaseConnect(
      {Key? key,
      required this.builder,
      required this.errorMessage,
      required this.connectingMessage})
      : super(key: key);

  @override
  State<MyFirebaseConnect> createState() => _MyFirebaseConnectState();
}

class _MyFirebaseConnectState extends State<MyFirebaseConnect> {
  bool connect = false;
  bool error = false;

  @override
  Widget build(BuildContext context) {
    if(error){
      return Container(
        color: Colors.white,
        child: Center(
          child: Text(widget.errorMessage!
          ,style: const TextStyle(fontSize: 16)
          ,textDirection: TextDirection.ltr
          ),
        ),
      );
    } else
      if (!connect) {
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Text(widget.connectingMessage!
                  ,style: const TextStyle(fontSize: 16)
                  ,textDirection: TextDirection.ltr
              ),
            ]
          ),
        );
      } else {
        return
            widget.builder!(context);
      }
  }


  @override
  void initState() {
    super.initState();
    _khoiTaoFireBase();
  } // hạn chế sử dụng await


  _khoiTaoFireBase() {
    Firebase.initializeApp().then((value) {
      setState(() {
        connect = true;
      });
    }).catchError((error) {
      setState(() {
        error = true;
      });
      if (kDebugMode) {
        print(error.toString());
      }
    }); // finally
  }
}
