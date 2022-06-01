import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/controllers/video_controller.dart';
import 'package:myapp/services/compression/compress_video.dart';
import 'package:myapp/services/firebase_storage/video_storage.dart';
import 'package:myapp/widgets/our_elevated_button.dart';
import 'package:myapp/widgets/our_sized_box.dart';
import 'package:myapp/widgets/our_text_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/dashboard_controller.dart';
import '../../controllers/processing_controller.dart';
import '../../widgets/our_spinner.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController _caption_controller = TextEditingController();
  File? file;
  late VideoPlayerController controller;
  initializeController() {
    setState(() {
      controller = VideoPlayerController.file(file!);
      controller.initialize();
      controller.play();
      controller.setVolume(1);
      controller.setLooping(true);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("This is disponse");
    try {
      controller.dispose();
    } catch (e) {
      print("============");
      print(e.toString());
      print("============");
    }
  }

  @override
  void initState() {
    super.initState();
    Get.find<VideoController>().removeFile();
  }

  pickVideo() async {
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
      var result = await _picker.pickVideo(source: ImageSource.gallery);
      ;

      if (result != null) {
        setState(() {
          file = File(result.path);
        });
        initializeController();
        print("=========================");
        print(result.path);

        print("=========================");
        Get.find<VideoController>().addFile(file!);
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("$e =========");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() => ModalProgressHUD(
            inAsyncCall: Get.find<ProcessingController>().processing.value,
            progressIndicator: OurSpinner(),
            child: Scaffold(
              body: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setSp(10),
                    vertical: ScreenUtil().setSp(10),
                  ),
                  child: Obx(
                    () => Get.find<VideoController>().videoUrl.value.isEmpty ==
                            true
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                "assets/animations/video.json",
                                height: ScreenUtil().setSp(300),
                                width: ScreenUtil().setSp(300),
                                fit: BoxFit.cover,
                              ),
                              Center(
                                child: OurElevatedButton(
                                  title: "Choose video",
                                  function: () async {
                                    pickVideo();
                                  },
                                ),
                              ),
                            ],
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.65,
                                  child: VideoPlayer(controller),
                                ),
                                OurSizedBox(),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: _caption_controller,
                                        validator: (value) {},
                                        title: "Add Caption",
                                        type: TextInputType.name,
                                        number: 1,
                                        length: 1,
                                      ),
                                      OurSizedBox(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          OurElevatedButton(
                                              title: "Remove Video",
                                              function: () {
                                                try {
                                                  controller.dispose();
                                                } catch (e) {
                                                  print("============");
                                                  print(e.toString());
                                                  print("============");
                                                }
                                                Get.find<VideoController>()
                                                    .removeFile();
                                              }),
                                          OurElevatedButton(
                                              title: "Share Video",
                                              function: () async {
                                                Get.find<ProcessingController>()
                                                    .toggle(true);
                                                await VideoStorage()
                                                    .uploadVideo(
                                                  _caption_controller.text
                                                      .trim(),
                                                  Get.find<VideoController>()
                                                      .videoUrl
                                                      .value,
                                                );
                                                controller
                                                    .dispose()
                                                    .then((value) {
                                                  Get.find<
                                                          DashboardController>()
                                                      .changeIndexs(0);
                                                  Get.find<
                                                          ProcessingController>()
                                                      .toggle(false);
                                                });
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
