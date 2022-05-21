import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/video_model.dart';

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
        await FirebaseFirestore.instance
            .collection("Videos")
            .doc(videoModel.ownerId)
            .collection("MyVideos")
            .doc(videoModel.postId)
            .update({
          "likes":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
          "likeNumber": videoModel.likeNumber + 1,
        }).then((value) => print("liked"));
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
