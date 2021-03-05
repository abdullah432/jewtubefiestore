import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jewtubefirestore/utils/constants.dart';

class MyDrawer extends StatelessWidget {
  final dividerColor = Colors.grey;
  final channelList;
  const MyDrawer({
    @required this.channelList,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isAdmin
        ? Drawer(
            child: ListView(children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Center(
                child: Icon(
                  FlutterIcons.user_faw,
                  size: 50,
                ),
                // CircleAvatar(
                //   backgroundImage: AssetImage("assets/account.png"),
                //   radius: 70,
                // ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "ADMIN NAME",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 5,
                color: dividerColor,
              ),
              ListTile(
                title: Text("Show All Videos"),
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                  // Resources.navigationKey.currentState
                  //     .pushNamed('/admin_all_videos');
                },
              ),
              Divider(
                thickness: 5,
                color: dividerColor,
              ),
              channelList.length > 0
                  ? Container()
                  : Container(
                      child: Center(
                        child: Text("No Channel To View"),
                      ),
                    ),
              for (var channel in channelList)
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: channel.imgUrl == ""
                        ? AssetImage("assets/no_img.png")
                        : CachedNetworkImageProvider(channel.imgUrl),
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        // deleteChannel(channel.channelID).whenComplete(() {
                        //   getAllChannels();
                        // });
                      }),
                  title: Text(channel.channelName),
                  onTap: () {
                    print(channel.channelName);
                    scaffoldKey.currentState.openEndDrawer();
                    // Resources.navigationKey.currentState.pushNamed(
                    //     '/channel_page',
                    //     arguments: channel.channelID);
                  },
                ),
              Divider(
                thickness: 2,
                color: dividerColor,
              ),
              ListTile(
                onTap: () {
//                   Alert(
//                       context: context,
//                       title: "ADD A CHANNEL",
//                       content: _progressAddChannel
//                           ? Center(
//                               child: CircularProgressIndicator(),
//                             )
//                           : StatefulBuilder(builder:
//                               (BuildContext context, StateSetter setState) {
//                               return Column(
//                                 children: <Widget>[
//                                   Center(
//                                     child: GestureDetector(
//                                       child: CircleAvatar(
//                                         radius: 50,
//                                         backgroundImage: file == null
//                                             ? AssetImage("assets/addImg.png")
//                                             : MemoryImage(
//                                                 file.readAsBytesSync()),
//                                       ),
//                                       onTap: () async {
// //                                                    FilePicker.getFile(
// //                                                            type:
// //                                                                FileType.IMAGE)
// //                                                        .then((value_file) {
// //                                                      setState(() {
// //                                                        file = value_file;
// //                                                        print("PATH   : " +
// //                                                            file.path);
// //                                                      });
// //                                                    });
//                                         ImagePicker imagePicker =
//                                             new ImagePicker();
//                                         imagePicker
//                                             .getImage(
//                                                 source: ImageSource.gallery,
//                                                 imageQuality: 75,
//                                                 maxHeight: 200,
//                                                 maxWidth: 200)
//                                             .then((pickedFile) {
//                                           setState(() {
//                                             file = File(pickedFile.path);
//                                             print("PATH   : " + file.path);
//                                           });
//                                         });
//                                         //
//                                       },
//                                     ),
//                                   ),
//                                   TextField(
//                                     onChanged: (value) {
//                                       chnlName = value;
//                                     },
//                                     decoration: InputDecoration(
//                                       icon: Icon(Icons.account_circle),
//                                       labelText: 'Channel Name',
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }),
//                       buttons: [
//                         DialogButton(
//                           onPressed: () async {
//                             if (file != null) {
//                               bool isChannelAlreadyExist = false;
//                               if (_channelList != null) {
//                                 _channelList.forEach((channel) {
//                                   if (chnlName.trim().toLowerCase() ==
//                                       channel.channelName
//                                           .trim()
//                                           .toLowerCase()) {
//                                     isChannelAlreadyExist = true;
//                                   }
//                                 });
//                               }
//                               if (!isChannelAlreadyExist) {
//                                 Navigator.pop(context);
//                                 setState(() {
//                                   _progressAddChannel = true;
//                                 });
//                                 Dio dio = new Dio();
//                                 var filename = (basename(file.path));
//                                 var response = await dio.post(
//                                     "http://${Resources.BASE_URL}/channel/add",
//                                     data: {
//                                       "file": file.readAsBytesSync(),
//                                       "name": filename,
//                                       "title": chnlName,
//                                     }).whenComplete(() {
//                                   showToast(
//                                       message: "Channel added successfully.");
//                                 });
//                                 // print(response.data);
//                                 getAllChannels();
//                                 setState(() {
//                                   _progressAddChannel = false;
//                                 });
//                                 file = null;
//                               } else {
//                                 showToast(
//                                     message:
//                                         "Channel already exist try to change name.");
//                               }
//                             } else {
//                               print("FILE NULL");
//                               showToast(message: "No File Selected");
//                             }
//                           },
//                           child: Text(
//                             "ADD",
//                             style: TextStyle(color: Colors.white, fontSize: 20),
//                           ),
//                         ),
//                         DialogButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text(
//                             "CANCEL",
//                             style: TextStyle(color: Colors.white, fontSize: 20),
//                           ),
//                         )
//                       ]).show();
                },
                leading: Icon(FlutterIcons.plus_circle_faw),
                title: Text("ADD A NEW CHANNEL"),
              )
            ]),
          )
        : null;
  }
}
