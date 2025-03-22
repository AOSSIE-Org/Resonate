import 'package:get/get.dart';

class ConnectionController extends GetxController {
    var isConnected = false.obs;
    var connectionAttempts = 0.obs;

    void resetAttempts() {
        connectionAttempts.value = 0;
    }
} 