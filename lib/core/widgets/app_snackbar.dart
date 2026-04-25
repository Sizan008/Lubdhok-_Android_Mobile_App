import 'package:flutter/material.dart';

void showAppSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
    ),
  );
}