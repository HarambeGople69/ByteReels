import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/utils/colors.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controllers/processing_controller.dart';
import '../../controllers/send_message_controller.dart';
import '../../models/message_model.dart';
import '../../services/cloud_storage/chat_info_detail.dart';
import '../../services/firebase_storage/chat_photo_storage.dart';
import '../../widgets/our_spinner.dart';
import '../../widgets/our_text_field.dart';

class MessageSendScreen extends StatefulWidget {
  final UserModel userModel;
  const MessageSendScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<MessageSendScreen> createState() => _MessageSendScreenState();
}

class _MessageSendScreenState extends State<MessageSendScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<MessageSendController>().toggle(true);
  }

  File? file;

  pickImage() async {
    Permission _permission = Permission.storage;
    PermissionStatus _status = await _permission.request();

    if (!_status.isGranted) {
      await Permission.location.request();
    }
    if (_status.isPermanentlyDenied) {
      AppSettings.openAppSettings();
      print("=========================");
    }

    try {
      final ImagePicker _picker = ImagePicker();
      var result = await _picker.pickImage(source: ImageSource.gallery);
      ;

      if (result != null) {
        setState(() {});
        file = File(result.path);
        await ChatImageUpload().uploadImage(widget.userModel, file!);
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("$e =========");
    }
  }

  TextEditingController _messaging_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: logoColor,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ScreenUtil().setSp(30),
                  ),
                  child: Container(
                      color: Colors.white,
                      child: widget.userModel.profile_pic != ""
                          ? CachedNetworkImage(
                              imageUrl: widget.userModel.profile_pic,

                              // Image.network(
                              placeholder: (context, url) => Image.asset(
                                "assets/images/profile_holder.png",
                              ),
                              height: ScreenUtil().setSp(40),
                              width: ScreenUtil().setSp(40),
                              fit: BoxFit.cover,
                              //   )
                            )
                          : Container()),
                ),
                SizedBox(
                  width: ScreenUtil().setSp(10),
                ),
                Text(
                  widget.userModel.user_name,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(17.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(10),
              vertical: ScreenUtil().setSp(10),
            ),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("ChatRoom")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("Chat")
                        .doc(widget.userModel.uid)
                        .collection("Messages")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length > 0) {
                          return ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              // shrinkWrap: true,
                              reverse: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                MessageModel messageModel =
                                    MessageModel.fromJson(
                                  snapshot.data!.docs[index],
                                );
                                return messageModel.type == "text"
                                    ? Row(
                                        mainAxisAlignment:
                                            messageModel.ownerId ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setSp(15),
                                              vertical: ScreenUtil().setSp(15),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setSp(5),
                                              vertical: ScreenUtil().setSp(5),
                                            ),
                                            decoration: BoxDecoration(
                                              color: logoColor.withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                ScreenUtil().setSp(20),
                                              ),
                                            ),
                                            child: Text(
                                              messageModel.message,
                                              // style: SmallText,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            messageModel.ownerId ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                ScreenUtil().setSp(30),
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setSp(5),
                                              vertical: ScreenUtil().setSp(5),
                                            ),
                                            child: CachedNetworkImage(
                                              width: 200,
                                              height: 200,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                "assets/images/placeholder.png",
                                                fit: BoxFit.cover,
                                              ),
                                              imageUrl: messageModel.message,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          )
                                        ],
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
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        await pickImage();
                        // print("Imaged Clicked");
                      },
                      child: Icon(
                        Icons.image,
                        size: ScreenUtil().setSp(
                          30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setSp(15),
                    ),
                    Expanded(
                      child: CustomTextField(
                        controller: _messaging_controller,
                        validator: (value) {},
                        title: "Send message",
                        type: TextInputType.name,
                        number: 1,
                        length: 1,
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setSp(15),
                    ),
                    InkWell(
                      onTap: () async {
                        if (_messaging_controller.text.trim().isNotEmpty) {
                          if (Get.find<MessageSendController>()
                              .sendMessage
                              .value) {
                            Get.find<MessageSendController>().toggle(false);
                            await ChatDetailFirebase().messageDetail(
                              _messaging_controller.text.trim(),
                              widget.userModel,
                            );
                            _messaging_controller.clear();
                            // Get.find<ProcessingController>().toggle(false);
                            Get.find<MessageSendController>().toggle(true);

                            print("Its not empty");
                            FocusScope.of(context).unfocus();
                          } else {}
                        } else {
                          print("Its empty");
                          FocusScope.of(context).unfocus();
                        }
                      },
                      child: Icon(
                        Icons.send,
                        size: ScreenUtil().setSp(
                          30,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
