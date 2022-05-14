import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../controllers/processing_controller.dart';
import '../../db/db_helper.dart';

class AuthenticationService {
  signup(String fullName, String email, String password,
      String phoneNumber) async {
    Get.find<ProcessingController>().toggle(true);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(value.user!.uid);
        print("Sign Up successful");
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    Get.find<ProcessingController>().toggle(false);
  }

  login(String email, String password) async {
    Get.find<ProcessingController>().toggle(true);

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await Hive.box<int>(DatabaseHelper.authenticationDB).put("state", 1);
        await Hive.box<String>(DatabaseHelper.userIdDB)
            .put("uid", value.user!.uid);
        print(value.user!.uid);

        print("Login Successful");
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    Get.find<ProcessingController>().toggle(false);
  }

  logout() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Hive.box<String>(DatabaseHelper.userIdDB).clear();
        Hive.box<int>(DatabaseHelper.authenticationDB).clear();
      });
      print("LogOut");
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
