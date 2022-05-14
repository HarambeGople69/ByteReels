import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/services/cloud_storage/user_detail.dart';
import 'package:myapp/widgets/our_flutter_toast.dart';
import '../../controllers/processing_controller.dart';
import '../../db/db_helper.dart';
import '../check peserved name/check_reserved_name.dart';

class AuthenticationService {
  signup(String fullName, String email, String password, String phoneNumber,
      BuildContext context) async {
    Get.find<ProcessingController>().toggle(true);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        print(value.user!.uid);
        final bool response =
            await CheckReservedName().checkThisUserAlreadyPresentOrNot(
          fullName,
          context,
        );
        print("===========");
        print(response);
        print("===========");
        if (response == true) {
          await UserDetailStorage()
              .uploadDetail(fullName, email, password, phoneNumber);
          await Hive.box<int>(DatabaseHelper.authenticationDB).put("state", 1);
          await Hive.box<String>(DatabaseHelper.userIdDB)
              .put("uid", value.user!.uid);
          OurToast().showSuccessToast("Sign up successful");
        } else {
          OurToast().showErrorToast("Username already reserved");
          await FirebaseAuth.instance.currentUser!.delete();
          // await FirebaseAuth.instance.signOut();
        }
        Navigator.pop(context);
        print("Sign Up successful");
      });
    } on FirebaseAuthException catch (e) {
      OurToast().showErrorToast(e.message!);
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
        OurToast().showSuccessToast("Login successful");
      });
    } on FirebaseAuthException catch (e) {
      OurToast().showErrorToast(e.message!);
      // print(e);
    }
    Get.find<ProcessingController>().toggle(false);
  }

  logout() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Hive.box<String>(DatabaseHelper.userIdDB).clear();
        Hive.box<int>(DatabaseHelper.authenticationDB).clear();
        OurToast().showSuccessToast("Logout successful");
      });
      print("LogOut");
    } on FirebaseAuthException catch (e) {
      OurToast().showErrorToast(e.message!);
      print(e);
    }
  }
}
