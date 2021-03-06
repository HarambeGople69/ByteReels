import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/controllers/download_indicator.dart';
import 'package:myapp/controllers/video_controller.dart';
import 'package:myapp/models/comment_model.dart';
import 'package:myapp/models/video_model.dart';
import 'package:myapp/services/cloud_storage/comment_detail.dart';
import 'package:myapp/services/cloud_storage/video_detail.dart';
import 'package:myapp/services/cloud_storage/like_unlike_feature.dart';
import 'package:myapp/services/local_push_notification/local_push_notification.dart';
import 'package:myapp/utils/colors.dart';
import 'package:myapp/widgets/our_animated_profile.dart';
import 'package:myapp/widgets/our_flutter_toast.dart';
import 'package:myapp/widgets/our_spinner.dart';
import 'package:myapp/widgets/our_text_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../controllers/processing_controller.dart';
import '../../models/user_model.dart';
import '../../widgets/our_sized_box.dart';

class FullScreenPlay extends StatefulWidget {
  final bool addback;
  final VideoModel videoModel;
  const FullScreenPlay(
      {Key? key, required this.videoModel, required this.addback})
      : super(key: key);

  @override
  State<FullScreenPlay> createState() => _FullScreenPlayState();
}

class _FullScreenPlayState extends State<FullScreenPlay> {
  // late VideoPlayerController controller;
  bool isLiked = false;
  bool isHeartAnimating = false;
  String progress = "";
  bool canComment = true;
  initializeController() {
    Get.find<VideoController>().initialize(widget.videoModel.videoUrl);
    // setState(() {
    //   controller = VideoPlayerController.network(widget.videoModel.videoUrl);
    //   controller.initialize();
    //   controller.play();
    //   controller.setVolume(1);
    //   controller.setLooping(false);
    //   // print("=============");
    //   // print(controller.value);
    //   // print("=============");
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeController();
    Get.find<DownloadController>().clearIndicator();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose");
    Get.find<VideoController>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: () async {
            print("object");
            Get.find<VideoController>().dispose();
            Navigator.pop(context);
            return false;
          },
          child: Scaffold(
            body: ModalProgressHUD(
              inAsyncCall: Get.find<ProcessingController>().processing.value,
              progressIndicator: SizedBox(
                height: ScreenUtil().setSp(125),
                width: ScreenUtil().setSp(125),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: Get.find<DownloadController>()
                          .progressIndicator
                          .value,
                      strokeWidth: 7,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation(logoColor),
                    ),
                    Center(
                      child: Text(
                        "${(Get.find<DownloadController>().progressIndicator * 100).floor()} %",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(22.5),
                          color: logoColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: SafeArea(
                child: InkWell(
                  onDoubleTap: () async {
                    DocumentSnapshot aa = await FirebaseFirestore.instance
                        .collection("Videos")
                        .doc(widget.videoModel.ownerId)
                        .collection("MyVideos")
                        .doc(widget.videoModel.postId)
                        .get();
                    print(aa);

                    VideoModel videoModel = VideoModel.fromMap(aa);
                    print(videoModel);
                    await LikeUnlikeFeature().likeunlike(videoModel);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: OurSpinner(),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: VideoPlayer(Get.find<VideoController>()
                            .videoPlayerController
                            .value),
                      ),
                      widget.addback == true
                          ? InkWell(
                              onTap: () {
                                Get.find<VideoController>().dispose();
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setSp(5),
                                  vertical: ScreenUtil().setSp(5),
                                ),
                                height: ScreenUtil().setSp(40),
                                width: ScreenUtil().setSp(40),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: ScreenUtil().setSp(25),
                                ),
                              ),
                            )
                          : Container(),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(10),
                            vertical: ScreenUtil().setSp(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(20),
                            vertical: ScreenUtil().setSp(20),
                          ),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Users")
                                .where("uid",
                                    isEqualTo: widget.videoModel.ownerId)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.docs.length > 0) {
                                  UserModel userModel =
                                      UserModel.fromMap(snapshot.data!.docs[0]);
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userModel.user_name,
                                            style: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(14.5),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setSp(3.5),
                                          ),
                                          Text(
                                            widget.videoModel.caption,
                                            style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize:
                                                  ScreenUtil().setSp(14.5),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      CircularAnimation(
                                        child: userModel.profile_pic != ""
                                            ? CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: ScreenUtil().setSp(25),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    ScreenUtil().setSp(30),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        userModel.profile_pic,

                                                    // Image.network(
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      "assets/images/profile_holder.png",
                                                      width: double.infinity,
                                                      height: ScreenUtil()
                                                          .setSp(125),
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      "assets/images/profile_holder.png",
                                                      width: double.infinity,
                                                      height: ScreenUtil()
                                                          .setSp(125),
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                    height:
                                                        ScreenUtil().setSp(70),
                                                    width:
                                                        ScreenUtil().setSp(70),
                                                    fit: BoxFit.cover,
                                                    //   )
                                                  ),
                                                ))
                                            : CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: ScreenUtil().setSp(25),
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
                                      ),
                                    ],
                                  );
                                }
                                return Text("data");
                              }
                              return Text("data");
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: MediaQuery.of(context).size.height * 0.25,
                        child: Container(
                          // color: Colors.amber,
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(10),
                            vertical: ScreenUtil().setSp(10),
                          ),
                          height: MediaQuery.of(context).size.height * 0.5,
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setSp(15),
                          ),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Videos")
                                .doc(widget.videoModel.ownerId)
                                .collection("MyVideos")
                                .doc(widget.videoModel.postId)
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                VideoModel videoModel =
                                    VideoModel.fromMap(snapshot.data!);
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onLongPress: () {
                                        likeBottomSheet(
                                            context, videoModel.likes);
                                        // print(videoModel.likes);
                                      },
                                      onTap: () async {
                                        // LocalNotificationService().sendNotification(
                                        //     "title",
                                        //     "fRij4v_RQJyy71MswUyxOQ:APA91bFYFLZfGQJBwq5QGvkobeTwNvsdiTRz-053gB8JtZTxixpbZWpPTnhi_VJmNPhR9XVdt1euDmsdP1HAYBjnSZhfOrB39n9mft3Gez6k9aIYAZmP3sptVHzz1Psw_HsFIKItV-aS");
                                        await LikeUnlikeFeature()
                                            .likeunlike(videoModel);
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            videoModel.likes.contains(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.red,
                                            size: ScreenUtil().setSp(35),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setSp(5),
                                          ),
                                          Text(
                                            videoModel.likeNumber.toString(),
                                            style: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(17.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        commentBottomSheet(context, videoModel);
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.comment,
                                            color: Colors.blueAccent,
                                            size: ScreenUtil().setSp(30),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setSp(5),
                                          ),
                                          Text(
                                            videoModel.commentNumber.toString(),
                                            style: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(17.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print("Download pressed");
                                        downloadFile(videoModel.videoUrl,
                                            videoModel, context);
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.download,
                                            color: Colors.amber,
                                            size: ScreenUtil().setSp(30),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setSp(5),
                                          ),
                                          Text(
                                            videoModel.downloadNumber
                                                .toString(),
                                            style: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(17.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Text('asasa');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void likeBottomSheet(BuildContext context, List likesUid) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(10),
            vertical: ScreenUtil().setSp(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Likes',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(20),
                    color: logoColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Divider(),
              // Column(
              //   children: likesUid.map((e) => Text(e)).toList(),
              // )
              Expanded(
                child: likesUid.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: likesUid.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Users")
                                .doc(likesUid[index])
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                UserModel userModel =
                                    UserModel.fromMap(snapshot.data);
                                return Container(
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
                                              backgroundColor: Colors.white,
                                              radius: ScreenUtil().setSp(20),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  ScreenUtil().setSp(25),
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
                                              radius: ScreenUtil().setSp(20),
                                              child: Text(
                                                userModel.user_name[0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: ScreenUtil().setSp(
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
                                                fontSize:
                                                    ScreenUtil().setSp(15),
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setSp(4.5),
                                          ),
                                          userModel.bio.isNotEmpty
                                              ? Text(
                                                  userModel.bio,
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(12.5),
                                                    color: Colors.grey[300],
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Center(
                                child: OurSpinner(),
                              );
                            },
                          );
                        })
                    : Center(
                        child: Text(
                          "No likes",
                          style: TextStyle(
                            color: logoColor,
                            fontSize: ScreenUtil().setSp(20),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void commentBottomSheet(context, VideoModel videoModel) {
    TextEditingController _comment_text_controller = TextEditingController();
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(10),
                vertical: ScreenUtil().setSp(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        color: logoColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Videos")
                          .doc(videoModel.ownerId)
                          .collection("MyVideos")
                          .doc(videoModel.postId)
                          .collection("Comments")
                          .orderBy("timestamp", descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.length > 0) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                // physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  CommentModel commentModel =
                                      CommentModel.fromMap(
                                          snapshot.data!.docs[index]);
                                  return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(commentModel.ownerId)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        UserModel userModel =
                                            UserModel.fromMap(snapshot.data);
                                        return InkWell(
                                          onLongPress: () async {
                                            if (commentModel.ownerId ==
                                                FirebaseAuth.instance
                                                    .currentUser!.uid) {
                                              await FirebaseFirestore.instance
                                                  .collection("Videos")
                                                  .doc(videoModel.ownerId)
                                                  .collection("MyVideos")
                                                  .doc(videoModel.postId)
                                                  .collection("Comments")
                                                  .doc(commentModel.commentId)
                                                  .delete()
                                                  .then((value) async {
                                                OurToast().showSuccessToast(
                                                    "Comment deleted");

                                                await FirebaseFirestore.instance
                                                    .collection("Videos")
                                                    .doc(videoModel.ownerId)
                                                    .collection("MyVideos")
                                                    .doc(videoModel.postId)
                                                    .update({
                                                  "commentNumber":
                                                      videoModel.commentNumber -
                                                          1,
                                                });
                                              });
                                            } else {
                                              print("You can't delete it");
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setSp(10),
                                              vertical: ScreenUtil().setSp(10),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                userModel.profile_pic != ""
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: ScreenUtil()
                                                            .setSp(20),
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
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              "assets/images/profile_holder.png",
                                                              width: double
                                                                  .infinity,
                                                              height:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          125),
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              "assets/images/profile_holder.png",
                                                              width: double
                                                                  .infinity,
                                                              height:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          125),
                                                              fit: BoxFit
                                                                  .fitWidth,
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
                                                        radius: ScreenUtil()
                                                            .setSp(20),
                                                        child: Text(
                                                          userModel.user_name[0]
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                              20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: ScreenUtil().setSp(20),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        userModel.user_name,
                                                        style: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(15),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        height: ScreenUtil()
                                                            .setSp(2.5),
                                                      ),
                                                      Text(
                                                        commentModel.comment,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  timeago.format(
                                                    commentModel.timestamp
                                                        .toDate(),
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(12.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  );
                                });
                          }
                          return Center(
                            child: Text(
                              "No Comments",
                              style: TextStyle(
                                color: logoColor,
                                fontSize: ScreenUtil().setSp(20),
                              ),
                            ),
                          );
                        }
                        return Center(
                          child: OurSpinner(),
                        );
                      },
                    ),
                  ),
                  OurSizedBox(),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _comment_text_controller,
                          validator: (value) {},
                          title: "Add comment",
                          type: TextInputType.name,
                          number: 1,
                          length: 1,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (canComment == true) {
                            setState(() {
                              canComment = false;
                            });
                            if (_comment_text_controller.text.trim().isEmpty) {
                              print("Empty");
                              FocusManager.instance.primaryFocus?.unfocus();
                            } else {
                              await CommentDetailFirebase().uploadComment(
                                  _comment_text_controller.text.trim(),
                                  videoModel);
                              setState(() {
                                _comment_text_controller.text = "";
                              });
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                            setState(() {
                              canComment = true;
                            });
                          } else {
                            print("===================");
                            print("Can't comment");
                            print("===================");
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: logoColor,
                          size: ScreenUtil().setSp(
                            27.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  downloadFile(
      String downloadUrl, VideoModel videoModel, BuildContext contextt) async {
    Get.find<DownloadController>().clearIndicator();
    Get.find<ProcessingController>().toggle(true);
    print("==================");
    print(downloadUrl);
    print("Download in progress");
    print("==================");
    try {
      final url = downloadUrl;
      final tempdir = await getTemporaryDirectory();
      final path = "${tempdir.path}/${downloadUrl}";
      await Dio().download(url, path,
          onReceiveProgress: (actualByle, totalbytes) {
        double percentage = actualByle / totalbytes * 100;
        setState(() {
          progress = "Downloading ... ${percentage.floor()}";
        });
        print(progress);
        Get.find<DownloadController>().changeIndicator(percentage / 100);
      });

      // final dir = await getApplicationDocumentsDirectory();
      // final file = File("${dir.path}/${ref.name}");
      // await ref.writeToFile(file);

      if (url.contains(".mp4")) {
        await GallerySaver.saveVideo(
          path,
          albumName: "ByteReels",
        ).then((value) {
          VideoDetailStorage().increaseDownloadCount(videoModel);
          ;
          print("======================== DONEEE ==========================");
        });
      }
      Get.find<ProcessingController>().toggle(false);
    } catch (e) {
      Get.find<ProcessingController>().toggle(false);

      OurToast().showErrorToast(
        "Something went wrong",
      );
    }
  }
}
