import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdateStatusController extends GetxController {
  late TextEditingController statusC;

  final count = 0.obs;
  @override
  void onInit() {
    statusC = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    statusC.dispose();
    super.dispose();
  }
}
