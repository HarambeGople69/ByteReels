import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/cloud_storage/user_detail.dart';
import 'package:myapp/services/compress%20image/compress_image.dart';
import 'package:myapp/widgets/our_flutter_toast.dart';

class UserProfileUpload {
  uploadProfile(
    String name,
    String bio,
    File? file,
  ) async {
    print("Inside uploadProfile");
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    String downloadUrl = "";
    try {
      if (file != null) {
        try {
          File compressedFile = await compressImage(file);
          String filename = compressedFile.path.split('/').last;
          print("Inside here");
          final uploadFile = await firebaseStorage
              .ref(
                  "${FirebaseAuth.instance.currentUser!.uid}/profile_image/${filename}")
              .putFile(compressedFile);
          if (uploadFile.state == TaskState.success) {
            downloadUrl = await firebaseStorage
                .ref(
                    "${FirebaseAuth.instance.currentUser!.uid}/profile_image/${filename}")
                .getDownloadURL();
            UserDetailStorage().update(name, bio, downloadUrl);
          }
          print("Uploaded=======================");
        } catch (e) {
          print("==============");
          print(e.toString());
          OurToast().showErrorToast(e.toString());
        }
      } else {
        UserDetailStorage().update(name, bio, "");
        print("Uploaded=======================");
      }
    } on FirebaseAuthException catch (e) {
      OurToast().showErrorToast(e.message!);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       e.message!,
      //       style: TextStyle(fontSize: ScreenUtil().setSp(15)),
      //     ),
      //   ),
      // );
    }
  }

  // EditProfile(String name,UserModel userModel, String bio, File? file, BuildContext context,
  //     [String imageUrl = ""]) async {
  //   print("Inside editProfile");
  //   // AlertWidget().showLoading(context);

  //   FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  //   String downloadUrl = "";
  //   try {
  //     if (file != null) {
  //       File compressedFile = await compressImage(file);
  //       String filename = compressedFile.path.split('/').last;
  //       final uploadFile = await firebaseStorage
  //           .ref(
  //               "${FirebaseAuth.instance.currentUser!.uid}/profile_image/${filename}")
  //           .putFile(compressedFile);
  //       if (uploadFile.state == TaskState.success) {
  //         downloadUrl = await firebaseStorage
  //             .ref(
  //                 "${FirebaseAuth.instance.currentUser!.uid}/profile_image/${filename}")
  //             .getDownloadURL();
  //         UserDetailFirestore().editProfile(name, bio, downloadUrl, userModel);
  //       }
  //       print("Uploaded=======================");
  //       Navigator.pop(context);
  //     } else {
  //       UserDetailFirestore().editProfile(name, bio, imageUrl,userModel);
  //       print("Uploaded=======================");
  //       Navigator.pop(context);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     Navigator.pop(context);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           e.message!,
  //           style: TextStyle(fontSize: ScreenUtil().setSp(15)),
  //         ),
  //       ),
  //     );
  //   }
  // }
}
