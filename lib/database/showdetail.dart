// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentDetail extends StatefulWidget {
  final String _idi; //if you have multiple values add here
  const CommentDetail(this._idi, {Key? key})
      : super(key: key); //add also..example this.abc,this...

  @override
  State createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    String id = widget._idi;

    return StreamBuilder(
        stream: getComent(id),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("ความคิดเห็น"),
            ),
            body: snapshot.hasData
                ? buildCommentList(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        });
  }

  ListView buildCommentList(QuerySnapshot data) {
    return ListView.builder(
      itemCount: data.docs.length,
      itemBuilder: (BuildContext context, int index) {
        var model = data.docs.elementAt(index);
        String email = model['email'];
        String title = model['title'];
        String detail = model['detail'];
        String group = model['group'];
        return Container(
          padding: EdgeInsets.only(top: 20, left: 40, right: 40),
          width: 400,
          height: 200,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'title: $title',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('detail: $detail'),
                SizedBox(
                  height: 10,
                ),
                Text('by: $email'),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  child: ElevatedButton(
                      child: const Text('Delete'),
                      onPressed: () {
                        deleteValue(model.id);
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteValue(String titleName) async {
    await _firestore
        .collection('review')
        .doc(titleName)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  Stream<QuerySnapshot> getComent(String titleName) {
    print(titleName);
    // Firestore _firestore = Firestore.instance;
    return _firestore
        .collection('review')
        .where('title', isEqualTo: titleName)
        .snapshots();
  }
}
