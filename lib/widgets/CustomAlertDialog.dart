import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback onConfirmClick;
  const CustomAlertDialog({
    @required this.onConfirmClick,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete'),
      content: Text('Are you sure you want to delete this channel'),
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
