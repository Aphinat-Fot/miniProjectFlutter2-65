import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firstapp/login/dialog.dart';
import 'package:firstapp/models/user_model.dart';
import 'package:flutter/material.dart';

class MySignOut extends StatefulWidget {
  const MySignOut({super.key});

  @override
  State<MySignOut> createState() => _MySignOutState();
}

class _MySignOutState extends State<MySignOut> {
  final _db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [showname(), changName(), changImage(), singOut(context)],
      ),
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> showname() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('user').doc(auth).get(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data!.data();
          var email = data!['email'];
          var name = data['name'];
          var url = data['url'];
          return Mybox(email, name, url);
        }
        return Container();
      },
    );
  }

  Widget Mybox(String email, String name, String url) {
    return UserAccountsDrawerHeader(
      accountName: Text(name),
      accountEmail: Text(email),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(url),
      ),
    );
  }

  Container changName() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: ListTile(
        title: Text(
          'Change Name',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: Icon(Icons.manage_accounts),
        onTap: () {
          Navigator.pushNamed(context, '/changname');
        },
        tileColor: Colors.yellow[900],
        iconColor: Colors.white,
      ),
    );
  }

  Container changImage() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: ListTile(
        title: Text(
          'Change Image',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: Icon(Icons.flip_camera_ios),
        onTap: () {
          Navigator.pushNamed(context, '/changimage');
        },
        tileColor: Colors.blue,
        iconColor: Colors.white,
      ),
    );
  }

  Container singOut(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: ListTile(
        onTap: () async {
          await Firebase.initializeApp().then((value) async {
            await FirebaseAuth.instance.signOut().then((value) =>
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false));
          });
        },
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.white,
          size: 36,
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        tileColor: Colors.red.shade700,
      ),
    );
  }
}
