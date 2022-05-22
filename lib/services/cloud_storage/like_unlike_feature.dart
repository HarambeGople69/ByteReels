import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/video_model.dart';

import '../../models/user_model.dart';
import '../local_push_notification/local_push_notification.dart';

class LikeUnlikeFeature {
  likeunlike(VideoModel videoModel) async {
    print("Inside like unlike");
    try {
      if (videoModel.likes.contains(FirebaseAuth.instance.currentUser!.uid) ==
          true) {
        await FirebaseFirestore.instance
            .collection("Videos")
            .doc(videoModel.ownerId)
            .collection("MyVideos")
            .doc(videoModel.postId)
            .update({
          "likes":
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
          "likeNumber": videoModel.likeNumber - 1,
        }).then((value) => print("Unliked"));
        print("Already likes");
        return false;
      } else {
        UserModel videoUserModel = UserModel.fromMap(await FirebaseFirestore
            .instance
            .collection("Users")
            .doc(videoModel.ownerId)
            .get());
        UserModel userModel = UserModel.fromMap(await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get());

        await FirebaseFirestore.instance
            .collection("Videos")
            .doc(videoModel.ownerId)
            .collection("MyVideos")
            .doc(videoModel.postId)
            .update({
          "likes":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
          "likeNumber": videoModel.likeNumber + 1,
        }).then((value) async {
          print(videoUserModel.token);
          if (videoModel.ownerId != FirebaseAuth.instance.currentUser!.uid) {
            await LocalNotificationService().sendNotification(
              "${userModel.user_name} liked your video",
              "",
              videoUserModel.token,
            );
          }

          print("liked");
        });
        print("First time");
        return true;
      }
    } catch (e) {
      print("====================");
      print(e);
      print("====================");
    }
  }
}
