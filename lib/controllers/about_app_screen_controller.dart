import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAppScreenController extends GetxController {


  Rx<String> appVersion = "0.0.0".obs;
  Rx<String> appBuildNumber = "1".obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appVersion.value = packageInfo.version;
    appBuildNumber.value = packageInfo.buildNumber;
  }
}