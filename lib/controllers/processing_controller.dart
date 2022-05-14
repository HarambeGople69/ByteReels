import 'package:get/get.dart';

class ProcessingController extends GetxController {
  var processing = false.obs;
  void toggle(bool value) {
    processing.value = value;
  }
}
