import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/widgets/our_sized_box.dart';
import 'package:myapp/widgets/our_text_field.dart';

import '../widgets/our_password_field.dart';

class DummyPage extends StatefulWidget {
  const DummyPage({Key? key}) : super(key: key);

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  TextEditingController _name_controller = TextEditingController();
  TextEditingController _phone_controller = TextEditingController();
  TextEditingController _email_controller = TextEditingController();
  TextEditingController _password_controller = TextEditingController();
  TextEditingController _username_controller = TextEditingController();

  final _name_node = FocusNode();
  final _phone_node = FocusNode();
  final _email_node = FocusNode();
  final _password_node = FocusNode();
  final _username_node = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.fitHeight,
              height: ScreenUtil().setSp(250),
              width: MediaQuery.of(context).size.width,
            ),
            const OurSizedBox(),
            Text("Dummy Page"),
            const OurSizedBox(),
            CustomTextField(
              start: _name_node,
              end: _email_node,
              icon: Icons.person,
              controller: _name_controller,
              validator: (value) {},
              title: "Full Name",
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
              end: _username_node,
              icon: Icons.phone,
              controller: _phone_controller,
              validator: (value) {},
              title: "Phone",
              type: TextInputType.number,
              number: 0,
            ),
            const OurSizedBox(),
            CustomTextField(
              start: _username_node,
              controller: _username_controller,
              validator: (value) {},
              title: "User Name",
              type: TextInputType.text,
              number: 1,
            ),
          ],
        ),
      ),
    );
  }
}
