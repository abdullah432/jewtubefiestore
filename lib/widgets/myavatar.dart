import 'dart:io';
import 'package:flutter/material.dart';

import 'circularbutton.dart';

class MyAvatar extends StatelessWidget {
  final File file;
  final double radius;
  final VoidCallback onTap;
  const MyAvatar({
    @required this.file,
    this.radius: 55,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return defaultAvatar(context);
    } else {
      return GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: radius - 10,
          backgroundImage: FileImage(file),
        ),
      );
    }
  }

  defaultAvatar(context) {
    return Stack(
      children: [
        CircularButton(
          icon: Icons.person,
          iconSize: radius,
          padding: const EdgeInsets.all(12.0),
          onPressed: onTap,
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: Transform.translate(
            offset: Offset(6, 12),
            child: CircularButton(
              icon: Icons.camera_alt,
              iconSize: radius - 40,
              iconColor: Colors.white,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
      ],
    );
  }
}
