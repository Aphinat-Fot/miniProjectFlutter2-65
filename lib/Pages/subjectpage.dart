import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class SubjectPage extends StatefulWidget {
  //const SubjectPage({super.key});
  final v1, v2;
  SubjectPage(this.v1, this.v2);
  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  var _v1, _v2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _v1 = widget.v1;
    _v2 = widget.v2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 18, left: 20, right: 20, bottom: 80),
      child: Center(
        child: Column(
          children: [
            Text(
              _v1,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(_v2)
          ],
        ),
      ),
    );
  }
}
