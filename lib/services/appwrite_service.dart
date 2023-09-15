import 'package:appwrite/appwrite.dart';
import 'package:resonate/utils/constants.dart';

class AppwriteService {
  static Client? _client;

  // Instantiates a new AppWrite Client if it doesn't exist
  static Client getClient() {
    _client ??= Client()
        .setEndpoint(appwriteEndpoint)
        .setProject(appwriteProjectId)
        .setSelfSigned(
          status: true
        ); // For self signed certificates, only use for development
    return _client!;
  }
}