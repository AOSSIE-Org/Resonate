import 'package:appwrite/appwrite.dart';
import 'package:resonate/utils/constants.dart';

class AppwriteService {
  static Client? _client;
  static Account? _account;
  static TablesDB? _tables;
  static Storage? _storage;
  static Realtime? _realtime;
  static Functions? _functions;

  // Instantiates a new AppWrite Client if it doesn't exist
  static Client getClient() {
    _client ??= Client()
        .setEndpoint(appwriteEndpoint)
        .setProject(appwriteProjectId)
        .setSelfSigned(
          status: true,
        ); // For self signed certificates, only use for development
    return _client!;
  }

  static Account getAccount() {
    _account ??= Account(_client!);
    return _account!;
  }

  // Instantiates a new Databases Instance if it doesn't exist

  // Instantiates a new TablesDB Instance if it doesn't exist
  static TablesDB getTables() {
    _tables ??= TablesDB(getClient());
    return _tables!;
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

  static Functions getFunctions() {
    _functions ??= Functions(getClient());
    return _functions!;
  }
}
