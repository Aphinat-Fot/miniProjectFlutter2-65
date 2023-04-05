import 'package:flutter/material.dart';

import '../Pages/homepage.dart';

Future<Null> normalDialog1(
    BuildContext context, String title, String message) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            title: ListTile(
              title: Text(title),
              subtitle: Text(message),
            ),
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      ModalRoute.withName('/homepage'));
                },
                child: Text('OK'),
              ),
            ],
          ));
}
