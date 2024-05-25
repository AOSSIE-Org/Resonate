import 'package:appwrite/appwrite.dart';
import 'package:resonate/utils/constants.dart';

class AppwriteService {
  static Client? _client;
  static Account? _account;
  static Databases? _database;
  static Storage? _storage;
  static Realtime? _realtime;

  // Instantiates a new AppWrite Client if it doesn't exist
  static Client getClient() {
    _client ??= Client()
        .setEndpoint(appwriteEndpoint)
        .setProject(appwriteProjectId)
        .setSelfSigned(
            status:
                true); // For self signed certificates, only use for development
    return _client!;
  }

  static Account getAccount() {
    _account ??= Account(_client!);
    return _account!;
  }

  // Instantiates a new Databases Instance if it doesn't exist
  static Databases getDatabases() {
    _database ??= Databases(getClient());
    return _database!;
  }

  // Instantiates a new Storage Instance if it doesn't exist
  static Storage getStorage() {
    _storage ??= Storage(getClient());
    return _storage!;
  }

  // Instantiates a new Realtime Instance if it doesn't exist
  static Realtime getRealtime() {
    _realtime ??= Realtime(getClient());
    return _realtime!;
  }
}

  // Checks the Appwrite server status
  static Future<bool> checkServerStatus() async {
    try {
      final response = await _client!.getHealth();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// Function to check server status and navigate accordingly
  static Future<void> checkServerAndNavigate(BuildContext context) async {
    bool isServerUp = await checkServerStatus();

    if (isServerUp) {
      // Server is up, you can proceed with your normal flow
    } else {
      // Server is down, navigate to a screen informing the user
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServerDownScreen()),
      );
    }
  }
}

