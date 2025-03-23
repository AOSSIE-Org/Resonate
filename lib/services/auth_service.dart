import 'package:get/get.dart';

class AuthService {
    // Other methods...

    Future<void> logout() async {
        // Clear user session data
        await clearSession();
        // Redirect to login screen
        Get.offAllNamed('/login'); // Adjust the route as necessary
    }

    Future<void> clearSession() async {
        // Implement session clearing logic here
    }
} 