import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/screens/dashboard/message_send_screen.dart';
import 'package:myapp/utils/colors.dart';
import 'package:page_transition/page_transition.dart';

import '../../models/messanger_home_model.dart';
import '../../models/user_model.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Messages",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(25),
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          backgroundColor: logoColor),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(20),
          vertical: ScreenUtil().setSp(10),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("ChatRoom")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Chat")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.length > 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      MessangeHomeModel messangeHomeModel =
                          MessangeHomeModel.fromJson(
                              snapshot.data!.docs[index]);
                      // return Text(messangeHomeModel.uid);
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .where("uid", isEqualTo: messangeHomeModel.uid)
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            // return Text("UTsav");
                            if (snapshot.data!.docs.length > 0) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    UserModel userModel = UserModel.fromMap(
                                        snapshot.data!.docs[index]);
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.leftToRight,
                                            child: MessageSendScreen(
                                              userModel: userModel,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil().setSp(10),
                                          vertical: ScreenUtil().setSp(10),
                                        ),
                                        child: Row(
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.start,
                                          children: [
                                            userModel.profile_pic != ""
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius:
                                                        ScreenUtil().setSp(20),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        ScreenUtil().setSp(25),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl: userModel
                                                            .profile_pic,

                                                        // Image.network(
                                                        placeholder:
                                                            (context, url) =>
                                                                Image.asset(
                                                          "assets/images/profile_holder.png",
                                                          width:
                                                              double.infinity,
                                                          height: ScreenUtil()
                                                              .setSp(125),
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          "assets/images/profile_holder.png",
                                                          width:
                                                              double.infinity,
                                                          height: ScreenUtil()
                                                              .setSp(125),
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                        height: ScreenUtil()
                                                            .setSp(70),
                                                        width: ScreenUtil()
                                                            .setSp(70),
                                                        fit: BoxFit.cover,
                                                        //   )
                                                      ),
                                                    ))
                                                : CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius:
                                                        ScreenUtil().setSp(20),
                                                    child: Text(
                                                      userModel.user_name[0]
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize:
                                                            ScreenUtil().setSp(
                                                          20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: ScreenUtil().setSp(20),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userModel.user_name,
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(15),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height:
                                                      ScreenUtil().setSp(4.5),
                                                ),
                                                userModel.bio.isNotEmpty
                                                    ? Text(
                                                        userModel.bio,
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(12.5),
                                                          color:
                                                              Colors.grey[300],
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }
                          return Container();
                        },
                      );
                    });
              }
            }
            return Center(
              child: Lottie.asset(
                "assets/animations/message_send.json",
                height: ScreenUtil().setSp(350),
                width: ScreenUtil().setSp(350),
              ),
            );
          },
        ),
      ),
    );
  }
}
