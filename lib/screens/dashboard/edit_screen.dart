import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/services/authentication_services/authentication_services.dart';
import 'package:myapp/services/cloud_storage/user_detail.dart';
import 'package:myapp/services/firebase_storage/user_info_storage.dart';
import 'package:myapp/utils/colors.dart';
import 'package:myapp/widgets/our_elevated_button.dart';
import 'package:myapp/widgets/our_flutter_toast.dart';
import 'package:myapp/widgets/our_sized_box.dart';
import 'package:myapp/widgets/our_text_field.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../controllers/processing_controller.dart';
import '../../services/check peserved name/check_reserved_name.dart';
import '../../widgets/our_spinner.dart';

class EditScreen extends StatefulWidget {
  final String usernmae;
  final String bio;
  const EditScreen({Key? key, required this.usernmae, required this.bio})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _user_name_controller = TextEditingController();
  TextEditingController _bio_controller = TextEditingController();
  bool response = true;
  FocusNode _user_name_node = FocusNode();
  FocusNode _bio_node = FocusNode();

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
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("$e =========");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(
      () {
        _user_name_controller.text = widget.usernmae;
        _bio_controller.text = widget.bio;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Obx(
          () => ModalProgressHUD(
            inAsyncCall: Get.find<ProcessingController>().processing.value,
            progressIndicator: OurSpinner(),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Edit Profile",
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
                    children: [
                      Center(
                        child: file != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  ScreenUtil().setSp(25),
                                ),
                                child: Container(
                                  color: Colors.white,
                                  child: Image.file(
                                    file!,
                                    height: ScreenUtil().setSp(150),
                                    width: ScreenUtil().setSp(
                                      150,
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  ScreenUtil().setSp(25),
                                ),
                                child: Image.asset(
                                  "assets/images/profile_holder.png",
                                  height: ScreenUtil().setSp(150),
                                  width: ScreenUtil().setSp(
                                    150,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      OurSizedBox(),
                      Center(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setSp(10),
                                vertical: ScreenUtil().setSp(5),
                              ),
                            ),
                          ),
                          onPressed: () {
                            pickImage();
                          },
                          child: Text(
                            "Upload profile image",
                            style: TextStyle(
                              color: logoColor,
                              fontSize: ScreenUtil().setSp(15),
                            ),
                            // style: MediumText,
                          ),
                        ),
                      ),
                      OurSizedBox(),
                      CustomTextField(
                        length: 1,
                        controller: _user_name_controller,
                        validator: (value) {},
                        title: "User name",
                        type: TextInputType.name,
                        number: 0,
                        start: _user_name_node,
                        end: _bio_node,
                      ),
                      OurSizedBox(),
                      CustomTextField(
                        length: 1,
                        controller: _bio_controller,
                        validator: (value) {},
                        title: "About me",
                        type: TextInputType.name,
                        number: 1,
                        start: _bio_node,
                      ),
                      OurSizedBox(),
                      OurElevatedButton(
                        title: "Update",
                        function: () async {
                          if (_user_name_controller.text.trim().isNotEmpty) {
                            Get.find<ProcessingController>().toggle(true);
                            if (widget.usernmae !=
                                _user_name_controller.text.trim()) {
                              response = await CheckReservedName()
                                  .checkThisUserAlreadyPresentOrNot(
                                _user_name_controller.text.trim(),
                                context,
                              );
                            }
                            if (response == true) {
                              await UserProfileUpload().uploadProfile(
                                _user_name_controller.text.trim(),
                                _bio_controller.text.trim(),
                                file,
                              );
                              Get.find<ProcessingController>().toggle(false);

                              Navigator.pop(context);
                            } else {
                              OurToast()
                                  .showErrorToast("User name already taken");
                              Get.find<ProcessingController>().toggle(false);
                            }
                            Get.find<ProcessingController>().toggle(false);
                          } else {
                            OurToast()
                                .showErrorToast("User name can't be empty");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
