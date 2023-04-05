import 'package:firstapp/Pages/detail.dart';
import 'package:firstapp/Pages/mappage.dart';
import 'package:firstapp/Pages/reviewpage.dart';
import 'package:firstapp/Pages/subjectpage.dart';
import 'package:firstapp/database/comment.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class NavigationbarPage extends StatefulWidget {
  //const Test({super.key});
  final v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11;
  NavigationbarPage(this.v1, this.v2, this.v3, this.v4, this.v5, this.v6,
      this.v7, this.v8, this.v9, this.v10, this.v11);

  @override
  State<NavigationbarPage> createState() => _NavigationbarPageState();
}

class _NavigationbarPageState extends State<NavigationbarPage> {
  int _currentIndex = 0;
  //final tabs = [DetailPage('A', 'C', 'D'), MapPage('Z')];
  var _v1, _v2, _v3, _v4, _v5, _v6, _v7, _v8, _v9, _v10, _v11;
  dynamic tabs = [];
  final texts = ['เนื้อหา', 'หลักสูตร', 'แผนที่', 'แสดงความเห็น'];
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
    _v7 = widget.v7;
    _v8 = widget.v8;
    _v9 = widget.v9;
    _v10 = widget.v10;
    _v11 = widget.v11;

    tabs = [
      DetailPage(_v1, _v2, _v3, _v4, _v5, _v8),
      SubjectPage(_v6, _v7),
      MapsPage(_v9, _v10, _v11, _v1),
      ReviewPage(_v1),
    ];
  }

  // final tabs = [DetailPage(), MapPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(texts[_currentIndex])),
      body: tabs[_currentIndex],
      /* Column(
        children: [Text(_v1), Text(_v2), Text(_v3), Text(_v4)],
      ),*/
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'เนื้อหา',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                label: 'หลักสูตร',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.map,
                ),
                label: ' แผนที่',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.reviews,
                ),
                label: 'แสดงความเห็น',
                backgroundColor: Colors.green),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}
