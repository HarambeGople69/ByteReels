import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/screens/dashboard/full_screen_player.dart';
import 'package:myapp/services/home_video_check.dart';
import 'package:myapp/widgets/our_spinner.dart';

import '../../models/user_model.dart';
import '../../models/video_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          // margin: EdgeInsets.symmetric(
          //   horizontal: ScreenUtil().setSp(10),
          //   vertical: ScreenUtil().setSp(10),
          // ),
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.cover,
            height: ScreenUtil().setSp(150),
            width: ScreenUtil().setSp(150),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                // print("object 1111");
                UserModel userModel = UserModel.fromMap(snapshot.data!.docs[0]);
                // return Text(userModel.email);
                return FutureBuilder(
                  future: HomeVideoCheck().check(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      print("object");
                      return PageView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            // return Text("Utsav Shrestha");
                            // VideoModel videoModel =
                            //     VideoModel.fromMap(snapshot.data[index]);
                            if (userModel.followingList
                                .contains(snapshot.data[index].ownerId)) {
                              return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("Videos")
                                    .doc(snapshot.data[index].ownerId)
                                    .collection("MyVideos")
                                    .doc(snapshot.data[index].postId)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    VideoModel videoModel =
                                        VideoModel.fromMap(snapshot.data!);
                                    return FullScreenPlay(
                                      videoModel: videoModel,
                                      addback: false,
                                    );
                                  }
                                  return SizedBox(
                                    height: 0,
                                    width: 0,
                                  );
                                },
                              );
                            }
                            return Container();
                          });
                    }
                    return Container();
                  },
                );
              }
              return Container();
            },
          ),
        ],
      )),
    );
  }
}
