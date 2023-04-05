import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class DetailPage extends StatefulWidget {
  //const DetailPage({super.key});
  final v1, v2, v3, v4, v5, v6;
  DetailPage(this.v1, this.v2, this.v3, this.v4, this.v5, this.v6);
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<void> _launcherURL(String url) async {
    final Uri uri = Uri(scheme: "https", host: url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not lauch url";
    }
  }

  var _v1, _v2, _v3, _v4, _v5, _v6;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _v1 = widget.v1;
    _v2 = widget.v2;
    _v3 = widget.v3;
    _v4 = widget.v4;
    _v5 = widget.v5;
    _v6 = widget.v6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 80),
          child: Center(
            child: Column(
              children: [
                titleMethod(),
                imageMethod(),
                subtitleMethod(),
                detailMethod(),
                //subtitle1Method(),
                //subjectMethod(),
              ],
            ),
          ),
        ),
      ]),
      floatingActionButton: SpeedDial(
          icon: Icons.format_list_bulleted,
          backgroundColor: Colors.green,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.open_in_browser, color: Colors.white),
              label: 'เว็บไซต์',
              backgroundColor: Colors.green,
              onTap: () {
                _launcherURL(_v5);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.call, color: Colors.white),
              label: 'โทรศัพท์',
              backgroundColor: Colors.green,
              onTap: () async {
                final Uri url = Uri(scheme: 'tel', path: _v6);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  print('cannot launch this url');
                }

                // Add your onPressed code here!
              },
            ),
          ]),
    );
  }

  // Container subjectMethod() {
  //   return Container(
  //       padding: EdgeInsets.only(left: 20),
  //       child: Row(
  //         children: [
  //           Text(_v7),
  //         ],
  //       ));
  // }

  Container subtitle1Method() {
    return Container(
        child: Row(
      children: [
        Text(
          _v6,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ));
  }

  Container detailMethod() {
    return Container(padding: EdgeInsets.only(bottom: 20), child: Text(_v4));
  }

  Row subtitleMethod() {
    return Row(children: [
      Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Text(
          _v2,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
    ]);
  }

  Container imageMethod() {
    return Container(
        padding: EdgeInsets.only(bottom: 30), child: Image.asset(_v3));
  }

  Container titleMethod() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        _v1,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
