import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/connection_controller.dart';

class ConnectionStatusWidget extends StatelessWidget {
    final ConnectionController connectionController = Get.find<ConnectionController>();

    @override
    Widget build(BuildContext context) {
        return Obx(() {
            if (connectionController.isConnected.value) {
                return Text("Connected");
            } else {
                return Text("Attempting to reconnect... (${connectionController.connectionAttempts.value})");
            }
        });
    }
} 