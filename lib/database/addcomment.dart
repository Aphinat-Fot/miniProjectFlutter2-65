// ignore_for_file: avoid_print, deprecated_member_use

//import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddReviewPage extends StatefulWidget {
  //const AddReviewPage({Key? key}) : super(key: key);
  final v1;
  AddReviewPage(this.v1);
  @override
  State createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  File? file;
  String? urlPicture;
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _detail = TextEditingController();
  final email = FirebaseAuth.instance.currentUser?.email;

  final store = FirebaseFirestore.instance;
  var _v1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _v1 = widget.v1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มความคิดเห็น'),
      ),
      body: Form(
        key: _form,
        child: ListView(
          children: <Widget>[
            buildTitleField(),
            buildDetailField(),
            buildSaveButton()
          ],
        ),
      ),
    );
  }

  ElevatedButton buildSaveButton() {
    return ElevatedButton(
        child: const Text('Save'),
        onPressed: () async {
          if (_form.currentState!.validate()) {
            print('save button press');
            Map<String, dynamic> data = {
              'title': _title.text,
              'detail': _detail.text,
              'email': email,
              'group': _v1.toString(),
            };
            try {
              DocumentReference ref =
                  await store.collection('review').add(data);
              print('save id = ${ref.id}');
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error $e'),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please validate value'),
              ),
            );
          }
        });
  }

  Future<void> showAlert(String title, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  TextFormField buildTitleField() {
    return TextFormField(
      controller: _title,
      decoration: const InputDecoration(
        labelText: 'title',
        icon: Icon(Icons.book),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill in title' : null,
    );
  }

  TextFormField buildDetailField() {
    return TextFormField(
      controller: _detail,
      decoration: const InputDecoration(
        labelText: 'detail',
        icon: Icon(Icons.list),
      ),
      validator: (value) => value!.isEmpty ? 'Please fill in detail' : null,
    );
  }

  Widget showImage() {
    print(email);
    return Container(
      padding: EdgeInsets.all(20.0),
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
}
