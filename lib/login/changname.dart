import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firstapp/Pages/homepage.dart';
import 'package:firstapp/login/dialog.dart';
import 'package:firstapp/login/dialog1.dart';
import 'package:firstapp/models/user_modelname.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChangName extends StatefulWidget {
  //const ChangName({super.key});
  // final name;
  // ChangName(this.name);

  @override
  State<ChangName> createState() => _ChangNameState();
}

class _ChangNameState extends State<ChangName> {
  String? name;
  final auth = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Name')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [buildUser(), buildCreatAccount()],
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: kDefaultIconDarkColor,
              ),
              labelStyle: TextStyle(color: kDefaultIconDarkColor),
              labelText: 'User',
              border: OutlineInputBorder())),
    );
  }

  Container buildCreatAccount() {
    return Container(
        margin: EdgeInsets.only(top: 8),
        width: MediaQuery.of(context).size.width * 0.6,
        child: ElevatedButton(
            onPressed: () {
              print(auth);
              if ((name?.isEmpty ?? true)) {
                print('Have Space');
                normalDialog(context, 'Have Space?', 'Please Fill Every Blank');
              } else {
                updateAccount();
              }
            },
            child: Text('Update Account')));
  }

  Future<Null> updateAccount() async {
    await Firebase.initializeApp().then((value) async {
      NameModel model = NameModel(name: name!);
      Map<String, dynamic> data = model.toMap();

      await FirebaseFirestore.instance
          .collection('user')
          .doc(auth)
          .update(data)
          .then((value) {
        print('Update Value To Firestore  Success');
        normalDialog1(context, 'Change Suscess', 'Thank You');
      });
    });
  }
}
