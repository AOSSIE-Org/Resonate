import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/appwrite_upcoming_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/data/room_chat.dart';
import 'package:resonate/features/rooms/model/reply_to.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/features/rooms/model/user_report_model.dart';
import 'package:resonate/features/rooms/viewmodel/create_room_notifier.dart';
import 'package:resonate/features/rooms/viewmodel/room_chat_notifier.dart';
import 'package:resonate/features/rooms/data/live_rooms.dart';
import 'package:resonate/features/rooms/data/services/room_launcher.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/features/rooms/data/upcoming_rooms.dart';

import '../../helpers/test_root_container.dart';

export '../../helpers/pump_widget.dart';
export '../../helpers/test_root_container.dart';

class FakeRoomSession extends RoomSession {
  FakeRoomSession(
    this._state, {
    this.throwOnError = false,
    this.reportFails = false,
  });
  final SingleRoomState? _state;
  final bool throwOnError;
  final bool reportFails;
  ReportDraft? lastReportDraft;

  int turnOnMicCount = 0;
  int turnOffMicCount = 0;
  int raiseHandCount = 0;
  int unRaiseHandCount = 0;
  int setRoleCount = 0;
  int kickOutCount = 0;
  int reportAndKickCount = 0;
  int leaveRoomCount = 0;
  int deleteRoomCount = 0;
  Participant? lastRoleParticipant;
  ParticipantRole? lastRole;
  Participant? lastKicked;
  Participant? lastReported;

  @override
  Future<SingleRoomState> build(AppwriteRoom appwriteRoom) async {
    if (throwOnError) throw Exception('load failed');
    if (_state == null) throw StateError('no me');
    return _state;
  }

  @override
  Future<void> turnOnMic(AppwriteRoom room) async => turnOnMicCount++;
  @override
  Future<void> turnOffMic(AppwriteRoom room) async => turnOffMicCount++;
  @override
  Future<void> raiseHand(AppwriteRoom room) async => raiseHandCount++;
  @override
  Future<void> unRaiseHand(AppwriteRoom room) async => unRaiseHandCount++;
  @override
  Future<void> setRole(
    AppwriteRoom room,
    Participant participant,
    ParticipantRole role,
  ) async {
    setRoleCount++;
    lastRoleParticipant = participant;
    lastRole = role;
  }

  @override
  Future<void> kickOutParticipant(
    AppwriteRoom room,
    Participant participant,
  ) async {
    kickOutCount++;
    lastKicked = participant;
  }

  @override
  Future<bool> reportAndKick(
    AppwriteRoom room,
    Participant participant, {
    required ReportDraft report,
  }) async {
    reportAndKickCount++;
    lastReported = participant;
    lastReportDraft = report;
    return !reportFails;
  }

  @override
  Future<void> leaveRoom(AppwriteRoom room) async => leaveRoomCount++;
  @override
  Future<void> deleteRoom(AppwriteRoom room) async => deleteRoomCount++;
}

// Fake data-layer live-rooms cache: serves an optional list, records refreshes.
class FakeLiveRooms extends LiveRooms {
  FakeLiveRooms({this.rooms = const []});
  final List<AppwriteRoom> rooms;
  int refreshCount = 0;

  @override
  Future<List<AppwriteRoom>> build() async => rooms;

  @override
  Future<void> refresh() async => refreshCount++;
}

// Fake RoomLauncher: records joinRoom and can make it throw.
class FakeRoomLauncher implements RoomLauncher {
  FakeRoomLauncher({this.joinThrows = false});
  final bool joinThrows;

  int joinCount = 0;
  AppwriteRoom? lastJoined;

  AppwriteRoom? roomById;
  String? lastFoundId;

  @override
  Future<AppwriteRoom?> findRoomById(String roomId) async {
    lastFoundId = roomId;
    return roomById;
  }

  @override
  Future<AppwriteRoom> joinRoom(AppwriteRoom room) async {
    joinCount++;
    lastJoined = room;
    if (joinThrows) throw Exception('join failed');
    return room.copyWith(myDocId: 'doc-mine');
  }

  @override
  Future<AppwriteRoom> createAndJoinLiveRoom({
    required String name,
    required String description,
    required List<String> tags,
  }) =>
      throw UnimplementedError();
}

// Fake UpcomingRoomsNotifier: build() returns empty, records every action.
class FakeUpcomingRooms extends UpcomingRoomsNotifier {
  int convertCount = 0;
  int deleteUpcomingCount = 0;
  int hideLocallyCount = 0;
  String? convertedId;
  String? convertedName;
  String? convertedDescription;
  List<String>? convertedTags;
  String? deletedId;
  String? hiddenId;
  final List<String> subscribed = [];
  final List<String> unsubscribed = [];

  @override
  Future<List<AppwriteUpcomingRoom>> build() async => const [];

  @override
  Future<void> convertToLive({
    required String upcomingRoomId,
    required String name,
    required String description,
    required List<String> tags,
  }) async {
    convertCount++;
    convertedId = upcomingRoomId;
    convertedName = name;
    convertedDescription = description;
    convertedTags = tags;
  }

  @override
  Future<void> deleteUpcoming(String upcomingRoomId) async {
    deleteUpcomingCount++;
    deletedId = upcomingRoomId;
  }

  @override
  Future<void> subscribe(String upcomingRoomId) async =>
      subscribed.add(upcomingRoomId);

  @override
  Future<void> unsubscribe(String upcomingRoomId) async =>
      unsubscribed.add(upcomingRoomId);

  @override
  Future<void> hideLocally(String upcomingRoomId) async {
    hideLocallyCount++;
    hiddenId = upcomingRoomId;
  }
}

// Fake RoomChatNotifier
class RoomChatState {
  const RoomChatState({this.messages = const [], this.replyingTo});
  final List<RoomMessage> messages;
  final ReplyTo? replyingTo;
}


class FakeRoomChat {
  FakeRoomChat(this.state, {this.error = false});
  final RoomChatState state;
  final bool error;

  int sendCount = 0;
  int editCount = 0;
  int deleteCount = 0;
  int retryCount = 0;
  int setReplyingCount = 0;
  int clearReplyingCount = 0;
  String? lastSentContent;
  String? lastDeletedId;
}

class FakeChatMessages extends RoomChatMessages {
  FakeChatMessages(this.fake);
  final FakeRoomChat fake;

  @override
  Future<List<RoomMessage>> build(
    String roomId,
    String roomName,
    bool isUpcoming,
  ) async {
    if (fake.error) throw Exception('boom');
    return fake.state.messages;
  }

  @override
  Future<bool> sendMessage({
    required String content,
    ReplyTo? replyTo,
    String? pollId,
  }) async {
    fake.sendCount++;
    fake.lastSentContent = content;
    return true;
  }

  @override
  Future<bool> retrySend({required String messageId}) async {
    fake.retryCount++;
    return true;
  }

  @override
  Future<void> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    fake.editCount++;
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    fake.deleteCount++;
    fake.lastDeletedId = messageId;
  }
}

class FakeChatComposer extends RoomChatComposer {
  FakeChatComposer(this.fake);
  final FakeRoomChat fake;

  @override
  ReplyTo? build(String roomId, String roomName, bool isUpcoming) =>
      fake.state.replyingTo;

  @override
  Future<bool> sendMessage({required String content, String? pollId}) async {
    fake.sendCount++;
    fake.lastSentContent = content;
    return true;
  }

  @override
  Future<bool> retrySend({required String messageId}) async {
    fake.retryCount++;
    return true;
  }

  @override
  Future<void> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    fake.editCount++;
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    fake.deleteCount++;
    fake.lastDeletedId = messageId;
  }

  @override
  void setReplyingTo(RoomMessage message) => fake.setReplyingCount++;
  @override
  void clearReplyingTo() => fake.clearReplyingCount++;
}

// Fake CreateRoomNotifier: build() serves the loading bool, records creates.
class FakeCreateRoom extends CreateRoomNotifier {
  FakeCreateRoom({this.loading = false, this.throwOnCreate = false});
  final bool loading;
  final bool throwOnCreate;

  int liveCount = 0;
  int scheduledCount = 0;
  String? lastName;
  String? lastDescription;
  List<String>? lastTags;
  String? lastScheduled;

  @override
  bool build() => loading;

  @override
  Future<AppwriteRoom?> createLiveRoom({
    required String name,
    required String description,
    required List<String> tags,
  }) async {
    liveCount++;
    lastName = name;
    lastDescription = description;
    lastTags = tags;
    if (throwOnCreate) throw Exception('boom');
    return fakeAppwriteRoom(id: 'created');
  }

  @override
  Future<bool> createScheduledRoom({
    required String name,
    required String description,
    required List<String> tags,
    required String scheduledDateTime,
  }) async {
    scheduledCount++;
    lastName = name;
    lastScheduled = scheduledDateTime;
    if (throwOnCreate) throw Exception('boom');
    return true;
  }
}
