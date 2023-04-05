import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firstapp/Pages/homepage.dart';
import 'package:firstapp/login/dialog.dart';
import 'package:firstapp/login/dialog1.dart';
import 'package:firstapp/models/user_modelurl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';

class ChangImage extends StatefulWidget {
  const ChangImage({super.key});

  @override
  State<ChangImage> createState() => _ChangImageState();
}

class _ChangImageState extends State<ChangImage> {
  File? file;
  String? urlPicture;
  final auth = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Image'),
      ),
      body: Column(children: [showImage(), cameraButton(), buildChangImage()]),
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

  Container buildChangImage() {
    return Container(
        margin: EdgeInsets.only(top: 8),
        width: MediaQuery.of(context).size.width * 0.6,
        child: ElevatedButton(
            onPressed: () {
              if (file == null) {
                normalDialog(context, 'Have Image?', 'Please Take Photo');
              } else {
                updateImage();
              }
            },
            child: Text('Update Image')));
  }

  Future<Null> updateImage() async {
    await Firebase.initializeApp().then((value) async {
      await uploadPictureToStorage();
      UrlModel model = UrlModel(url: urlPicture!);
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
