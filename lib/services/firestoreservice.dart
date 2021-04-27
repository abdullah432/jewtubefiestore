import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:jewtubefirestore/model/channel.dart';
import 'package:jewtubefirestore/model/user.dart';
import 'package:jewtubefirestore/model/video.dart';
import 'package:jewtubefirestore/services/firebase_auth_service.dart';
import 'package:jewtubefirestore/utils/constants.dart';
import 'package:provider/provider.dart';

enum FirestoreJob {
  JobNotStartedYet,
  JobInProgess,
  JobSuccess,
  JobFail,
}

class FirestoreService with ChangeNotifier {
  FirestoreService({this.uid});
  final db = FirebaseFirestore.instance;
  String uid;

  //data
  FirestoreJob _firestoreJob = FirestoreJob.JobNotStartedYet;

  //job getter
  FirestoreJob get firestoreJob => _firestoreJob;
  //job setter
  void jobStarted() {
    _firestoreJob = FirestoreJob.JobInProgess;
    notifyListeners();
  }

  //job setter
  void jobEnded() {
    _firestoreJob = FirestoreJob.JobSuccess;
    notifyListeners();
  }

  Future<void> createUser({@required CurrentUser user}) async {
    jobStarted();
    await db.collection("users").doc(uid).set(user.toMap());
    jobEnded();
    return;
  }

  Future<DocumentReference> createChannel({
    @required Channel channel,
  }) async {
    jobStarted();
    final ref = db.collection("channels").doc();
    await ref.set(channel.toMap());
    jobEnded();
    return ref;
  }

  Future<List<VideoModel>> loadAllVideos() async {
    final ref = db.collection("videos").orderBy('uploadTime', descending: true);
    var snapshot = await ref.get();
    final List<VideoModel> videolist = snapshot.docs
        .map((snapshot) => VideoModel.fromSnapshot(snapshot))
        .toList();
    return videolist;
  }

  Future<List<VideoModel>> filterVideosByLanugage(String language) async {
    Query ref;
    print(language.toString());
    if (language.toUpperCase() == 'ALL') {
      ref = db.collection("videos").orderBy('uploadTime', descending: true);
    } else {
      ref = db
          .collection("videos")
          .where('language', isEqualTo: language)
          .orderBy('uploadTime', descending: true);
    }

    var snapshot = await ref.get();
    List<VideoModel> videolist = snapshot.docs
        .map((snapshot) => VideoModel.fromSnapshot(snapshot))
        .toList();
    return videolist;
  }

  Future<List<VideoModel>> loadVideosByChannelID(String channelID) async {
    try {
      print('loading videos ');
      final ref = db.collection("videos");
      var snapshot = await ref
          .where(
            'channelID',
            isEqualTo: channelID,
          )
          .orderBy('uploadTime', descending: true)
          .get();
      print(ref.toString());
      final List<VideoModel> videolist = snapshot.docs
          .map((snapshot) => VideoModel.fromSnapshot(snapshot))
          .toList();
      return videolist;
    } catch (e) {
      return [];
    }
  }

  Future<List<VideoModel>> searchVideos(String queryText) async {
    final ref = db.collection("videos");
    var snapshot = await ref
        .orderBy('videoTitle')
        .startAt([queryText.toUpperCase()]).endAt([queryText.toLowerCase()])
        // .limit(15)
        .get();
    final List<VideoModel> videolist = snapshot.docs
        .map((snapshot) => VideoModel.fromSnapshot(snapshot))
        .toList();
    return videolist;
  }

  Future<void> deleteVideo(VideoModel video) async {
    db.collection("videos").doc(video.reference.id).delete();
  }

  Future<CurrentUser> loadUserData(context, {useruid}) async {
    print('load user data');
    try {
      final authService = FirebaseAuthService();
      print('isSignedIn: ' + Constant.isSignedIn.toString());

      if (authService.isUserLoggedIn()) {
        print('isUserLoggedIn: true');
        final loggeduser = authService.currentUser();
        print('loggeduser: ' + loggeduser.uid);
        var snapshot = await db.collection('users').doc(loggeduser.uid).get();
        print('fetched');
        final user = CurrentUser.fromSnapshot(snapshot);
        final currentUser = Provider.of<CurrentUser>(context, listen: false);
        currentUser.updateCurrentUserData(user);
        Constant.isSignedIn = true;
        Constant.isAdmin = user.isAdmin;
        print('Constant.isSignedIn: ' + Constant.isSignedIn.toString());

        return user;
      } else {
        print('isUserLoggedIn: false');
        return null;
      }
    } catch (e) {
      print('error');
      print(e.toString());
      return null;
    }
  }

  Future<List<Channel>> loadChannelList({useruid}) async {
    try {
      final authService = FirebaseAuthService();

      if (authService.isUserLoggedIn()) {
        var snapshot = await db.collection('channels').get();
        List<Channel> channelsList = snapshot.docs
            .map((snapshot) => Channel.fromSnapshot(snapshot))
            .toList();

        return channelsList;
      } else {
        print('isUserLoggedIn: false');
        return [];
      }
    } catch (e) {
      print('error');
      print(e.toString());
      return [];
    }
  }

  Future<List<Channel>> loadSubscribedChannelList({subscribedTo}) async {
    List<Channel> subscribedChannelsList = [];
    final authService = FirebaseAuthService();

    if (authService.isUserLoggedIn()) {
      for (int i = 0; i < subscribedTo.length; i++) {
        var snapshot;
        try {
          snapshot = await db.collection('channels').doc(subscribedTo[i]).get();
          subscribedChannelsList.add(Channel.fromSnapshot(snapshot));
        } catch (e) {
          print(e.toString());
        }
      }

      return subscribedChannelsList;
    } else {
      print('isUserLoggedIn: false');
      return [];
    }
  }

  Future<bool> uploadVideo(VideoModel video) async {
    final ref = db.collection("videos").doc();
    await ref.set(video.toMap());
    return true;
  }

  subscribeToChannel({
    @required channeluid,
    @required useruid,
    @required subscriptionstatus,
  }) {
    if (subscriptionstatus) {
      //already subscribed
      db.collection("users").doc(useruid).update({
        'subscribedTo': FieldValue.arrayRemove([channeluid]),
      });
    } else {
      db.collection("users").doc(useruid).update({
        'subscribedTo': FieldValue.arrayUnion([channeluid]),
      });
    }
  }

  deleteChannel(channeluid) async {
    await db.collection('channels').doc(channeluid).delete();
    return;
  }

  Future<List<CurrentUser>> searchUser({
    @required searchTxt,
    category,
    filter: false,
  }) async {
    try {
      final docRef = db.collection('users');
      if (!filter) {
        print('no filter');

        var querySnapshot = await docRef
            .orderBy('name')
            .startAt([searchTxt.toUpperCase()])
            .endAt([searchTxt.toLowerCase()])
            .limit(15)
            // .where('name', isGreaterThanOrEqualTo: searchTxt)
            .get();
        List<QueryDocumentSnapshot> docs = querySnapshot.docs;
        final userList =
            docs.map((doc) => CurrentUser.fromSnapshot(doc)).toList();
        return userList;
      } else {
        if (searchTxt == null) {
          print('filter with category');

          var querySnapshot = await docRef
              .where('subcategories', arrayContains: category)
              .get();
          List<QueryDocumentSnapshot> docs = querySnapshot.docs;
          final userList =
              docs.map((doc) => CurrentUser.fromSnapshot(doc)).toList();
          return userList;
        } else {
          print('filter with text and category');
          print('searchtxt: ' + searchTxt);
          var querySnapshot = await docRef
              .orderBy('name')
              // .where('name', isEqualTo: searchTxt)
              .startAt([searchTxt.toUpperCase()])
              .endAt([searchTxt.toLowerCase()])
              .where('subcategories', arrayContains: category)
              .get();
          List<QueryDocumentSnapshot> docs = querySnapshot.docs;
          final userList =
              docs.map((doc) => CurrentUser.fromSnapshot(doc)).toList();
          return userList;
        }
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<CurrentUser>> fetchUserListByListOfIDS({
    @required List listOfIDS,
  }) async {
    try {
      List<CurrentUser> usersList = [];
      for (var uid in listOfIDS) {
        var querySnapshot = await db.collection('users').doc(uid).get();
        usersList.add(CurrentUser.fromSnapshot(querySnapshot));
      }
      return usersList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //updates
  // Future<void> updateUserData({
  //   @required context,
  //   @required CurrentUser user,
  //   imageFile,
  // }) async {
  //   try {
  //     _firestoreJob = FirestoreJob.JobInProgess;
  //     notifyListeners();
  //     final currentUser = Provider.of<CurrentUser>(context, listen: false);
  //     user.reference = currentUser.reference;

  //     String downloadUrl;
  //     if (imageFile != null) {
  //       //Upload to storage
  //       final storage =
  //           Provider.of<FirebaseStorageService>(context, listen: false);
  //       downloadUrl = await storage.uploadAvatar(
  //         useruid: user.reference.id,
  //         file: imageFile,
  //       );
  //     }

  //     if (downloadUrl != null) user.profileurl = downloadUrl;

  //     await db.collection("users").doc(uid).update(user.toMap());
  //     // //update local data
  //     // currentUser.updateCurrentUserData(user, isNotify: true);

  //     _firestoreJob = FirestoreJob.JobSuccess;
  //     notifyListeners();
  //   } catch (e) {
  //     print(e.toString());
  //     _firestoreJob = FirestoreJob.JobFail;
  //     notifyListeners();
  //     return;
  //   }
  // }

  // //add to favourite
  // Future<bool> addToRecommendation(Recommended recommended,
  //     CurrentUser currentuser, CurrentUser user) async {
  //   final currentuserid = currentuser.reference.id;
  //   try {
  //     jobStarted();
  //     final docRef1 = db.collection('users').doc(currentuserid);
  //     //increase rating counting
  //     final docRef2 = db.collection('users').doc(user.reference.id);
  //     await docRef2.update({
  //       'recommendedby': FieldValue.arrayUnion([currentuserid]),
  //       'rating': FieldValue.increment(1),
  //     });
  //     // await db.collection('recommendation').doc().set(recommended.toMap());
  //     await docRef1.update({
  //       'recommendedlist': FieldValue.arrayUnion([user.reference.id]),
  //       // 'rating': FieldValue.increment(1),
  //     });
  //     currentuser.recommendedList.add(user.reference.id);
  //     jobEnded();
  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //     jobEnded();
  //     return false;
  //   }
  // }

  // Future<bool> removeRecommendation(Recommended recommended,
  //     CurrentUser currentuser, CurrentUser user) async {
  //   final currentuserid = currentuser.reference.id;
  //   try {
  //     jobStarted();

  //     final docRef1 = db.collection('users').doc(currentuserid);
  //     final docRef2 = db.collection('users').doc(user.reference.id);

  //     await docRef1.update({
  //       'recommendedlist': FieldValue.arrayRemove([user.reference.id]),
  //       // 'rating': FieldValue.increment(-1),
  //     });
  //     await docRef2.update({
  //       'rating': FieldValue.increment(-1),
  //       'recommendedby': FieldValue.arrayRemove([currentuserid]),
  //     });
  //     currentuser.recommendedList.remove(user.reference.id);
  //     jobEnded();
  //     return true;
  //   } catch (e) {
  //     jobEnded();
  //     print(e.toString());
  //     return false;
  //   }
  // }

  //add to user to favourite
  addUserToFavouriteList(userid, currentuseruid) async {
    try {
      // jobStarted();
      final docRef = db.collection('users').doc(currentuseruid);
      await docRef.update({
        'favouritelist': FieldValue.arrayUnion([userid])
      });
      // jobEnded();
    } catch (e) {
      print(e.toString());
      // jobEnded();
    }
  }

  //remove user from favourite list
  removeFromFavouriteList(userid, currentuseruid) async {
    try {
      // jobStarted();
      final docRef = db.collection('users').doc(currentuseruid);
      await docRef.update({
        'favouritelist': FieldValue.arrayRemove([userid])
      });
      // jobEnded();
    } catch (e) {
      print(e.toString());
      jobEnded();
    }
  }
}
