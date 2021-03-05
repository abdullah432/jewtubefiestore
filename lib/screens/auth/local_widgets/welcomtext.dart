import 'package:flutter/material.dart';

class WelcomeTxt extends StatelessWidget {
  final width;
  final height;
  final fontSize;
  const WelcomeTxt({
    this.width,
    this.height,
    this.fontSize,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return welcomeTextRow();
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: width / 20, top: height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
