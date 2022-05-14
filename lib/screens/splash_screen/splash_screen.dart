import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myapp/screens/authentications/login_screen.dart';
import 'package:myapp/utils/colors.dart';
import 'package:myapp/widgets/our_spinner.dart';

import '../../widgets/our_sized_box.dart';
import '../outer_layer/outer_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void completed() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OuterLayerScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), completed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.cover,
              height: ScreenUtil().setSp(250),
              width: ScreenUtil().setSp(250),
            ),
            OurSizedBox(),
            Text(
              "ByteReels",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(35),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const OurSizedBox(),
            const OurSizedBox(),
            const OurSizedBox(),
            OurSpinner()
          ],
        ),
      ),
    );
  }
}
