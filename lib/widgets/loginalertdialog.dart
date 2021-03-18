import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class EnableSubscriptionDialogBox extends StatelessWidget {
  final VoidCallback onLoginClick;
  const EnableSubscriptionDialogBox({
    @required this.onLoginClick,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.0),
          Icon(
            FlutterIcons.info_outline_mdi,
            size: 100,
            color: Colors.blue,
          ),
          SizedBox(height: 10.0),
          Text(
            'LOGIN',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10.0),
          Text(
            'You need to login to enable these features.',
            style: TextStyle(
              // color: CustomColor.highlightedColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0),
          Container(
            width: MediaQuery.of(context).size.width / 1.50,
            child: TextButton(
              onPressed: onLoginClick,
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                'LOGIN',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
