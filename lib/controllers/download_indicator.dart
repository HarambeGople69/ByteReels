import 'package:get/get.dart';

class DownloadController extends GetxController {
  var progressIndicator = 0.0.obs;

  void clearIndicator() {
    progressIndicator.value = 0.0;
  }

  changeIndicator(double value) {
    // print("=============aa++++++++");
    progressIndicator.value = value;
  }
}
