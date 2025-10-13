// This file contains constants that are used throughout the app.

// Appwrite Project Constants

import 'package:get/get.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

const String baseDomain = String.fromEnvironment(
  'APPWRITE_BASE_DOMAIN',
  defaultValue: '10.12.78.30',
);
const String appwriteProjectId = String.fromEnvironment(
  'APPWRITE_PROJECT_ID',
  defaultValue: 'resonate',
);
const String appwriteEndpoint = "http://$baseDomain:80/v1";
const String localhostLivekitEndpoint = "http://$baseDomain:7880";
const String meilisearchEndpoint = String.fromEnvironment(
  'MEILISEARCH_ENDPOINT',
  defaultValue: 'http://$baseDomain:7700',
);
const String meilisearchApiKey = String.fromEnvironment(
  'MEILISEARCH_API_KEY',
  defaultValue: 'myMasterKey',
);

const bool isUsingMeilisearch = bool.fromEnvironment(
  'USE_MEILISEARCH',
  defaultValue: false,
);

// Discussion related Database Constants
const String upcomingRoomsDatabaseId = "6522fcf27a1bbc4238df";
const String subscribedUserCollectionId = "6522fd267db6fdad3392";
const String upcomingRoomsCollectionId = "6522fd163103bd453183";

// Story related Constants
const String storyDatabaseId = "stories";
const String storyCollectionId = "670259e900321c12a5a2";
const String chapterCollectionId = "670277ad002530531daf";
const String likeCollectionId = "670259e20000ddda49a0";
const String storyBucketId = "6703f4c70037edfd8429";
const String chapterDefaultCoverImageId = "67012e19003d00f39e17";
const String storyDefaultCoverImageId = "67012e19003d00f39e16";
const String chapterCoverImagePlaceholderUrl =
    "http://$baseDomain/v1/storage/buckets/$userProfileImageBucketId/files/$chapterDefaultCoverImageId/view?project=resonate&project=resonate&mode=admin";
const String storyCoverImagePlaceholderUrl =
    "http://$baseDomain/v1/storage/buckets/$userProfileImageBucketId/files/$storyDefaultCoverImageId/view?project=resonate&mode=admin";

// User related Database Constants
const String userDatabaseID = "64a1319104a149e16f5c";
const String usersCollectionID = "64a52f0a6c41ded09def";
const String usernameCollectionID = "64a131980b5388c2a0af";
const String followersCollectionID = "68b16bae0027e57ba2c6";
const String friendsCollectionID = "68b43e30002f89343479";
const String userReportsCollectionID = "68dfcba90010d07ee333";
const String userProfileImageBucketId = "64a13095a4c87fd78bc6";
const String liveChapterAttendeesCollectionId = "68e6427f0014f8b0e580";
const String liveChaptersCollectionId = "68e5227e001b2f868c05";

// userProfileImagePlaceholder on theme constant IDs
const String amberUserProfileImagePlaceholderID = "67012e19003d00f39e10";
const String classicUserProfileImagePlaceholderID = "67012e19003d00f39e11";
const String creamUserProfileImagePlaceholderID = "67012e19003d00f39e12";
const String forestUserProfileImagePlaceholderID = "67012e19003d00f39e13";
const String timeUserProfileImagePlaceholderID = "67012e19003d00f39e14";
const String vintageUserProfileImagePlaceholderID = "67012e19003d00f39e15";

// Rooms related Database Constants
const String masterDatabaseId = "64a521785f5be62b796f";
const String roomsCollectionId = "64a5217e695bf2c4ec9c";
const String participantsCollectionId = "64a63e508145d1084abf";
const String chatMessagesCollectionId = "670d812c0002c33c09a8";
const String chatMessageReplyCollectionId = "672759820027801f121f";

// Pair chat database constants
const String pairRequestCollectionId = "64d980211f1395263ebe";
const String activePairsCollectionId = "64d980cd65ff2e08ab97";
const String friendCallsCollectionId = "68b764ba002794fa2f61";

// Room related cloud function constants
const String createRoomServiceId = "651e2670b1e4a26e3cf1";
const String joinRoomServiceId = "651e3d8fa35c690ed957";
const String deleteRoomServiceId = "651e348775f28d84e11e";
const String createLiveChapterRoomFunctionId = "68e8c39600152445ca07";
const String deleteLiveChapterRoomFunctionId = "68ebff09000f814cc979";

const String sendOtpFunctionID = "6513e9d40b57c6ec156f";
const String verifyOtpFunctionID = "651303df122abc151bf3";
const String verifyUserFunctionID = "6513df34a0de595ccfb3";
const String updateEmailFunctionID = "64b27d2e813dd152f0edz";
const String sendMessageNotificationFunctionID = "65368a58ef47cf6861206";
const String sendStoryNotificationFunctionID = "68b241f500012870fca3";
const String startFriendCallFunctionID = "68b76fe00027c243610e";

const String emailVerificationDatabaseID = "64a7bfd6b09121548bfe";
const String verificationCollectionID = "64a7c0100eabfe8d3844";

// Github Constants
const String githubRepoUrl = "https://github.com/AOSSIE-Org/Resonate";
const String discordRepoUrl = "https://discord.com/invite/6mFZ2S846n";
const String xPageUrl = "https://x.com/aossie_org";

//Authentication Error types
const String userInvalidCredentials = 'user_invalid_credentials';
const String generalArgumentInvalid = 'general_argument_invalid';
String languageLocale = "en";
final Rx<WhisperModel> currentWhisperModel = WhisperModel.base.obs;
