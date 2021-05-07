import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jewtubefirestore/model/channel.dart';
import 'package:jewtubefirestore/services/channelservice.dart';
import 'package:jewtubefirestore/services/file_picker_service.dart';
import 'package:jewtubefirestore/utils/methods.dart';
import 'package:provider/provider.dart';
import '../myavatar.dart';

class CreateNewChannelDialogBox extends StatefulWidget {
  const CreateNewChannelDialogBox({Key key}) : super(key: key);

  @override
  _CreateNewChannelDialogBoxState createState() =>
      _CreateNewChannelDialogBoxState();
}

class _CreateNewChannelDialogBoxState extends State<CreateNewChannelDialogBox> {
  PlatformFile profileImageFile;
  final channelNameController = TextEditingController();
  bool isChannelCreationInPrgoress = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // elevation: 0,
          // backgroundColor: Colors.transparent,
          child: contentBox(context),
        ),
      ),
    );
  }

  contentBox(context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.0),
          Text(
            'ADD A CHANNEL',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Consumer<FilePickerService>(
            builder: (context, filepicker, child) {
              profileImageFile = filepicker.pickedFile.platformFile;
              // print('path:' + profileImageFile?.path);

              return MyAvatar(
                pickedFile: filepicker.pickedFile.platformFile,
                onTap: () => Methods.chooseFileFromGallery(context,
                    fileType: FileType.image),
              );
            },
          ),
          // CircleAvatar(
          //   radius: 50,
          //   backgroundImage: file == null
          //       ? AssetImage("assets/addImg.png")
          //       : MemoryImage(file.readAsBytesSync()),
          // ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: TextFormField(
              controller: channelNameController,
              decoration: InputDecoration(hintText: 'Channel Name'),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                Container(
                  width: 110.0,
                  child: TextButton(
                    onPressed: () async {
                      final channelService =
                          Provider.of<ChannelService>(context, listen: false);
                      setState(() {
                        isChannelCreationInPrgoress = true;
                      });
                      await channelService.createChannel(
                        context,
                        channel: Channel(
                            channelName: channelNameController.text.trim()),
                        imagefile: profileImageFile,
                      );
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'ADD',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
                //
                SizedBox(width: 15.0),

                //
                Container(
                  width: 110.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Visibility(
            visible: isChannelCreationInPrgoress,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
