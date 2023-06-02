import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final formatter = NumberFormat('#,### đ', 'vi_VN');
  return formatter.format(amount);
}

String getStatusString(int status) {
  switch (status) {
    case 0:
      return 'Chờ duyệt';
    case 1:
      return 'Đang giao';
    case 2:
      return 'Đã giao';
    default:
      return 'Trạng thái không xác định';
  }
}

Color getStatusColor(int status) {
  switch (status) {
    case 0:
      return Colors.blue;
    case 1:
      return Colors.orange;
    case 2:
      return Colors.green;
    default:
      return Colors.black;
  }
}
