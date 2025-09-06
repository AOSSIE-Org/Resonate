import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAppScreenController extends GetxController {
  final Rx<String> appVersion = "0.0.0".obs;
  final Rx<String> appBuildNumber = "1".obs;
  final Rx<bool> updateAvailable = false.obs;

  final showFullDescription = false.obs;

  final String fullDescription = """
Resonate is a revolutionary voice-based social media platform where every voice matters. 
Join real-time audio conversations, participate in diverse discussions, and connect with 
like-minded individuals. Our platform offers:
- Live audio rooms with topic-based discussions
- Seamless social networking through voice
- Community-driven content moderation
- Cross-platform compatibility
- End-to-end encrypted private conversations

Developed by the AOSSIE open source community, we prioritize user privacy and 
community-driven development. Join us in shaping the future of social audio!""";

  @override
  void onInit() {
    super.onInit();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
      appBuildNumber.value = packageInfo.buildNumber;
    } catch (e) {
      Get.snackbar("Error", "Could not load package info");
    }
  }

  void toggleDescription() {
    showFullDescription.toggle();
  }

  Future<void> checkForUpdate() async {
    // Implement actual update check logic
    updateAvailable.value = await _fakeUpdateCheck();
    if (updateAvailable.value) {
      Get.snackbar("Update Available", "A new version is available!");
    } else {
      Get.snackbar("Up to Date", "You're using the latest version");
    }
  }

  Future<bool> _fakeUpdateCheck() async {
    await Future.delayed(const Duration(seconds: 1));
    return false;
  }
}
