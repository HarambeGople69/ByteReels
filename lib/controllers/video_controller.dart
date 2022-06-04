import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  Rx<VideoPlayerController> videoPlayerController =
      VideoPlayerController.network("").obs;

  void initialize(String videoUrl) {
    print("Inside here");
    try {
      videoPlayerController.value = VideoPlayerController.network(videoUrl);
      videoPlayerController.value.initialize();
      videoPlayerController.value.play();
      videoPlayerController.value.setVolume(1);
      videoPlayerController.value.setLooping(true);
    } catch (e) {
      print("==============");
      print(e);
      print("==============");
    }
  }

  void dispose() {
    videoPlayerController.value.dispose();
  }

  var videoUrl = "".obs;
  void addFile(File fileValue) {
    videoUrl.value = fileValue.path;
  }

  void removeFile() {
    videoUrl.value = "";
  }
}
