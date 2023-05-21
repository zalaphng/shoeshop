import 'package:flutter/material.dart';

Future<String?> showConfirmDialog(
    BuildContext context, String dispMessage) async {
  AlertDialog dialog = AlertDialog(
    title: const Text("Xác nhận"),
    content: Text(dispMessage),
    actions: [
      ElevatedButton(
          onPressed: () =>
              Navigator.of(context, rootNavigator: true).pop("cancel"),
          child: Text("Hủy")),
      ElevatedButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop("ok"),
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

void showSnackBar(BuildContext context, String message, int second){
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: Duration(seconds: second),)
  );
}

