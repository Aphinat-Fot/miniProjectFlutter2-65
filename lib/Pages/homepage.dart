import 'package:firstapp/Pages/NavigationbarPage.dart';
import 'package:firstapp/login/my_singout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  //const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  final auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('คณะภายในมหาวิทยาลัย'),
        // actions: <Widget>[
        //   IconButton(
        //       onPressed: () {
        //         auth.signOut();
        //         Navigator.popAndPushNamed(context, '/');
        //       },
        //       icon: const Icon(Icons.exit_to_app))
        // ],
      ),
      body: showHomePage(context),
      drawer: Drawer(
        child: MySignOut(),
      ),
    );
  }

  Padding showHomePage(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          builder: (context, snapshop) {
            if (snapshop.hasData) {
              var data = json
                  .decode(snapshop.data.toString()); //[{คอมพิวเตอร์....},{},{}]
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return MyBox(
                      context,
                      data[index]['title'],
                      data[index]['subtitle'],
                      data[index]['image'],
                      data[index]['detail'],
                      data[index]['web'],
                      data[index]['subtitle1'],
                      data[index]['subject'],
                      data[index]['tel'],
                      data[index]['latitude'],
                      data[index]['longitude'],
                      data[index]['rmutt']);
                },
                itemCount: data.length,
              );
            } else {
              return Container();
            }
          },
          future: DefaultAssetBundle.of(context).loadString('assets/data.json'),
        ));
  }
}

Widget MyBox(
    BuildContext context,
    String title,
    String subtitle,
    String image,
    String detail,
    String web,
    String subtitle1,
    String subject,
    String tel,
    String latitude,
    String longitude,
    String rmutt) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          //color: Color.fromARGB(255, 219, 197, 1)
          image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.darken)),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          leading: Icon(Icons.add_location),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NavigationbarPage(
                        title,
                        subtitle,
                        image,
                        detail,
                        web,
                        subtitle1,
                        subject,
                        tel,
                        latitude,
                        longitude,
                        rmutt)));
          },
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
