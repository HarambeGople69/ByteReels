import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/video_model.dart';
import 'package:myapp/screens/dashboard/full_screen_player.dart';
import 'package:myapp/utils/colors.dart';
import 'package:myapp/widgets/our_sized_box.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

class OurPostTile extends StatefulWidget {
  final VideoModel videoModel;
  const OurPostTile({Key? key, required this.videoModel}) : super(key: key);

  @override
  State<OurPostTile> createState() => _OurPostTileState();
}

class _OurPostTileState extends State<OurPostTile> {
  late VideoPlayerController controller;
  initializeController() {
    setState(() {
      controller = VideoPlayerController.network(widget.videoModel.videoUrl);
      controller.initialize();
      controller.play();
      controller.setVolume(1);
      controller.setLooping(true);
      print("=============");
      print(controller.value);

      print("=============");
    });
  }

  bool showImage = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        print("================");
        print("Long pressed");
        setState(() {
          showImage = false;
        });
        initializeController();
        print("================");
      },
      onLongPressUp: () {
        print("================");
        print("Long pressed released");
        setState(() {
          showImage = true;
        });
        controller.dispose();
        print("================");
      },
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,
            child: FullScreenPlay(
              videoModel: widget.videoModel,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: lightlogoColor, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: showImage
                  ? Container(
                      // padding: EdgeInsets.symmetric(
                      //   horizontal: ScreenUtil().setSp(10),
                      //   vertical: ScreenUtil().setSp(10),
                      // ),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            ScreenUtil().setSp(15),
                          ),
                          topRight: Radius.circular(
                            ScreenUtil().setSp(15),
                          ),
                        ),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          // height,
                          fit: BoxFit.cover,
                          imageUrl: widget.videoModel.thumbnailUrl,
                          placeholder: (context, url) => Image.asset(
                            "assets/images/placeholder.png",
                            width: double.infinity,
                            height: ScreenUtil().setSp(125),
                            fit: BoxFit.fitWidth,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/placeholder.png",
                            width: double.infinity,
                            height: ScreenUtil().setSp(125),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    )
                  : VideoPlayer(controller),
            ),
            OurSizedBox(),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(5),
                vertical: ScreenUtil().setSp(5),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  timeago.format(
                    widget.videoModel.timestamp.toDate(),
                  ),
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12.5),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
