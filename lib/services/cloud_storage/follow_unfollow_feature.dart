import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/user_model.dart';

class FollowUnfollowDetailFirebase {
  follow(UserModel userModel) async {
    print("Inside follow");
    try {
      UserModel followeruserModel = UserModel.fromMap(await FirebaseFirestore
          .instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get());

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userModel.uid)
          .update({
        "followerList": FieldValue.arrayUnion([followeruserModel.uid]),
        "follower": userModel.follower + 1,
      });

      // await FirebaseFirestore.instance
      //     .collection("Notification")
      //     .doc(userModel.uid)
      //     .collection("Notify")
      //     .doc(followeruserModel.uid)
      //     .set({
      //   "senderId": followeruserModel.uid,
      //   "post_pic": "",
      //   "postId": "",
      //   "timestamp": Timestamp.now(),
      //   "senderProfile": followeruserModel.profile_pic,
      //   "comment": "",
      //   "type": "follow",
      //   "senderName": followeruserModel.user_name,
      // });

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(followeruserModel.uid)
          .update({
        "followingList": FieldValue.arrayUnion([userModel.uid]),
        "following": followeruserModel.following + 1,
      });
    } catch (e) {
      print(e);
    }
  }

  unfollow(UserModel userModel) async {
    UserModel followeruserModel = UserModel.fromMap(await FirebaseFirestore
        .instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get());

    // await FirebaseFirestore.instance
    //     .collection("Notification")
    //     .doc(userModel.uid)
    //     .collection("Notify")
    //     .doc(followeruserModel.uid)
    //     .delete();

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.uid)
        .update({
      "followerList": FieldValue.arrayRemove([followeruserModel.uid]),
      "follower": userModel.follower - 1,
    });

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(followeruserModel.uid)
        .update({
      "followingList": FieldValue.arrayRemove([userModel.uid]),
      "following": followeruserModel.following - 1,
    });
    print("Geda Done=================");
  }
}
