import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/controllers/dashboard_controller.dart';
import 'package:myapp/db/db_helper.dart';
import 'package:myapp/screens/dashboard/add_screen.dart';
import 'package:myapp/screens/dashboard/home_screen.dart';
import 'package:myapp/screens/dashboard/messages_screen.dart';
import 'package:myapp/screens/dashboard/profile_screen.dart';
import 'package:myapp/screens/dashboard/search_screen.dart';
import 'package:myapp/services/authentication_services/authentication_services.dart';
import 'package:myapp/services/local_push_notification/local_push_notification.dart';
import 'package:myapp/utils/colors.dart';
import 'package:myapp/widgets/our_elevated_button.dart';

import '../../controllers/video_controller.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  EdgeInsets padding = const EdgeInsets.all(12);

  List<Widget> widgets = [
    HomeScreen(),
    SearchScreen(),
    AddScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((event) {
      print("Hello");
      print(FirebaseMessaging.onMessage.isBroadcast);
      print("Hello");
      print("object 2");
      print(event.data);

      // if (event.data != null) {
      //   print("Hello world");
      LocalNotificationService.display(event);
      // }
    });
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event.data);
      LocalNotificationService.display(event);
    });
    // storeNotificationToken();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        extendBody: true,
        body: widgets[Get.find<DashboardController>().indexs.value],
        bottomNavigationBar: SnakeNavigationBar.color(
          height: ScreenUtil().setSp(50),
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.circle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(20),
            vertical: ScreenUtil().setSp(10),
          ),
          snakeViewColor: logoColor,
          selectedItemColor: logoColor,
          unselectedItemColor: Colors.blueGrey,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          currentIndex: Get.find<DashboardController>().indexs.value,
          onTap: (index) {
            Get.find<DashboardController>().changeIndexs(index);
            Get.find<VideoController>().dispose();
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: ScreenUtil().setSp(22.5),
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: ScreenUtil().setSp(22.5),
                ),
                label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: ScreenUtil().setSp(22.5),
                ),
                label: 'Add'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                  size: ScreenUtil().setSp(22.5),
                ),
                label: 'Messages'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: ScreenUtil().setSp(22.5),
                ),
                label: 'Profile')
          ],
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
