import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:myapp/controllers/processing_controller.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(
      () => ProcessingController(),
    );
   
  }
}
