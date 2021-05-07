import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'circularbutton.dart';

class MyAvatar extends StatelessWidget {
  final PlatformFile pickedFile;
  final double radius;
  final VoidCallback onTap;
  const MyAvatar({
    @required this.pickedFile,
    this.radius: 55,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pickedFile == null) {
      return defaultAvatar(context);
    } else {
      return GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: radius - 10,
          backgroundImage: kIsWeb
              // ? NetworkImage(pickedFile.path)
              ? MemoryImage(pickedFile.bytes)
              : FileImage(File(pickedFile.path)),
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
