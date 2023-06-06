import 'package:flutter/material.dart';

import '../models/custom_error.dart';

void errorDialog(BuildContext context, CustomError e) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(e.code),
          content: Text(e.plugin + '\n' + e.message),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Ok'))
          ],
        );
      });
}
