// This file contains constants that are used throughout the app.

// Appwrite Project Constants
const String baseDomain = "2043-49-36-144-88.ngrok-free.app";

const String appwriteProjectId = "resonate";
const String appwriteEndpoint = "https://$baseDomain/v1";
const String localhostLivekitEndpoint = "http://$baseDomain/livekit";

// const String appwriteEndpoint = "http://192.168.29.202:80/v1";


// Discussion related Database Constants
const String discussionDatabaseId = "6522fcf27a1bbc4238df";
const String subscribedUserCollectionId = "6522fd267db6fdad3392";
const String discussionsCollectionId = "6522fd163103bd453183";

// User related Database Constants
const String userDatabaseID = "64a1319104a149e16f5c";
const String usersCollectionID = "64a52f0a6c41ded09def";
const String usernameCollectionID = "64a131980b5388c2a0af";
const String userProfileImagePlaceholderUrl =
    "http://$baseDomain/v1/storage/buckets/64a13095a4c87fd78bc6/files/66856231000ff23eea70/view?project=resonate";

const String userProfileImageBucketId = "64a13095a4c87fd78bc6";

// Rooms related Database Constants
const String masterDatabaseId = "64a521785f5be62b796f";
const String roomsCollectionId = "64a5217e695bf2c4ec9c";
const String participantsCollectionId = "64a63e508145d1084abf";

// Pair chat database constants
const String pairRequestCollectionId = "64d980211f1395263ebe";
const String activePairsCollectionId = "64d980cd65ff2e08ab97";

// Room related cloud function constants
const String createRoomServiceId = "651e2670b1e4a26e3cf1";
const String joinRoomServiceId = "651e3d8fa35c690ed957";
const String deleteRoomServiceId = "651e348775f28d84e11e";

const String sendOtpFunctionID = "6513e9d40b57c6ec156f";
const String verifyOtpFunctionID = "651303df122abc151bf3";
const String verifyUserFunctionID = "6513df34a0de595ccfb3";
const String updateEmailFunctionID = "64b27d2e813dd152f0edz";

const String emailVerificationDatabaseID = "64a7bfd6b09121548bfe";
const String verificationCollectionID = "64a7c0100eabfe8d3844";

// Github Constants
const String githubRepoUrl = "https://github.com/AOSSIE-Org/Resonate";

//Authentication Error types
const String userInvalidCredentials = 'user_invalid_credentials';
const String generalArgumentInvalid = 'general_argument_invalid';
