import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/database/addcomment.dart';
import 'package:firstapp/database/showdetail.dart';
import 'package:firstapp/database/showdetail1.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewPage extends StatelessWidget {
  final store = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser?.email;
  final v1;
  ReviewPage(this.v1);
  //ReviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: store.collection('review').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Scaffold(
            body: snapshot.hasData
                ? buildCommentList(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print(v1);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddReviewPage(v1)));
              },
              child: Icon(Icons.add),
            ));
      },
    );
  }

  IconButton buildAddButton(context) {
    return IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          print("add icon press");
          Navigator.pushNamed(context, '/addreview');
        });
  }

  ListView buildCommentList(QuerySnapshot data) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 40),
      itemCount: data.size,
      itemBuilder: (BuildContext context, int index) {
        var model = data.docs.elementAt(index);
        if (v1 == model['group']) {
          print('#######data = #######');
          return Container(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.background,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: ListTile(
                  title: Text(model['group']),
                  subtitle: Text(model['title']),
                  onTap: () {
                    print(model['title']);
                    if (email == model['email']) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommentDetail(model['title'])));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommentDetail1(model['title'])));
                    }
                  },
                ),
              ),
            ),
          );
        } else
          return Center();
      },
    );
  }
}
