import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/cloud_storage/user_detail.dart';
import 'package:myapp/widgets/our_flutter_toast.dart';

import '../compression/compress_image.dart';

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
    }
  }

  addPostNumberIncrement() async {
    UserModel userModel = UserModel.fromMap(
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
    );
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {
          "post": userModel.post + 1,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  removePostNumberIncrement() async {
    UserModel userModel = UserModel.fromMap(
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),

    );
      try {
        await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {
          "post": userModel.post - 1,
        },
      );
      } catch (e) {
        print(e);
      }
  }

}
