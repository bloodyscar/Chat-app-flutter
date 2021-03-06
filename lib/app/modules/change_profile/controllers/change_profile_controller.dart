import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChangeProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;

  final count = 0.obs;
  @override
  void onInit() {
    emailC = TextEditingController();
    nameC = TextEditingController();
    statusC = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
