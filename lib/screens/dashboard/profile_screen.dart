import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/screens/dashboard/edit_screen.dart';
import 'package:myapp/services/authentication_services/authentication_services.dart';
import 'package:myapp/utils/colors.dart';
import 'package:myapp/widgets/our_elevated_button.dart';
import 'package:myapp/widgets/our_profile_detail_number_column.dart';
import 'package:myapp/widgets/our_sized_box.dart';
import 'package:page_transition/page_transition.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ByteReels",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(25),
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: logoColor,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(10),
          vertical: ScreenUtil().setSp(10),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.length > 0) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      UserModel userModel =
                          UserModel.fromMap(snapshot.data!.docs[index]);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: userModel.profile_pic != ""
                                    ? CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: ScreenUtil().setSp(35),
                                        child: CachedNetworkImage(
                                          imageUrl: userModel.profile_pic,

                                          // Image.network(
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            "assets/images/profile_holder.png",
                                          ),
                                          height: ScreenUtil().setSp(50),
                                          width: ScreenUtil().setSp(50),
                                          fit: BoxFit.cover,
                                          //   )
                                        ))
                                    : CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: ScreenUtil().setSp(35),
                                        child: Text(
                                          userModel.user_name[0],
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(
                                              30,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setSp(10),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        OurProfileDetailNumberColumn(
                                          title: "Posts",
                                          number: userModel.post.toString(),
                                        ),
                                        OurProfileDetailNumberColumn(
                                          title: "Followers",
                                          number: userModel.follower.toString(),
                                        ),
                                        OurProfileDetailNumberColumn(
                                          title: "Followers",
                                          number:
                                              userModel.following.toString(),
                                        ),
                                      ],
                                    ),
                                    OurSizedBox(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OurElevatedButton(
                                            title: "Edit",
                                            function: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .leftToRight,
                                                  child: EditScreen(
                                                    usernmae:
                                                        userModel.user_name,
                                                    bio: userModel.bio,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setSp(20),
                                        ),
                                        Expanded(
                                          child: OurElevatedButton(
                                            title: "Logout",
                                            function: () async {
                                              await AuthenticationService()
                                                  .logout();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          OurSizedBox(),
                          Text(
                            userModel.user_name,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(17.5),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          OurSizedBox(),
                          userModel.bio.isNotEmpty
                              ? Text(
                                  userModel.bio,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(13.5),
                                      fontWeight: FontWeight.w300),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Container(),
                          Divider(
                            color: logoColor,
                          ),
                          Text("data"),
                        ],
                      );
                    });
              } else {
                return Text("data2");
              }
            }
            return Text("data3");
          },
        ),
        // child: Center(
        //   child: OurElevatedButton(
        //     title: "Logout",
        //     function: () async {
        //       await AuthenticationService().logout();
        //     },
        //   ),
        // ),
      ),
    );
  }
}
