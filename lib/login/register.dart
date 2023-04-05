//import 'dart:html';

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firstapp/login/dialog.dart';
import 'package:firstapp/login/login.dart';
import 'package:firstapp/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? file;
  String? urlPicture;
  String? name, mail, password, conPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครสมาชิก'),
      ),
      body: buildContent(context),
    );
  }

  Center buildContent(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            showImage(),
            cameraButton(),
            buildUser(),
            buildemail(),
            buildPas(),
            buildConfirmPas(),
            buildCreatAccount(),
          ],
        ),
      ),
    );
  }

  Container buildCreatAccount() {
    return Container(
        margin: EdgeInsets.only(top: 8),
        width: MediaQuery.of(context).size.width * 0.6,
        child: ElevatedButton(
            onPressed: () {
              if ((name?.isEmpty ?? true) ||
                  (mail?.isEmpty ?? true) ||
                  (password?.isEmpty ?? true)) {
                print('Have Space');
                normalDialog(context, 'Have Space?', 'Please Fill Every Blank');
              } else if (file == null) {
                normalDialog(context, 'Have Image?', 'Please Take Photo');
              } else if (password != conPassword) {
                normalDialog(
                    context, 'Passwords do not match!', 'Please try again.');
              } else {
                createAccountAndInswetInformation();
              }
            },
            child: Text('Create Account')));
  }

  Future<Null> createAccountAndInswetInformation() async {
    await Firebase.initializeApp().then((value) async {
      print('## Firebase Initialize Success ##');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail!, password: password!)
          .then((value) async {
        await uploadPictureToStorage();
        print('Create Account Succes');
        await value.user!.sendEmailVerification();
        await value.user!.updateDisplayName(name).then((value2) async {
          String uid = value.user!.uid;
          print('Update Profile Success and uid = $uid');

          UserModel model =
              UserModel(email: mail!, name: name!, url: urlPicture!);
          Map<String, dynamic> data = model.toMap();

          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .set(data)
              .then((value) => print('Insert Value To Firestore  Success'));
        });
      }).catchError((onError) =>
              normalDialog(context, onError.code, onError.message));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          ModalRoute.withName('/'));
    });
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

  Container buildemail() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
          onChanged: (value) => mail = value.trim(),
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.mail,
                color: kDefaultIconDarkColor,
              ),
              labelStyle: TextStyle(color: kDefaultIconDarkColor),
              labelText: 'E-mail',
              border: OutlineInputBorder())),
    );
  }

  Container buildPas() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: kDefaultIconDarkColor,
              ),
              labelStyle: TextStyle(color: kDefaultIconDarkColor),
              labelText: 'Password',
              border: OutlineInputBorder())),
    );
  }

  Container buildConfirmPas() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
          onChanged: (value) => conPassword = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: kDefaultIconDarkColor,
              ),
              labelStyle: TextStyle(color: kDefaultIconDarkColor),
              labelText: 'Confirm Password',
              border: OutlineInputBorder())),
    );
  }

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(5.0),
      //color: Colors.green,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      child: file == null
          ? Image.asset(
              'assets/images/view.png',
              color: Colors.blue,
            )
          : Image.file(file!),
    );
  }

  Widget cameraButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            chooseImage(ImageSource.camera);
          },
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
          ),
        ),
        IconButton(
          onPressed: () {
            chooseImage(ImageSource.gallery);
          },
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
          ),
        ),
      ],
    );
  }

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker().pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  Future<void> uploadPictureToStorage() async {
    Random random = Random();
    int i = random.nextInt(100000);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference ref = firebaseStorage.ref().child("user/image$i.jpg");
    UploadTask uploadTask = ref.putFile(file!);
    urlPicture = await (await uploadTask).ref.getDownloadURL();
    print('urlPicture = $urlPicture');
  }
}
