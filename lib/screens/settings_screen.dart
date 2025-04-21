import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
    final AuthService authService = AuthService();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text("Settings")),
            body: Center(
                child: ElevatedButton(
                    onPressed: () async {
                        await authService.logout();
                    },
                    child: Text("Logout"),
                ),
            ),
        );
    }
} 