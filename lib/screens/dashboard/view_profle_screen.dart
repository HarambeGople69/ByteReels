import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/video_model.dart';
import 'package:myapp/utils/colors.dart';
import 'package:myapp/widgets/our_sized_box.dart';

import '../../models/user_model.dart';
import '../../widgets/our_elevated_button.dart';
import '../../widgets/our_post_tile.dart';
import '../../widgets/our_profile_detail_number_column.dart';

class ViewProfileScreen extends StatefulWidget {
  final String uid;
  const ViewProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("uid", isEqualTo: widget.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.length > 0) {
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            UserModel userModel =
                                UserModel.fromMap(snapshot.data!.docs[index]);
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: userModel.profile_pic != ""
                                          ? CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: ScreenUtil().setSp(35),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  ScreenUtil().setSp(35),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      userModel.profile_pic,

                                                  // Image.network(
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                    "assets/images/profile_holder.png",
                                                    width: double.infinity,
                                                    height:
                                                        ScreenUtil().setSp(125),
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    "assets/images/profile_holder.png",
                                                    width: double.infinity,
                                                    height:
                                                        ScreenUtil().setSp(125),
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                  height:
                                                      ScreenUtil().setSp(70),
                                                  width: ScreenUtil().setSp(70),
                                                  fit: BoxFit.cover,
                                                  //   )
                                                ),
                                              ))
                                          : CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: ScreenUtil().setSp(35),
                                              child: Text(
                                                userModel.user_name[0]
                                                    .toUpperCase(),
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
                                                number:
                                                    userModel.post.toString(),
                                              ),
                                              OurProfileDetailNumberColumn(
                                                title: "Followers",
                                                number: userModel.follower
                                                    .toString(),
                                              ),
                                              OurProfileDetailNumberColumn(
                                                title: "Followers",
                                                number: userModel.following
                                                    .toString(),
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
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Videos")
                    .doc(widget.uid)
                    .collection("MyVideos")
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                // .where("uid",
                //     isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                // .snapshots(),

                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.length > 0) {
                      // return ListView.builder(
                      //     padding: EdgeInsets.zero,
                      //     itemCount: snapshot.data!.docs.length,
                      //     shrinkWrap: true,
                      //     itemBuilder: (context, index) {
                      // VideoModel videoModel = VideoModel.fromMap(
                      //     snapshot.data!.docs[index]);
                      //       return InkWell(
                      //         onTap: () {
                      //           print(videoModel.postId);
                      //           // print(videoModel.toMap());
                      //         },
                      //         child: Text("data1"),
                      //       );
                      //     });
                      return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 4 / 6,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext ctx, index) {
                            VideoModel videoModel =
                                VideoModel.fromMap(snapshot.data!.docs[index]);
                            return OurPostTile(videoModel: videoModel);
                          });
                    }
                    return Text("data2");
                  }
                  return Text("data3");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
