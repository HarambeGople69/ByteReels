import 'package:flutter/material.dart';
import 'package:myapp/services/authentication_services/authentication_services.dart';
import 'package:myapp/widgets/our_elevated_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OurElevatedButton(
          title: "Logout",
          function: () async {
            await AuthenticationService().logout();
          },
        ),
      ),
    );
  }
}
