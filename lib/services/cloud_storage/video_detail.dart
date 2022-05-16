import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/widgets/our_flutter_toast.dart';
import 'package:uuid/uuid.dart';

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
      }).then(
        (value) => OurToast().showSuccessToast("Video uploaded successfully"),
      );
    } catch (e) {
      print("=============");
      print(e.toString());
      print("=============");
    }
  }
}
