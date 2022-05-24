import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/models/video_model.dart';
import 'package:myapp/services/local_push_notification/local_push_notification.dart';
import 'package:uuid/uuid.dart';

class CommentDetailFirebase {
  uploadComment(String comment, VideoModel videoModel) async {
    print("object");
    var uid = Uuid().v4();
    try {
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
        "commentNumber": videoModel.commentNumber + 1,
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection("Videos")
            .doc(videoModel.ownerId)
            .collection("MyVideos")
            .doc(videoModel.postId)
            .collection("Comments")
            .doc(uid)
            .set({
          "ownerId": FirebaseAuth.instance.currentUser!.uid,
          "comment": comment,
          "commentId": uid,
          "timestamp": Timestamp.now(),
        }).then((value) async {
          if (videoModel.ownerId != FirebaseAuth.instance.currentUser!.uid) {
            await LocalNotificationService().sendNotification(
              "${userModel.user_name} commented on your video",
              "",
          "${userModel.profile_pic}",

              "${videoModel.thumbnailUrl}",
              videoUserModel.token,
            );
          }
          print("comment added");
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
