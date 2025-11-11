// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Resonate';

  @override
  String get roomDescription =>
      'Be polite and respect the other person\'s opinion. Avoid rude comments.';

  @override
  String get hidePassword => 'Hide Password';

  @override
  String get showPassword => 'Show Password';

  @override
  String get passwordEmpty => 'Password cannot be empty';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String get userCreatedStories => 'User Created Stories';

  @override
  String get yourStories => 'Your Stories';

  @override
  String get userNoStories => 'User has not created any story';

  @override
  String get youNoStories => 'You have not created any story';

  @override
  String get follow => 'Follow';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get verifyEmail => 'Verify Email';

  @override
  String get verified => 'Verified';

  @override
  String get profile => 'Profile';

  @override
  String get userLikedStories => 'User Liked Stories';

  @override
  String get yourLikedStories => 'Your Liked Stories';

  @override
  String get userNoLikedStories => 'User has not liked any story';

  @override
  String get youNoLikedStories => 'You have not liked any story';

  @override
  String get live => 'Live';

  @override
  String get upcoming => 'Upcoming';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'No Room Available',
      'false': 'No Upcoming Room Available',
      'other': 'No Room Information Available',
    });
    return '$_temp0\nGet Started By Adding One Below!';
  }

  @override
  String get user1 => 'User 1';

  @override
  String get user2 => 'User 2';

  @override
  String get you => 'You';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get loggingOut => 'You are logging out of Resonate.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get incorrectEmailOrPassword => 'Incorrect email or password';

  @override
  String get passwordShort => 'Password is less than 8 characters';

  @override
  String get tryAgain => 'Try Again!';

  @override
  String get success => 'Success';

  @override
  String get passwordResetSent => 'Password reset email sent!';

  @override
  String get error => 'Error';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterNewPassword => 'Enter your new password';

  @override
  String get newPassword => 'New Password';

  @override
  String get setNewPassword => 'Set New Password';

  @override
  String get emailChanged => 'Email Changed';

  @override
  String get emailChangeSuccess => 'Email changed successfully!';

  @override
  String get failed => 'Failed';

  @override
  String get emailChangeFailed => 'Failed to change email';

  @override
  String get oops => 'Oops!';

  @override
  String get emailExists => 'Email already exists';

  @override
  String get changeEmail => 'Change Email';

  @override
  String get enterValidEmail => 'Please enter a valid email address';

  @override
  String get newEmail => 'New Email';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get emailChangeInfo =>
      'For added security, you must provide your account\'s current password when changing your email address. After changing your email, use the updated email for future logins.';

  @override
  String get oauthUsersMessage =>
      '(Only for users who logged in using Google or Github)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'To change your email, please enter a new password in the \"Current Password\" field. Be sure to remember this password, as you\'ll need it for any future email changes. Moving forward, you can log in using Google/GitHub or your new email and password combination.';

  @override
  String get resonateTagline => 'Enter a world of limitless\nconversations.';

  @override
  String get signInWithEmail => 'Sign in with Email';

  @override
  String get or => 'Or';

  @override
  String get continueWith => 'Continue with';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithGitHub => 'Continue with GitHub';

  @override
  String get resonateLogo => 'Resonate Logo';

  @override
  String get iAlreadyHaveAnAccount => 'I already have an account';

  @override
  String get createNewAccount => 'Create new account';

  @override
  String get userProfile => 'User profile';

  @override
  String get passwordIsStrong => 'Password is strong';

  @override
  String get admin => 'Admin';

  @override
  String get moderator => 'Moderator';

  @override
  String get speaker => 'Speaker';

  @override
  String get listener => 'Listener';

  @override
  String get removeModerator => 'Remove Moderator';

  @override
  String get kickOut => 'Kick Out';

  @override
  String get addModerator => 'Add Moderator';

  @override
  String get addSpeaker => 'Add Speaker';

  @override
  String get makeListener => 'Make Listener';

  @override
  String get pairChat => 'Pair Chat';

  @override
  String get chooseIdentity => 'Choose Identity';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get noConnection => 'No Connection';

  @override
  String get loadingDialog => 'Loading Dialog';

  @override
  String get createAccount => 'Create Account';

  @override
  String get enterValidEmailAddress => 'Enter Valid Email Address';

  @override
  String get email => 'Email';

  @override
  String get passwordRequirements =>
      'Password must be at least 8 characters long';

  @override
  String get includeNumericDigit => 'Include at least 1 numeric digit';

  @override
  String get includeUppercase => 'Include at least 1 uppercase letter';

  @override
  String get includeLowercase => 'Include at least 1 lowercase letter';

  @override
  String get includeSymbol => 'Include at least 1 symbol';

  @override
  String get signedUpSuccessfully => 'Signed Up Successfully';

  @override
  String get newAccountCreated => 'You have successfully created a new account';

  @override
  String get signUp => 'Sign up';

  @override
  String get login => 'Login';

  @override
  String get settings => 'Settings';

  @override
  String get accountSettings => 'Account settings';

  @override
  String get account => 'Account';

  @override
  String get appSettings => 'App settings';

  @override
  String get themes => 'Themes';

  @override
  String get about => 'About';

  @override
  String get other => 'Other';

  @override
  String get contribute => 'Contribute';

  @override
  String get appPreferences => 'App Preferences';

  @override
  String get transcriptionModel => 'Transcription Model';

  @override
  String get transcriptionModelDescription =>
      'Choose the AI model for voice transcription. Larger models are more accurate but slower and require more storage.';

  @override
  String get whisperModelTiny => 'Tiny';

  @override
  String get whisperModelTinyDescription => 'Fastest, least accurate (~39 MB)';

  @override
  String get whisperModelBase => 'Base';

  @override
  String get whisperModelBaseDescription =>
      'Balanced speed and accuracy (~74 MB)';

  @override
  String get whisperModelSmall => 'Small';

  @override
  String get whisperModelSmallDescription => 'Good accuracy, slower (~244 MB)';

  @override
  String get whisperModelMedium => 'Medium';

  @override
  String get whisperModelMediumDescription => 'High accuracy, slower (~769 MB)';

  @override
  String get whisperModelLargeV1 => 'Large V1';

  @override
  String get whisperModelLargeV1Description =>
      'Most accurate, slowest (~1.55 GB)';

  @override
  String get whisperModelLargeV2 => 'Large V2';

  @override
  String get whisperModelLargeV2Description =>
      'Improved large model with higher accuracy (~1.55 GB)';

  @override
  String get modelDownloadInfo =>
      'Models are downloaded when first used. We recommend using Base, Small, or Medium. Large models require very high-end devices.';

  @override
  String get logOut => 'Log out';

  @override
  String get participants => 'Participants';

  @override
  String get delete => 'delete';

  @override
  String get leave => 'leave';

  @override
  String get leaveButton => 'Leave';

  @override
  String get findingRandomPartner => 'Finding a Random Partner For You';

  @override
  String get quickFact => 'Quick fact';

  @override
  String get cancel => 'Cancel';

  @override
  String get hide => 'Remove';

  @override
  String get removeRoom => 'Remove Room';

  @override
  String get removeRoomFromList => 'Remove from list';

  @override
  String get removeRoomConfirmation =>
      'Are you sure you want to remove this upcoming room from your list?';

  @override
  String get completeYourProfile => 'Complete your Profile';

  @override
  String get uploadProfilePicture => 'Upload profile picture';

  @override
  String get enterValidName => 'Enter Valid Name';

  @override
  String get name => 'Name';

  @override
  String get username => 'Username';

  @override
  String get enterValidDOB => 'Enter Valid DOB';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get next => 'Next';

  @override
  String get noStoriesExist => 'No stories exist to present';

  @override
  String get enterVerificationCode => 'Enter your\nVerification Code';

  @override
  String get verificationCodeSent => 'We sent a 6-digit verification code to\n';

  @override
  String get verificationComplete => 'Verification Complete';

  @override
  String get verificationCompleteMessage =>
      'Congratulations you have verified your Email';

  @override
  String get verificationFailed => 'Verification Failed';

  @override
  String get otpMismatch => 'OTP mismatch occurred please try again';

  @override
  String get otpResent => 'OTP resent';

  @override
  String get requestNewCode => 'Request a new code';

  @override
  String get requestNewCodeIn => 'Request a new code in';

  @override
  String get clickPictureCamera => 'Click picture using camera';

  @override
  String get pickImageGallery => 'Pick image from gallery';

  @override
  String get deleteMyAccount => 'Delete My Account';

  @override
  String get createNewRoom => 'Create New Room';

  @override
  String get pleaseEnterScheduledDateTime => 'Please Enter Scheduled Date-Time';

  @override
  String get scheduleDateTimeLabel => 'Schedule Date Time';

  @override
  String get enterTags => 'Enter tags';

  @override
  String get joinCommunity => 'Join Community';

  @override
  String get followUsOnX => 'Follow us on X';

  @override
  String get joinDiscordServer => 'Join discord server';

  @override
  String get noLyrics => 'No lyrics';

  @override
  String noStoriesInCategory(String categoryName) {
    return 'No stories currently exist in the $categoryName category to present';
  }

  @override
  String get newChapters => 'New Chapters';

  @override
  String get helpToGrow => 'Help to grow';

  @override
  String get share => 'Share';

  @override
  String get rate => 'Rate';

  @override
  String get aboutResonate => 'About Resonate';

  @override
  String get description => 'Description';

  @override
  String get confirm => 'Confirm';

  @override
  String get classic => 'Classic';

  @override
  String get time => 'Time';

  @override
  String get vintage => 'Vintage';

  @override
  String get amber => 'Amber';

  @override
  String get forest => 'Forest';

  @override
  String get cream => 'Cream';

  @override
  String get none => 'none';

  @override
  String checkOutGitHub(String url) {
    return 'Check out our GitHub repository: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'aossie logo';

  @override
  String get errorLoadPackageInfo => 'Could not load package info';

  @override
  String get searchFailed => 'Failed to search rooms. Please try again.';

  @override
  String get updateAvailable => 'Update Available';

  @override
  String get newVersionAvailable => 'A new version is available!';

  @override
  String get upToDate => 'Up to Date';

  @override
  String get latestVersion => 'You\'re using the latest version';

  @override
  String get profileCreatedSuccessfully => 'Profile created successfully';

  @override
  String get invalidScheduledDateTime => 'Invalid Scheduled Date Time';

  @override
  String get scheduledDateTimePast => 'Scheduled Date Time cannot be in past';

  @override
  String get joinRoom => 'Join Room';

  @override
  String get unknownUser => 'Unknown';

  @override
  String get canceled => 'canceled';

  @override
  String get english => 'en';

  @override
  String get emailVerificationRequired => 'Email Verification Required';

  @override
  String get verify => 'Verify';

  @override
  String get audioRoom => 'Audio Room';

  @override
  String toRoomAction(String action) {
    return 'To $action the room';
  }

  @override
  String get mailSentMessage => 'mail sent';

  @override
  String get disconnected => 'disconnected';

  @override
  String get micOn => 'mic';

  @override
  String get speakerOn => 'speaker';

  @override
  String get endChat => 'end-chat';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'March';

  @override
  String get monthApr => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'June';

  @override
  String get monthJul => 'July';

  @override
  String get monthAug => 'Aug';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dec';

  @override
  String get register => 'Register';

  @override
  String get newToResonate => 'New to Resonate? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get checking => 'Checking...';

  @override
  String get forgotPasswordMessage =>
      'Enter your registered email address to reset your password.';

  @override
  String get usernameUnavailable => 'Username Unavailable!';

  @override
  String get usernameInvalidOrTaken =>
      'This username is invalid or either taken already.';

  @override
  String get otpResentMessage => 'Please check your mail for a new OTP.';

  @override
  String get connectionError =>
      'There is a connection error. Please check your internet and try again.';

  @override
  String get seconds => 'seconds.';

  @override
  String get unsavedChangesWarning =>
      'If you proceed without saving, any unsaved changes will be lost.';

  @override
  String get deleteAccountPermanent =>
      'This action will Delete Your Account Permanently. It is irreversible process. We will delete your username, email address, and all other data associated with your account. You will not be able to recover it.';

  @override
  String get giveGreatName => 'Give a great name..';

  @override
  String get joinCommunityDescription =>
      'By joining community you can Clear your doubts, Suggest for new features, Report issues you faced and More.';

  @override
  String get resonateDescription =>
      'Resonate is a social media platform, where every voice is valued. Share your thoughts, stories, and experiences with others. Start your audio journey now. Dive into diverse discussions and topics. Find rooms that resonate with you and become a part of the community. Join the conversation! Explore rooms, connect with friends, and share your voice with the world.';

  @override
  String get resonateFullDescription =>
      'Resonate is a revolutionary voice-based social media platform where every voice matters. \nJoin real-time audio conversations, participate in diverse discussions, and connect with \nlike-minded individuals. Our platform offers:\n- Live audio rooms with topic-based discussions\n- Seamless social networking through voice\n- Community-driven content moderation\n- Cross-platform compatibility\n- End-to-end encrypted private conversations\n\nDeveloped by the AOSSIE open source community, we prioritize user privacy and \ncommunity-driven development. Join us in shaping the future of social audio!';

  @override
  String get stable => 'Stable';

  @override
  String get usernameCharacterLimit =>
      'Username should contain more than 5 characters.';

  @override
  String get submit => 'Submit';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get noSearchResults => 'No Search Results';

  @override
  String get searchRooms => 'Search rooms...';

  @override
  String get searchingRooms => 'Searching rooms...';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get searchError => 'Search Error';

  @override
  String get searchRoomsError => 'Failed to search rooms. Please try again.';

  @override
  String get searchUpcomingRoomsError =>
      'Failed to search upcoming rooms. Please try again.';

  @override
  String get search => 'Search';

  @override
  String get clear => 'Clear';

  @override
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  ) {
    return '🚀 Check out this amazing room: $roomName!\n\n📖 Description: $description\n👥 Join $participants participants now!';
  }

  @override
  String participantsCount(int count) {
    return '$count Participants';
  }

  @override
  String get join => 'Join';

  @override
  String get invalidTags => 'Invalid Tag:';

  @override
  String get cropImage => 'Crop Image';

  @override
  String get profileSavedSuccessfully => 'Profile updated';

  @override
  String get profileUpdatedSuccessfully =>
      'All changes are saved successfully.';

  @override
  String get profileUpToDate => 'Profile up to date';

  @override
  String get noChangesToSave =>
      'There are no new changes made, Nothing to save.';

  @override
  String get connectionFailed => 'Connection Failed';

  @override
  String get unableToJoinRoom =>
      'Unable to join the room. Please check your network and try again.';

  @override
  String get connectionLost => 'Connection Lost';

  @override
  String get unableToReconnect =>
      'Unable to reconnect to the room. Please try rejoining.';

  @override
  String get invalidFormat => 'Invalid Format!';

  @override
  String get usernameAlphanumeric =>
      'Username must be alphanumeric and should not contain special characters.';

  @override
  String get userProfileCreatedSuccessfully =>
      'Your user profile is successfully created.';

  @override
  String get emailVerificationMessage =>
      'To proceed, verify your email address.';

  @override
  String addNewChaptersToStory(String storyName) {
    return 'Add New Chapters to $storyName';
  }

  @override
  String get currentChapters => 'Current Chapters';

  @override
  String get sourceCodeOnGitHub => 'Source code on GitHub';

  @override
  String get createAChapter => 'Create a Chapter';

  @override
  String get chapterTitle => 'Chapter Title *';

  @override
  String get aboutRequired => 'About *';

  @override
  String get changeCoverImage => 'Change Cover Image';

  @override
  String get uploadAudioFile => 'Upload Audio File';

  @override
  String get uploadLyricsFile => 'Upload Lyrics File';

  @override
  String get createChapter => 'Create Chapter';

  @override
  String audioFileSelected(String fileName) {
    return 'Audio file Selected: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'Lyrics File Selected: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'Please fill in all required fields and upload your Audio file and Lyrics file';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get ok => 'OK';

  @override
  String get roomDescriptionOptional => 'Room Description (optional)';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get createYourStory => 'Create Your Story';

  @override
  String get titleRequired => 'Title *';

  @override
  String get category => 'Category *';

  @override
  String get addChapter => 'Add Chapter';

  @override
  String get createStory => 'Create Story';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'Please fill in all required fields, add at least one chapter, and select a cover image.';

  @override
  String get toConfirmType => 'To confirm, type';

  @override
  String get inTheBoxBelow => 'in the box below';

  @override
  String get iUnderstandDeleteMyAccount => 'I understand, Delete My Account';

  @override
  String get whatDoYouWantToListenTo => 'What do you want to listen to?';

  @override
  String get categories => 'Categories';

  @override
  String get stories => 'Stories';

  @override
  String get someSuggestions => 'Some Suggestions';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get welcomeToResonate => 'Welcome to Resonate';

  @override
  String get exploreDiverseConversations => 'Explore Diverse Conversations';

  @override
  String get yourVoiceMatters => 'Your Voice Matters';

  @override
  String get joinConversationExploreRooms =>
      'Join the conversation! Explore rooms, connect with friends, and share your voice with the world.';

  @override
  String get diveIntoDiverseDiscussions =>
      'Dive into diverse discussions and topics. \nFind rooms that resonate with you and become a part of the community.';

  @override
  String get atResonateEveryVoiceValued =>
      'At Resonate, every voice is valued. Share your thoughts, stories, and experiences with others. Start your audio journey now.';

  @override
  String get notifications => 'Notifications';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username tagged you in an upcoming room: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username tagged you in room: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username liked your story: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username subscribed to your room: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username started following you';
  }

  @override
  String get youHaveNewNotification => 'You have a new notification';

  @override
  String get hangOnGoodThingsTakeTime => 'Hang on, Good Things take time 🔍';

  @override
  String get resonateOpenSourceProject =>
      'Resonate is an open source project maintained by AOSSIE. Checkout our github to contribute.';

  @override
  String get mute => 'Mute';

  @override
  String get speakerLabel => 'Speaker';

  @override
  String get end => 'End';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get discard => 'DISCARD';

  @override
  String get save => 'SAVE';

  @override
  String get changeProfilePicture => 'Change profile picture';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get remove => 'Remove';

  @override
  String created(String date) {
    return 'Created $date';
  }

  @override
  String get chapters => 'Chapters';

  @override
  String get deleteStory => 'Delete Story';

  @override
  String createdBy(String creatorName) {
    return 'Created by $creatorName';
  }

  @override
  String get start => 'Start';

  @override
  String get unsubscribe => 'Unsubscribe';

  @override
  String get subscribe => 'Subscribe';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'Drama',
      'comedy': 'Comedy',
      'horror': 'Horror',
      'romance': 'Romance',
      'thriller': 'Thriller',
      'spiritual': 'Spiritual',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String chooseTheme(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'classicTheme': 'Classic',
      'timeTheme': 'Time',
      'vintageTheme': 'Vintage',
      'amberTheme': 'Amber',
      'forestTheme': 'Forest',
      'creamTheme': 'Cream',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get by => 'by';

  @override
  String get likes => 'Likes';

  @override
  String get lengthMinutes => 'min';

  @override
  String get requiredField => 'Required field';

  @override
  String get onlineUsers => 'Online Users';

  @override
  String get noOnlineUsers => 'No users currently online';

  @override
  String get chooseUser => 'Choose User to chat with';

  @override
  String get quickMatch => 'Quick Match';

  @override
  String get story => 'Story';

  @override
  String get user => 'User';

  @override
  String get following => 'Following';

  @override
  String get followers => 'Followers';

  @override
  String get friendRequests => 'Friend Requests';

  @override
  String get friendRequestSent => 'Friend request sent';

  @override
  String friendRequestSentTo(String username) {
    return 'Your friend request to $username has been sent.';
  }

  @override
  String get friendRequestCancelled => 'Friend request cancelled';

  @override
  String friendRequestCancelledTo(String username) {
    return 'Your friend request to $username has been cancelled.';
  }

  @override
  String get requested => 'Requested';

  @override
  String get friends => 'Friends';

  @override
  String get addFriend => 'Add Friend';

  @override
  String get friendRequestAccepted => 'Friend request accepted';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'You are now friends with $username.';
  }

  @override
  String get friendRequestDeclined => 'Friend request declined';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'You have declined the friend request from $username.';
  }

  @override
  String get accept => 'Accept';

  @override
  String get callDeclined => 'Call declined';

  @override
  String callDeclinedTo(String username) {
    return 'User $username declined the call.';
  }

  @override
  String get checkForUpdates => 'Check Updates';

  @override
  String get updateNow => 'Update Now';

  @override
  String get updateLater => 'Later';

  @override
  String get updateSuccessful => 'Update Successful';

  @override
  String get updateSuccessfulMessage =>
      'Resonate has been updated successfully!';

  @override
  String get updateCancelled => 'Update Cancelled';

  @override
  String get updateCancelledMessage => 'Update was cancelled by user';

  @override
  String get updateFailed => 'Update Failed';

  @override
  String get updateFailedMessage =>
      'Failed to update. Please try updating from Play Store manually.';

  @override
  String get updateError => 'Update Error';

  @override
  String get updateErrorMessage =>
      'An error occurred while updating. Please try again.';

  @override
  String get platformNotSupported => 'Platform Not Supported';

  @override
  String get platformNotSupportedMessage =>
      'Update checking is only available on Android devices';

  @override
  String get updateCheckFailed => 'Update Check Failed';

  @override
  String get updateCheckFailedMessage =>
      'Could not check for updates. Please try again later.';

  @override
  String get upToDateTitle => 'You\'re Up to Date!';

  @override
  String get upToDateMessage => 'You\'re using the latest version of Resonate';

  @override
  String get updateAvailableTitle => 'Update Available!';

  @override
  String get updateAvailableMessage =>
      'A new version of Resonate is available on Play Store';

  @override
  String get updateFeaturesImprovement =>
      'Get the latest features and improvements!';

  @override
  String get failedToRemoveRoom => 'Failed to remove room';

  @override
  String get roomRemovedSuccessfully =>
      'Room removed from your list successfully';

  @override
  String get alert => 'Alert';

  @override
  String get removedFromRoom =>
      'You have been reported or removed from the room';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'Harassment / Hate Speech',
      'abuse': 'Abusive content / Violence',
      'spam': 'Spam / Scams / Fraud',
      'impersonation': 'Impersonation / Fake Accounts',
      'illegal': 'Illegal Activities',
      'selfharm': 'Self-harm / Suicide / Mental health',
      'misuse': 'Misuse of platform',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate =>
      'You have received multiple reports from users and you have been blocked from using Resonate. Please contact AOSSIE if you believe this is a mistake.';

  @override
  String get reportParticipant => 'Report Participant';

  @override
  String get selectReportType => 'Please select a report type';

  @override
  String get reportSubmitted => 'Report Submitted Successfully';

  @override
  String get reportFailed => 'Report Submission Failed';

  @override
  String get additionalDetailsOptional => 'Additional details (optional)';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get actionBlocked => 'Action Blocked';

  @override
  String get cannotStopRecording =>
      'You cannot stop the recording manually, the recording will be stopped when the room is closed.';

  @override
  String get liveChapter => 'Live Chapter';

  @override
  String get viewOrEditLyrics => 'View or Edit Lyrics';

  @override
  String get close => 'Close';

  @override
  String get verifyChapterDetails => 'Verify Chapter Details';

  @override
  String get author => 'Author';

  @override
  String get startLiveChapter => 'Start a Live Chapter';

  @override
  String get fillAllFields => 'Please fill in all required fields';

  @override
  String get noRecordingError =>
      'You have not recorded anything for the chapter. Please record a chapter before exiting the room';
}
