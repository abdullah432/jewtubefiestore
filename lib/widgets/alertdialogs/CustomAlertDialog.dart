import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirmClick;
  const CustomAlertDialog({
    @required this.onConfirmClick,
    this.title: 'Delete',
    this.content: 'Are you sure you want to delete this channel',
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onConfirmClick,
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: Text(
            'Yes',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: Text(
            'No',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ],
    );
  }
}
