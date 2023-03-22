import 'package:auth0_flutter/auth0_flutter.dart';

abstract class AuthenticationService<T> {
  Auth0 auth0 = Auth0(
    'dev-uhrj8p25nrczp3v8.au.auth0.com', //auth0 domain
    'PhfdcIa8YRgVQ5bV2PUZPjYOwDaSS0p7', //client id
  );

  Future<T> signIn();

  Future<void> signOut();
}
