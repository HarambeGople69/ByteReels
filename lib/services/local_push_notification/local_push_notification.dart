import 'dart:convert';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    print("=================");
    print("Inisde Local Notification Service");
    print("=================");
    // final InitializationSettings initializationSettings =
    //     InitializationSettings(
    //         android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    // _flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    //   onSelectNotification: (payload) {
    //     print("object");
    //   },
    // );
    AwesomeNotifications().initialize(
      "",
      [
        NotificationChannel(
            channelKey: "Basic_channel",
            channelName: "Basic notification",
            channelDescription: "Channel Desc1",
            ledColor: Colors.amber,
            enableLights: true,
            enableVibration: true,
            soundSource: "resource://raw/notification_sound",
            playSound: true,
            importance: NotificationImportance.High,
            channelShowBadge: true),
      ],
    );
  }

  static void display(RemoteMessage message) async {
    try {
      print("In Notification method");
      print("=============");
      print(message.data);
      print("=============");
      // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
      Random random = new Random();
      int id = random.nextInt(1000);

      try {
        print("Utsav Shrestha Utkrisa Shrestha");

        // if (message.data["senderImage"] == "") {
        //   print("Emptyyyyyyyyyyy");
        try {
          await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: id,
              channelKey: "Basic_channel",
              title: message.data["title"],
              body: message.data['body'],
              // icon: message.data["senderImage"],

              bigPicture: message.data["imageUrl"],
              largeIcon: message.data["senderImage"],
              notificationLayout: NotificationLayout.BigPicture,
            ),
          );
        } catch (e) {
          print("=============");
          print(e);
          print("=============");
        }
        // } else {
        //   print("Not empty Emptyyyyyyyyyyy");

        //   try {
        //     await AwesomeNotifications().createNotification(
        //       content: NotificationContent(
        //         id: id,
        //         channelKey: "Basic_channel",
        //         title: message.data["title"],
        //         body: message.data['body'],
        //         // icon: message.data["senderImage"],

        //         bigPicture: message.data["imageUrl"],
        //         largeIcon: message.data["senderImage"],
        //         notificationLayout: NotificationLayout.BigPicture,
        //       ),
        //     );
        //   } catch (e) {
        //     print("=============");
        //     print(e);
        //     print("=============");
        //   }
        // }
        // print("ABCDEF");
        // print(message.data);
        // print("ABCDEF");
        // } else {
        //   print("++++++++++");
        //   print("++++++++++");
        //   print("++++++++++");
        //   print("++++++++++");
        //   print("++++++++++");
        // }
      } catch (e) {
        print("===========");
      }
      // AwesomeNotifications().actionStream.listen((event) {
      //   print("==================");
      //   print("==================");
      //   print("==================");
      //   print(event);
      //   print("==================");
      //   print("==================");
      //   print("==================");
      // });
    } on Exception catch (e) {
      print('Error>>>$e');
    }
  }

  sendNotification(String title, String body, String senderImage,
      String imageUrl, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'title': title,
      'body': body,
      "senderImage": senderImage,
      // ??
      // "https://firebasestorage.googleapis.com/v0/b/bytereels-2ee4d.appspot.com/o/profile_holder.png?alt=media&token=170d398a-10b4-4fbb-a27f-c70d58b4e1b0",
      "imageUrl": imageUrl,
    };
    print("=================");
    print(token);
    print("=================");

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAdBvf8eQ:APA91bGl4xIs4U8IP4Tb-yoPd4AV9jcsNckmXvDDwxRz5j4YTUBnsmEg0Rqn3Oxp3YWWlijyrl6N7kqn4gpeHt89wbx1KPw6AG9pzguMKltmR9pgqozYC6rJbCNddlH5hlmDG2_U30BC'
              },
              body: jsonEncode(<String, dynamic>{
                // 'notification': <String, dynamic>{
                //   'title': title,
                //   'body': body,
                // },
                'priority': 'high',
                'data': data,
                'to': '$token'
              }));

      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
        print(response.body);
      } else {
        print("Error");
      }
    } catch (e) {
      print("=======");
      print(e.toString());
      print("=======");
    }
  }
}
