import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/services/cloud_storage/video_detail.dart';
import 'package:myapp/services/compression/compress_image.dart';
import 'package:myapp/services/compression/compress_video.dart';
import 'package:myapp/services/firebase_storage/user_info_storage.dart';

class VideoStorage {
  uploadVideo(String? title, String filePath) async {
    try {
      print("Inside Video Storage");
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      String downloadVideoUrl = "";
      File compressedVideo = await compressVideo(filePath);
      String fileVideoname = compressedVideo.path.split('/').last;

      final uploadVideoFile = await firebaseStorage
          .ref(
              "${FirebaseAuth.instance.currentUser!.uid}/videos/${fileVideoname}")
          .putFile(compressedVideo);
      if (uploadVideoFile.state == TaskState.success) {
        downloadVideoUrl = await firebaseStorage
            .ref(
                "${FirebaseAuth.instance.currentUser!.uid}/videos/${fileVideoname}")
            .getDownloadURL();
        String downloadThumbUrl = "";
        File compressedThumb = await getThumbNail(filePath);
        String fileThumbname = compressedVideo.path.split('/').last;

        final uploadFile = await firebaseStorage
            .ref(
                "${FirebaseAuth.instance.currentUser!.uid}/Thumb_nail/${fileThumbname}")
            .putFile(compressedThumb);
        if (uploadFile.state == TaskState.success) {
          downloadThumbUrl = await firebaseStorage
              .ref(
                  "${FirebaseAuth.instance.currentUser!.uid}/Thumb_nail/${fileThumbname}")
              .getDownloadURL();
        }
        print("Done");
        print("================");

        print("================");
        print("Done");
        print("================");

        print("Done");
        print("================");

        print("Done");
        print("================");

        print("Done");
        print("================");

        print("Done");
        await VideoDetailStorage()
            .uploadVideo(downloadThumbUrl, downloadVideoUrl, title);
        await UserProfileUpload().addPostNumberIncrement();
      } else {}
    } catch (e) {
      print("================");
      print(e.toString());
    }
  }
}
