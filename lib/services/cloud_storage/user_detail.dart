import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetailStorage {
  uploadDetail(String fullname, String email, String password,
      String phoneNumber) async {
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
        "post": 0,
        "follower": 0,
        "following": 0,
        "bio": "",
        "created_on": Timestamp.now(),
        "phone_number": phoneNumber,
        "profile_pic": "",
        "user_name": fullname,
        "email": email,
        "password": password,
        "searchfrom": searchList,
      });
    } on FirebaseAuthException catch (e) {
      print("===========");
      print(e.message);
      print("===========");
    }
  }
}
