import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final title;
  final double width;
  final double fontSize;
  const CustomElevatedButton({
    @required this.title,
    this.width: 4.0,
    this.fontSize: 17.0,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0.0),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200], Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          title,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
