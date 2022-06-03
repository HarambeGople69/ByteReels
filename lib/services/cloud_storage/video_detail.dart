import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/video_model.dart';
import 'package:myapp/widgets/our_flutter_toast.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_model.dart';
import '../firebase_storage/user_info_storage.dart';
import '../local_push_notification/local_push_notification.dart';

class VideoDetailStorage {
  Future<void> uploadVideo(
      String thumbnailUrl, String videoUrl, String? caption) async {
    print("===============");
    print("Inside video detail");
    print("===============");

    String uid = Uuid().v4();

    try {
      await FirebaseFirestore.instance
          .collection("Videos")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("MyVideos")
          .doc(uid)
          .set({
        "postId": uid,
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "caption": caption,
        "thumbnailUrl": thumbnailUrl,
        "videoUrl": videoUrl,
        "timestamp": Timestamp.now(),
        "likes": [],
        "likeNumber": 0,
        "commentNumber": 0,
        "downloadNumber": 0,
      });
      await FirebaseFirestore.instance.collection("AllVideos").doc(uid).set({
        "postId": uid,
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "caption": caption,
        "thumbnailUrl": thumbnailUrl,
        "videoUrl": videoUrl,
        "timestamp": Timestamp.now(),
        "likes": [],
        "likeNumber": 0,
        "commentNumber": 0,
        "downloadNumber": 0,
      }).then(
        (value) => OurToast().showSuccessToast("Video uploaded successfully"),
      );
    } catch (e) {
      print("=============");
      print(e.toString());
      print("=============");
    }
  }

  deleteVideo(VideoModel videoModel) async {
    print("Delete video");
    try {
      await FirebaseFirestore.instance
          .collection("Videos")
          .doc(videoModel.ownerId)
          .collection("MyVideos")
          .doc(videoModel.postId)
          .delete()
          .then((value) async {
        await UserProfileUpload().removePostNumberIncrement();
        OurToast().showSuccessToast("Post Deleted");
      });
    } catch (e) {
      print(e);
    }
  }

  increaseDownloadCount(VideoModel videoModel) async {
    print("Increase video number count");
    UserModel videoUserModel = UserModel.fromMap(await FirebaseFirestore
        .instance
        .collection("Users")
        .doc(videoModel.ownerId)
        .get());
    // UserModel userModel = UserModel.fromMap(await FirebaseFirestore.instance
    //     .collection("Users")
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .get());
    await FirebaseFirestore.instance
        .collection("Videos")
        .doc(videoModel.ownerId)
        .collection("MyVideos")
        .doc(videoModel.postId)
        .update({
      "downloadNumber": videoModel.downloadNumber + 1,
    }).then((value) async {
      if (videoModel.ownerId != FirebaseAuth.instance.currentUser!.uid) {
        await LocalNotificationService().sendNotification(
          "Someone downloaded your video",
          "",
          "",
          "${videoModel.thumbnailUrl}",
          videoUserModel.token,
        );
      }
    });
  }
}
