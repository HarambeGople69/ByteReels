import 'dart:convert';
import 'dart:math';
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
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        print("object");
      },
    );
    ;
  }

  static void display(RemoteMessage message) async {
    try {
      print("In Notification method");
      // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
      Random random = new Random();
      int id = random.nextInt(1000);
      final sound = "notification_sound.wav";
      // final styleInformation = BigPictureStyleInformation(bigPicture)
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "mychanel2",
        "my chanel",
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(sound.split(".").first),
        // styleInformation: styleInformation
      ));
      print("my id is ${id.toString()}");
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: "message.data['click_action']",
      );
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
      'message': "title",
      "senderImage": senderImage,
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
                'notification': <String, dynamic>{
                  'title': title,
                  'body': body,
                  'imageUrl': imageUrl
                },
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
