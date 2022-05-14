import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/db/db_helper.dart';
import 'package:myapp/services/authentication_services/authentication_services.dart';
import 'package:myapp/widgets/our_elevated_button.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: OurElevatedButton(
              title: "LogOut",
              function: () {
                AuthenticationService().logout();
              })),
    );
  }
}
