import 'package:resonate/utils/constants.dart';

// Converts the response from the createPairChat API into the parameters needed to join a LiveKit room.
// Temporary, when the full livekit cluster is migrated, it'll be added to core
({String liveKitUri, String roomToken}) liveKitJoinFromResponse(
  Map<String, dynamic> response,
) {
  final socketUrl = response['livekit_socket_url'] as String;
  return (
    liveKitUri: socketUrl == 'wss://host.docker.internal:7880'
        ? localhostLivekitEndpoint
        : socketUrl,
    roomToken: response['access_token'] as String,
  );
}
