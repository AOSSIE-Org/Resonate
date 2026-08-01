import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/live_audio/data/livekit_join.dart';
import 'package:resonate/utils/constants.dart';

void main() {
  group('liveKitJoinFromResponse', () {
    test('rewrites the docker-internal socket URL to the local endpoint', () {
      final result = liveKitJoinFromResponse({
        'access_token': 'token-1',
        'livekit_socket_url': 'wss://host.docker.internal:7880',
      });

      expect(result.liveKitUri, localhostLivekitEndpoint);
      expect(result.roomToken, 'token-1');
    });

    test('passes other socket URLs through unchanged', () {
      final result = liveKitJoinFromResponse({
        'access_token': 'token-2',
        'livekit_socket_url': 'wss://livekit.example.com:443',
      });

      expect(result.liveKitUri, 'wss://livekit.example.com:443');
      expect(result.roomToken, 'token-2');
    });
  });
}
