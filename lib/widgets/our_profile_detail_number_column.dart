import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OurProfileDetailNumberColumn extends StatelessWidget {
  final String title;
  final String number;
  const OurProfileDetailNumberColumn(
      {Key? key, required this.title, required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil().setSp(20),
            ),
          ),
          // OurSizedBox(),
          SizedBox(
            height: ScreenUtil().setSp(5),
          ),
          Text(
            number,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil().setSp(20),
            ),
          )
        ],
      ),
    );
  }
}
