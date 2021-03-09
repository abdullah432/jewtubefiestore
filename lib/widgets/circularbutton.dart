import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final VoidCallback onPressed;
  const CircularButton({
    @required this.icon,
    this.color: Colors.white,
    this.iconColor: Colors.red,
    this.iconSize: 25.0,
    this.padding: const EdgeInsets.all(8.0),
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Padding(
          padding: padding,
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
