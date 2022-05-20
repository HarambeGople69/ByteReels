import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/screens/dashboard/view_profle_screen.dart';
import 'package:myapp/widgets/our_sized_box.dart';
import 'package:myapp/widgets/our_spinner.dart';
import 'package:myapp/widgets/our_text_field.dart';
import 'package:page_transition/page_transition.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _search_user_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(10),
              vertical: ScreenUtil().setSp(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(
                    icon: Icons.search,
                    onchange: (value) {
                      print(value);
                      setState(() {});
                    },
                    controller: _search_user_controller,
                    validator: (value) {},
                    title: "Search",
                    type: TextInputType.name,
                    number: 1,
                    length: 1,
                  ),
                  OurSizedBox(),
                  _search_user_controller.text.trim().isNotEmpty
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .where("searchfrom",
                                  arrayContains: _search_user_controller.text
                                      .trim()
                                      .toLowerCase())
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.length > 0) {
                                // UserModel userModel  = UserModel.fromMap(map)
                                // return Text("data1");
                                return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: snapshot.data!.docs.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      UserModel userModel = UserModel.fromMap(
                                          snapshot.data!.docs[index]);
                                      return userModel.uid !=
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type: PageTransitionType
                                                        .leftToRight,
                                                    child: ViewProfileScreen(
                                                        uid: userModel.uid),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      ScreenUtil().setSp(10),
                                                  vertical:
                                                      ScreenUtil().setSp(10),
                                                ),
                                                child: Row(
                                                  // crossAxisAlignment:
                                                  //     CrossAxisAlignment.start,
                                                  children: [
                                                    userModel.profile_pic != ""
                                                        ? CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: ScreenUtil()
                                                                .setSp(25),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                ScreenUtil()
                                                                    .setSp(25),
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: userModel
                                                                    .profile_pic,

                                                                // Image.network(
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Image.asset(
                                                                  "assets/images/profile_holder.png",
                                                                  width: double
                                                                      .infinity,
                                                                  height: ScreenUtil()
                                                                      .setSp(
                                                                          125),
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  "assets/images/profile_holder.png",
                                                                  width: double
                                                                      .infinity,
                                                                  height: ScreenUtil()
                                                                      .setSp(
                                                                          125),
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                ),
                                                                height:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            70),
                                                                width:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            70),
                                                                fit: BoxFit
                                                                    .cover,
                                                                //   )
                                                              ),
                                                            ))
                                                        : CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: ScreenUtil()
                                                                .setSp(25),
                                                            child: Text(
                                                              userModel
                                                                  .user_name[0]
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                  27.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      width: ScreenUtil()
                                                          .setSp(20),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          userModel.user_name,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          15),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: ScreenUtil()
                                                              .setSp(4.5),
                                                        ),
                                                        userModel.bio.isNotEmpty
                                                            ? Text(
                                                                userModel.bio,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              12.5),
                                                                  color: Colors
                                                                          .grey[
                                                                      300],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container();
                                    });
                              }
                              return Center(
                                child: Lottie.asset(
                                  "assets/animations/search.json",
                                  height: ScreenUtil().setSp(350),
                                  width: ScreenUtil().setSp(350),
                                ),
                              );
                            }

                            return Center(
                              child: OurSpinner(),
                            );
                          },
                        )
                      : Center(
                          child: Lottie.asset(
                            "assets/animations/search.json",
                            height: ScreenUtil().setSp(350),
                            width: ScreenUtil().setSp(350),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
