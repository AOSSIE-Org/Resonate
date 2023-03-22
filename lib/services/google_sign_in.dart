import 'package:resonate/services/oauth_provider.dart';

class SignInWithGoogle extends AuthenticationWithSocialConnections {
  @override
  SocialConnection get connection => SocialConnection.google;
}
