import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/controllers/processing_controller.dart';
import 'package:myapp/services/authentication_services/authentication_services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:myapp/apis/api_services.dart';
// import 'package:myapp/controller/authentication_controller.dart';
// import 'package:myapp/model/signup_request.dart';
import 'package:myapp/utils/colors.dart';
import 'package:myapp/widgets/our_elevated_button.dart';
import 'package:myapp/widgets/our_flutter_toast.dart';
// import 'package:myapp/widgets/our_flutter_toast.dart';
import 'package:myapp/widgets/our_password_field.dart';
import 'package:myapp/widgets/our_sized_box.dart';
import 'package:myapp/widgets/our_spinner.dart';
import 'package:myapp/widgets/our_text_field.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/check peserved name/check_reserved_name.dart';
import '../../widgets/our_shimmer_text.dart';
// import 'package:provider/provider.dart';

// import '../../provider/theme_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  TextEditingController _name_controller = TextEditingController();
  TextEditingController _phone_controller = TextEditingController();
  TextEditingController _email_controller = TextEditingController();
  TextEditingController _password_controller = TextEditingController();

  final _name_node = FocusNode();
  final _phone_node = FocusNode();
  final _email_node = FocusNode();
  final _password_node = FocusNode();
  final _username_node = FocusNode();

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
              body: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setSp(20),
                    vertical: ScreenUtil().setSp(5),
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      // Image.asset(
                      //   "assets/images/logo.png",
                      //   fit: BoxFit.fitHeight,
                      //   height: ScreenUtil().setSp(250),
                      //   width: MediaQuery.of(context).size.width,
                      // ),
                      OurSizedBox(),
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
                                    height: ScreenUtil().setSp(200),
                                    width: ScreenUtil().setSp(
                                      200,
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      ScreenUtil().setSp(25),
                                    ),
                                    child: Image.asset(
                                      "assets/images/profile_holder.png",
                                      height: ScreenUtil().setSp(200),
                                      width: ScreenUtil().setSp(
                                        200,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        // print("Button Pressed");
                                        pickImage();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: logoColor,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil().setSp(5),
                                          vertical: ScreenUtil().setSp(5),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: ScreenUtil().setSp(25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const OurSizedBox(),
                      OurShimmerText(title: "Sign Up"),
                      OurSizedBox(),
                      CustomTextField(
                        start: _name_node,
                        end: _email_node,
                        icon: Icons.person,
                        controller: _name_controller,
                        validator: (value) {},
                        title: "User name",
                        type: TextInputType.name,
                        number: 0,
                      ),
                      const OurSizedBox(),
                      CustomTextField(
                        start: _email_node,
                        end: _password_node,
                        icon: Icons.mail,
                        controller: _email_controller,
                        validator: (value) {},
                        title: "Email",
                        type: TextInputType.emailAddress,
                        number: 0,
                      ),
                      const OurSizedBox(),
                      PasswordForm(
                        start: _password_node,
                        end: _phone_node,
                        controller: _password_controller,
                        validator: (value) {},
                        title: "Password",
                        number: 0,
                      ),
                      const OurSizedBox(),
                      CustomTextField(
                        start: _phone_node,
                        icon: Icons.phone,
                        controller: _phone_controller,
                        validator: (value) {},
                        title: "Phone",
                        type: TextInputType.number,
                        number: 1,
                      ),
                      const OurSizedBox(),
                      const OurSizedBox(),
                      OurElevatedButton(
                          title: "Sign Up",
                          function: () async {
                            if (file != null) {
                              if (_name_controller.text.trim().isEmpty ||
                                  _email_controller.text.trim().isEmpty ||
                                  _password_controller.text.trim().isEmpty ||
                                  _phone_controller.text.trim().isEmpty) {
                                OurToast()
                                    .showErrorToast("Fields can't be empty");
                              } else {
                                print("object1");
                                Get.find<ProcessingController>().toggle(true);

                                // if (response == true) {
                                await AuthenticationService().signup(
                                  _name_controller.text.trim(),
                                  _email_controller.text.trim(),
                                  _password_controller.text.trim(),
                                  _phone_controller.text.trim(),
                                  context,
                                  file!,
                                );
                                // } else {
                                //   OurToast()
                                //       .showErrorToast("Username already taken");
                                // }
                                Get.find<ProcessingController>().toggle(false);
                              }
                            } else {
                              OurToast()
                                  .showErrorToast("Please pick profile image");
                            }
                          }),
                    ],
                  )),
                ),
              ),
              bottomNavigationBar: Container(
                alignment: Alignment.center,
                height: ScreenUtil().setSp(30),
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(20),
                  vertical: ScreenUtil().setSp(10),
                ),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Already have an account?  ",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(20),
                              fontWeight: FontWeight.w600,
                            )
                            // style: paratext,
                            ),
                        TextSpan(
                          text: 'Login',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                          style: TextStyle(
                            color: logoColor,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(20),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
