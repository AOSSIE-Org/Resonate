import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

class VersionCheckResult {
  final bool versionValid;
  final String upgradeMessage;

  VersionCheckResult(this.versionValid, this.upgradeMessage);
}

class VersionCheckController extends GetxController {
  late Future<bool> versionCheck;
  String appUpgradeMsg =
      "Hey! You should update our app because we've fixed some bugs and made some improvements. Plus, it's always good to have the latest and greatest features.";

  // Minimum app version check function:
  Future<VersionCheckResult> minimumVersionCheck() async {
    // Fetching current app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;

    // Fetching the minimum App Version
    String minimumAppVersion = "0.9";

    // print('Current version is: ${appVersion} and minimum Version is ${minimumAppVersion}');

    // Comparing the prefix with different lengths
    Version currentVersion = Version.parse(appVersion);
    Version minVersion = Version.parse(minimumAppVersion);

    bool versionValidation = currentVersion > minVersion;
    versionCheck = Future.value(versionValidation);

    // print('Version answer is : ${versionValidation}');

    return VersionCheckResult(versionValidation, appUpgradeMsg);
  }
}
