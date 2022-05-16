import 'dart:io';
import 'package:get/get.dart';

class VideoController extends GetxController {
  var videoUrl = "".obs;
  void addFile(File fileValue) {
    videoUrl.value = fileValue.path;
  }

  void removeFile() {
    videoUrl.value = "";
  }
}
