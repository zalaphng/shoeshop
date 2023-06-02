import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final String status;
  final Color color;

  const StatusWidget({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Status: ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          TextSpan(
            text: status,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
