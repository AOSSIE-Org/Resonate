import 'package:get/get.dart';

import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:resonate/views/widgets/no_connection_dialog.dart';

class NetworkController extends GetxController {
  final InternetConnectivity _connectivity = InternetConnectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.observeInternetConnection.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(bool hasInternetAccess) async {
    if (!hasInternetAccess) {
      Get.dialog(const NoConnectionDialog(), barrierDismissible: false);
    } else {
      if (Get.isDialogOpen!) {
        Get.back();
      }
    }
  }
}
