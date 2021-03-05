import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final double height;

  CustomAppBar({this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [Colors.orange[200], Colors.pinkAccent]),
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  print("pop");
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class CustomAppBar extends PreferredSize {
//   @override
//   Widget build(BuildContext context) {
//     // double height = MediaQuery.of(context).size.height;
//     // double width = MediaQuery.of(context).size.width;
//     return Container(
//       // height: height / 10,
//       // width: width,
//       height: preferredSize.height,
//       padding: EdgeInsets.only(left: 15, top: 25),
//       decoration: BoxDecoration(
//         gradient:
//             LinearGradient(colors: [Colors.orange[200], Colors.pinkAccent]),
//       ),
//       child: Row(
//         children: <Widget>[
//           IconButton(
//               icon: Icon(
//                 Icons.arrow_back,
//               ),
//               onPressed: () {
//                 print("pop");
//                 Navigator.of(context).pop();
//               })
//         ],
//       ),
//     );
//   }
// }
