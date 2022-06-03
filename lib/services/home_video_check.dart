import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/video_model.dart';

import '../models/user_model.dart';

class HomeVideoCheck {
  Future<List<VideoModel>?> check() async {
    List<VideoModel> videoIDS = [];
    UserModel usermodel = UserModel.fromMap(await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get());
    var abc = await FirebaseFirestore.instance
        .collection("AllVideos")
        .get()
        .then((snapshot) async {
      for (DocumentSnapshot doc in snapshot.docs) {
        // await doc.reference.delete();
        VideoModel videoModel = VideoModel.fromMap(doc);
        if (usermodel.followingList.contains(videoModel.ownerId)) {
          videoIDS.add(videoModel);
          print(videoModel.caption);
        }
        print("======");
      }
      print(videoIDS);
    });
    return videoIDS;
  }
}
