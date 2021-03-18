import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Channel {
  Channel({
    @required this.channelName,
    this.profileurl,
  });

  String channelName;
  String profileurl;
  List<dynamic> subscriberlist;
  DocumentReference reference;

  Map<String, dynamic> toMap() {
    return {
      'channelname': channelName,
      'profileurl': profileurl,
      'subscriberlist': [],
    };
  }

  Channel.fromMap(Map<String, dynamic> map, {this.reference})
      : channelName = map['channelname'],
        profileurl = map['profileurl'],
        subscriberlist = List.from(map['subscriberlist']);

  Channel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
