import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/widgets/our_flutter_toast.dart';

class UserDetailStorage {
  initialize(String fullname, String email, String password,
      String phoneNumber,String imageUrl) async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("===============");
    print("Inside user detail storage");
    print("===============");
    List<String> searchList = [];
    for (int i = 0; i <= fullname.length; i++) {
      searchList.add(
        fullname.substring(0, i).toLowerCase(),
      );
    }
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "post": 0,
        "follower": 0,
        "following": 0,
        "bio": "",
        "created_on": Timestamp.now(),
        "phone_number": phoneNumber,
        "profile_pic": imageUrl,
        "user_name": fullname,
        "email": email,
        "password": password,
        "searchfrom": searchList,
        "followerList": [],
        "followingList": [],
        "token": token,
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "token": token,
      });
    } catch (e) {
      print(e);
    }
  }

  update(String fullname, String bio, String imageurl) async {
    print("===============");
    print("Inside user update storage");
    print("===============");
    List<String> searchList = [];
    for (int i = 0; i <= fullname.length; i++) {
      searchList.add(
        fullname.substring(0, i).toLowerCase(),
      );
    }
    try {
      if (imageurl.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "bio": bio,
          "profile_pic": imageurl,
          "user_name": fullname,
          "searchfrom": searchList,
        });
      } else {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "bio": bio,
          "user_name": fullname,
          "searchfrom": searchList,
        });
      }
      OurToast().showSuccessToast("Profile Updated");
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}
