import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/video_model.dart';
import 'package:uuid/uuid.dart';

class CommentDetailFirebase {
  uploadComment(String comment, VideoModel videoModel) async {
    print("object");
    var uid = Uuid().v4();
    try {
      await FirebaseFirestore.instance
          .collection("Videos")
          .doc(videoModel.ownerId)
          .collection("MyVideos")
          .doc(videoModel.postId)
          .update({
        "commentNumber": videoModel.commentNumber + 1,
      }).then(
        (value) => print("comment number increased"),
      );

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
      }).then((value) => print("comment added"));
    } catch (e) {
      print(e);
    }
  }
}
