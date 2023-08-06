import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) async{
    if (connectivityResult == ConnectivityResult.none) {
      Get.defaultDialog(title: "No Internet", barrierDismissible: false);
    } else {
      bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (isDeviceConnected && Get.isDialogOpen!) {
        Get.back();
      }
    }
  }
}
