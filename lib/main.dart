import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:myapp/db/db_helper.dart';
import 'package:myapp/screens/splash_screen/splash_screen.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox<int>(DatabaseHelper.authenticationDB);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (child) {
        return GetMaterialApp(
          title: "Fmc Cart",
          builder: (context, widget) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!);
          },
          home: const SplashScreen(),
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
