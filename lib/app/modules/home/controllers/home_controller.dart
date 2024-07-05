import 'package:get/get.dart';
import 'package:umeng_push_sdk/umeng_push_sdk.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/umeng_helper.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';

class HomeController extends GetxController {
  // hold data coming from api
  int counter = 0;

  Future<void> incrementCounter() async {
    UmengHelper.agree().then((value) => UmengHelper.registerPush());
    String? deviceToken = await UmengPushSdk.getRegisteredId();
    print(deviceToken);
      counter++;
      update();
  }

  @override
  void onInit() {
    UmengHelper.isAgreed().then((value) => {
      if (value!) {UmengHelper.registerPush()}
    });
    super.onInit();
  }
}
