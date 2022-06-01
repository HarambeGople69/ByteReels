import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:myapp/controllers/dashboard_controller.dart';
import 'package:myapp/controllers/processing_controller.dart';
import 'package:myapp/controllers/send_message_controller.dart';
import 'package:myapp/controllers/video_controller.dart';

import '../controllers/download_indicator.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(
      () => ProcessingController(),
    );
    Get.lazyPut(
      () => DashboardController(),
    );
    Get.lazyPut(
      () => VideoController(),
    );
    Get.lazyPut(
      () => DownloadController(),
    );
    Get.lazyPut(
      () => MessageSendController(),
    );
  }
}
