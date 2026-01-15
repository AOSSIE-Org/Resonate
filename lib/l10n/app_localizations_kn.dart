// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get title => 'ರೆಸೋನೇಟ್';

  @override
  String get roomDescription =>
      'ವಿನಯಶೀಲರಾಗಿರಿ ಮತ್ತು ಇತರರ ಅಭಿಪ್ರಾಯವನ್ನು ಗೌರವಿಸಿ. ಅಸಭ್ಯ ಕಾಮೆಂಟ್‌ಗಳನ್ನು ಬಳಸಬೇಡಿ.';

  @override
  String get hidePassword => 'ಪಾಸ್‌ವರ್ಡ್ ತೋರಿಸಬೇಡ';

  @override
  String get showPassword => 'ಪಾಸ್‌ವರ್ಡ್ ತೋರಿಸಿ';

  @override
  String get passwordEmpty => 'ಪಾಸ್‌ವರ್ಡ್ ಖಾಲಿ ಇರಬಾರದು';

  @override
  String get password => 'ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get confirmPassword => 'ಪಾಸ್‌ವರ್ಡ್ ದೃಢೀಕರಿಸಿ';

  @override
  String get passwordsNotMatch => 'ಪಾಸ್‌ವರ್ಡ್‌ಗಳು ಹೊಂದಿಕೆಯಾಗುತ್ತಿಲ್ಲ';

  @override
  String get userCreatedStories => 'ಬಳಕೆದಾರರು ರಚಿಸಿದ ಕಥೆಗಳು';

  @override
  String get yourStories => 'ನಿಮ್ಮ ಕಥೆಗಳು';

  @override
  String get userNoStories => 'ಬಳಕೆದಾರರು ಯಾವುದೇ ಕಥೆ ರಚಿಸಿಲ್ಲ';

  @override
  String get youNoStories => 'ನೀವು ಯಾವುದೇ ಕಥೆ ರಚಿಸಿಲ್ಲ';

  @override
  String get follow => 'ಫಾಲೋ';

  @override
  String get editProfile => 'ಪ್ರೊಫೈಲ್ ಮಾರ್ಪಡಿಸು';

  @override
  String get verifyEmail => 'ಇಮೇಲ್ ಪರಿಶೀಲಿಸಿ';

  @override
  String get verified => 'ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get profile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get userLikedStories => 'ಬಳಕೆದಾರರು ಇಷ್ಟಪಟ್ಟ ಕಥೆಗಳು';

  @override
  String get yourLikedStories => 'ನೀವು ಇಷ್ಟಪಟ್ಟ ಕಥೆಗಳು';

  @override
  String get userNoLikedStories => 'ಬಳಕೆದಾರರು ಯಾವುದೇ ಕಥೆಯನ್ನು ಇಷ್ಟಪಟ್ಟಿಲ್ಲ';

  @override
  String get youNoLikedStories => 'ನೀವು ಯಾವುದೇ ಕಥೆಯನ್ನು ಇಷ್ಟಪಟ್ಟಿಲ್ಲ';

  @override
  String get live => 'ಲೈವ್';

  @override
  String get upcoming => 'ಮುಂಬರುವ';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'ಯಾವುದೇ ರೂಮ್ ಲಭ್ಯವಿಲ್ಲ',
      'false': 'ಯಾವುದೇ ಮುಂಬರುವ ರೂಮ್ ಲಭ್ಯವಿಲ್ಲ',
      'other': 'ರೂಮ್ ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ',
    });
    return '$_temp0\nಕೆಳಗೆ ಒಂದು ರೂಮ್ಅನ್ನು ಸೇರಿಸುವ ಮೂಲಕ ಪ್ರಾರಂಭಿಸಿ!';
  }

  @override
  String get user1 => 'ಬಳಕೆದಾರ 1';

  @override
  String get user2 => 'ಬಳಕೆದಾರ 2';

  @override
  String get you => 'ನೀವು';

  @override
  String get areYouSure => 'ಖಚಿತವೇ?';

  @override
  String get loggingOut => 'ನೀವು ರೆಸೋನೇಟ್‌ನಿಂದ ಲಾಗ್ ಔಟ್ ಆಗುತ್ತಿದ್ದೀರಿ.';

  @override
  String get yes => 'ಹೌದು';

  @override
  String get no => 'ಇಲ್ಲ';

  @override
  String get incorrectEmailOrPassword => 'ಇಮೇಲ್ ಅಥವಾ ಪಾಸ್‌ವರ್ಡ್ ತಪ್ಪಾಗಿದೆ';

  @override
  String get passwordShort => 'ಪಾಸ್‌ವರ್ಡ್ 8 ಅಕ್ಷರಗಳಿಗಿಂತ ಕಡಿಮೆ ಇದೆ';

  @override
  String get tryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ!';

  @override
  String get success => 'ಯಶಸ್ವಿ';

  @override
  String get passwordResetSent => 'ಪಾಸ್‌ವರ್ಡ್ ಬದಲಾಯಿಸುವ ಇಮೇಲ್ ಕಳುಹಿಸಲಾಗಿದೆ!';

  @override
  String get error => 'ಏನೋ ತಪ್ಪಾಗಿದೆ';

  @override
  String get resetPassword => 'ಪಾಸ್‌ವರ್ಡ್ ಬದಲಾಯಿಸಿ';

  @override
  String get enterNewPassword => 'ನಿಮ್ಮ ಹೊಸ ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ';

  @override
  String get newPassword => 'ಹೊಸ ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get setNewPassword => 'ಹೊಸ ಪಾಸ್‌ವರ್ಡ್ ಹೊಂದಿಸಿ';

  @override
  String get emailChanged => 'ಇಮೇಲ್ ಬದಲಾಯಿಸಲಾಗಿದೆ';

  @override
  String get emailChangeSuccess => 'ಇಮೇಲ್ ಯಶಸ್ವಿಯಾಗಿ ಬದಲಾಯಿಸಲಾಗಿದೆ!';

  @override
  String get failed => 'ವಿಫಲವಾಗಿದೆ';

  @override
  String get emailChangeFailed => 'ಇಮೇಲ್ ಬದಲಾಯಿಸಲು ವಿಫಲವಾಗಿದೆ';

  @override
  String get oops => 'ಅಯ್ಯೋ!';

  @override
  String get emailExists => 'ಇಮೇಲ್ ಈಗಾಗಲೇ ಬಳಕೆಯಲ್ಲಿದೆ';

  @override
  String get changeEmail => 'ಇಮೇಲ್ ಬದಲಾಯಿಸಿ';

  @override
  String get enterValidEmail => 'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ';

  @override
  String get newEmail => 'ಹೊಸ ಇಮೇಲ್';

  @override
  String get currentPassword => 'ಪ್ರಸ್ತುತ ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get emailChangeInfo =>
      'ನಿಮ್ಮ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ಬದಲಾಯಿಸುವಾಗ ನಿಮ್ಮ ಖಾತೆಯ ಪ್ರಸ್ತುತ ಪಾಸ್‌ವರ್ಡ್ ಒದಗಿಸಬೇಕು. ನಿಮ್ಮ ಇಮೇಲ್ ಬದಲಾಯಿಸಿದ ನಂತರ, ಮುಂದಿನ ಲಾಗಿನ್‌ಗಳಿಗಾಗಿ ಬದಲಾಯಿಸಿದ ಇಮೇಲ್ ಬಳಸಿ. ಹೆಚ್ಚುವರಿ ಭದ್ರತೆಗಾಗಿ ನಾವು ಇದನ್ನು ಮಾಡಿದ್ದೇವೆ';

  @override
  String get oauthUsersMessage =>
      '(ಗೂಗಲ್ ಅಥವಾ Github ಬಳಸಿ ಲಾಗಿನ್ ಮಾಡಿದ ಬಳಕೆದಾರರಿಗೆ ಮಾತ್ರ)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'ನಿಮ್ಮ ಇಮೇಲ್ ಬದಲಾಯಿಸಲು, ದಯವಿಟ್ಟು \"ಪ್ರಸ್ತುತ ಪಾಸ್‌ವರ್ಡ್\" ಜಾಗದಲ್ಲಿ ಹೊಸ ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ. ಈ ಪಾಸ್‌ವರ್ಡ್ ನೆನಪಿನಲ್ಲಿಡಿ, ಯಾಕೆಂದರೆ ಮುಂದೆ ಇಮೇಲ್ ಬದಲಾವಣೆಗಳಿಗೆ ಇದು ಅಗತ್ಯವಾಗುತ್ತದೆ. ಮುಂದೆ, ನೀವು ಗೂಗಲ್/GitHub ಅಥವಾ ನಿಮ್ಮ ಹೊಸ ಇಮೇಲ್ ಮತ್ತು ಪಾಸ್‌ವರ್ಡ್ಗಳನ್ನು ಬಳಸಿ ಲಾಗಿನ್ ಮಾಡಬಹುದು.';

  @override
  String get resonateTagline => 'ಮಿತಿಯೇ ಇಲ್ಲ ಸಂಭಾಷಣೆಗಳ\nಲೋಕಕ್ಕೆ ಪ್ರವೇಶಿಸಿ.';

  @override
  String get signInWithEmail => 'ಇಮೇಲ್‌ನೊಂದಿಗೆ ಸೈನ್ ಇನ್ ಮಾಡಿ';

  @override
  String get or => 'ಅಥವಾ';

  @override
  String get continueWith => 'ಇದರೊಂದಿಗೆ ಮುಂದುವರಿಸಿ';

  @override
  String get continueWithGoogle => 'ಗೂಗಲ್ ನೊಂದಿಗೆ ಮುಂದುವರಿಸಿ';

  @override
  String get continueWithGitHub => 'GitHub ನೊಂದಿಗೆ ಮುಂದುವರಿಸಿ';

  @override
  String get resonateLogo => 'ರೆಸೋನೇಟ್ ಲೋಗೋ';

  @override
  String get iAlreadyHaveAnAccount => 'ನನ್ನ ಬಳಿ ಈಗಾಗಲೇ ಖಾತೆ ಇದೆ';

  @override
  String get createNewAccount => 'ಹೊಸ ಖಾತೆ ರಚಿಸಿ';

  @override
  String get userProfile => 'ಬಳಕೆದಾರರ ಪ್ರೊಫೈಲ್';

  @override
  String get passwordIsStrong => 'ಪಾಸ್‌ವರ್ಡ್ ಶಕ್ತಿಯುತವಾಗಿದೆ';

  @override
  String get admin => 'ನಿರ್ವಾಹಕ';

  @override
  String get moderator => 'ಮಾಡರೇಟರ್';

  @override
  String get speaker => 'ಮಾತನಾಡುವವರು';

  @override
  String get listener => 'ಕೇಳುಗ';

  @override
  String get removeModerator => 'ಮಾಡರೇಟರ್ ತೆಗೆದುಹಾಕಿ';

  @override
  String get kickOut => 'ಹೊರಗೆ ಕಳುಹಿಸಿ';

  @override
  String get addModerator => 'ಮಾಡರೇಟರ್ ಸೇರಿಸಿ';

  @override
  String get addSpeaker => 'ಮಾತನಾಡುವವರನ್ನು ಸೇರಿಸಿ';

  @override
  String get makeListener => 'ಕೇಳುಗನ್ನಾಗಿ ಮಾಡಿ';

  @override
  String get pairChat => 'ಚಾಟ್ ಪೇರ್ ಮಾಡಿ';

  @override
  String get chooseIdentity => 'ಗುರುತಿನ ಆಯ್ಕೆ';

  @override
  String get selectLanguage => 'ಭಾಷೆ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get noConnection => 'ಇಂಟರ್ನೆಟ್ ಕನೆಕ್ಷನ್ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get loadingDialog => 'ಲೋಡ್ ಆಗುತ್ತಿದೆ';

  @override
  String get createAccount => 'ಖಾತೆ ರಚಿಸಿ';

  @override
  String get enterValidEmailAddress => 'ಮಾನ್ಯವಾದ ಇಮೇಲ್ ನಮೂದಿಸಿ';

  @override
  String get email => 'ಇಮೇಲ್';

  @override
  String get passwordRequirements => 'ಪಾಸ್‌ವರ್ಡ್ ಕನಿಷ್ಠ 8 ಅಕ್ಷರಗಳಿರಬೇಕು ';

  @override
  String get includeNumericDigit => 'ಕನಿಷ್ಠ 1 ಸಂಖ್ಯೆಯನ್ನು ಸೇರಿಸಿ';

  @override
  String get includeUppercase => 'ಕನಿಷ್ಠ 1 ಅಪ್ಪರ್ ಕೇಸ್ ಸೇರಿಸಿ';

  @override
  String get includeLowercase => 'ಕನಿಷ್ಠ 1 ಲೋವರ್ ಕೇಸ್ ಸೇರಿಸಿ';

  @override
  String get includeSymbol => 'ಕನಿಷ್ಠ 1 ಚಿಹ್ನೆಯನ್ನು ಸೇರಿಸಿ';

  @override
  String get signedUpSuccessfully => 'ಯಶಸ್ವಿಯಾಗಿ ಸೈನ್ ಅಪ್ ಆಗಿದೆ';

  @override
  String get newAccountCreated => 'ನೀವು ಯಶಸ್ವಿಯಾಗಿ ಹೊಸ ಖಾತೆಯನ್ನು ರಚಿಸಿದ್ದೀರಿ';

  @override
  String get signUp => 'ಸೈನ್ ಅಪ್';

  @override
  String get login => 'ಲಾಗಿನ್';

  @override
  String get settings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get accountSettings => 'ಖಾತೆ ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get account => 'ಖಾತೆ';

  @override
  String get appSettings => 'ಆ್ಯಪ್ ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get themes => 'ಥೀಮ್‌ಗಳು';

  @override
  String get about => 'ನಮ್ಮ ಬಗ್ಗೆ';

  @override
  String get other => 'ಇತರೆ';

  @override
  String get contribute => 'ಕೊಡುಗೆ ನೀಡಿ';

  @override
  String get appPreferences => 'ಆ್ಯಪ್ ಆದ್ಯತೆಗಳು';

  @override
  String get transcriptionModel => 'ಪ್ರತಿಲೇಖನ ಮಾದರಿ';

  @override
  String get transcriptionModelDescription =>
      'ಧ್ವನಿ ಪ್ರತಿಲೇಖನಕ್ಕಾಗಿ AI ಮಾಡೆಲ್ ಆಯ್ಕೆಮಾಡಿ. ದೊಡ್ಡ ಮಾಡೆಲ್ಗಳು ಹೆಚ್ಚು ನಿಖರವಾಗಿರುತ್ತವೆ ಆದರೆ ಅವುಗಳು ನಿಧಾನ ಮತ್ತು ಹೆಚ್ಚು ಸ್ಟೋರೇಜ್ ತೆಗುದುಕೊಳ್ಳುತ್ತದೆ.';

  @override
  String get whisperModelTiny => 'ಟೈನಿ';

  @override
  String get whisperModelTinyDescription =>
      'ಅತ್ಯಂತ ವೇಗವಾದ, ಕಡಿಮೆ ನಿಖರವಾದ (~39 MB)';

  @override
  String get whisperModelBase => 'ಬೇಸ್';

  @override
  String get whisperModelBaseDescription => 'ಸಮತೋಲಿತ ವೇಗ ಮತ್ತು ನಿಖರತೆ (~74 MB)';

  @override
  String get whisperModelSmall => 'ಸ್ಮಾಲ್';

  @override
  String get whisperModelSmallDescription => 'ಉತ್ತಮ ನಿಖರತೆ, ನಿಧಾನ (~244 MB)';

  @override
  String get whisperModelMedium => 'ಮೀಡಿಯಂ';

  @override
  String get whisperModelMediumDescription => 'ಹೆಚ್ಚಿನ ನಿಖರತೆ, ನಿಧಾನ (~769 MB)';

  @override
  String get whisperModelLargeV1 => 'ಲಾರ್ಜ್ V1';

  @override
  String get whisperModelLargeV1Description =>
      'ಅತ್ಯಂತ ನಿಖರ, ಅತ್ಯಂತ ನಿಧಾನ (~1.55 GB)';

  @override
  String get whisperModelLargeV2 => 'ಲಾರ್ಜ್ V2';

  @override
  String get whisperModelLargeV2Description =>
      'ಸುಧಾರಿತ ದೊಡ್ಡ ಮಾಡೆಲ್ ಹೆಚ್ಚಿನ ನಿಖರತೆಯೊಂದಿಗೆ (~1.55 GB)';

  @override
  String get modelDownloadInfo =>
      'ಮಾಡೆಲ್ಳನ್ನು ಮೊದಲ ಬಾರಿಗೆ ಬಳಸಿದಾಗ ಡೌನ್‌ಲೋಡ್ ಮಾಡಲಾಗುತ್ತದೆ. ನಾವು ಬೇಸ್, ಸ್ಮಾಲ್ ಅಥವಾ ಮೀಡಿಯಂ ಬಳಸಲು ಶಿಫಾರಸು ಮಾಡುತ್ತೇವೆ. ದೊಡ್ಡ ಮಾಡೆಲ್ಗಳಿಗೆ ಅತ್ಯಂತ ಉನ್ನತ ದರ್ಜೆಯ ಮೊಬೈಲ್/ಸಾಧನಗಳು ಬೇಕಾಗುತ್ತವೆ.';

  @override
  String get logOut => 'ಲಾಗ್ ಔಟ್';

  @override
  String get participants => 'ಭಾಗವಹಿಸುವವರು';

  @override
  String get delete => 'ಅಳಿಸಿ';

  @override
  String get leave => 'ಬಿಟ್ಟುಹೋಗಿ';

  @override
  String get leaveButton => 'ಬಿಡಿ';

  @override
  String get findingRandomPartner =>
      'ನಿಮಗಾಗಿ ಯಾದೃಚ್ಛಿಕ ಪಾಲುದಾರರನ್ನು ಹುಡುಕುತ್ತಿದೆ';

  @override
  String get quickFact => 'ತ್ವರಿತ ಸತ್ಯ';

  @override
  String get cancel => 'ರದ್ದುಮಾಡಿ';

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
  String get completeYourProfile => 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಪೂರ್ಣಗೊಳಿಸಿ';

  @override
  String get uploadProfilePicture => 'ಪ್ರೊಫೈಲ್ ಚಿತ್ರವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String get enterValidName => 'ಮಾನ್ಯವಾದ ಹೆಸರು ನಮೂದಿಸಿ';

  @override
  String get name => 'ಹೆಸರು';

  @override
  String get username => 'ಬಳಕೆದಾರ ಹೆಸರು';

  @override
  String get enterValidDOB => 'ಮಾನ್ಯವಾದ ಜನ್ಮ ದಿನಾಂಕ ನಮೂದಿಸಿ';

  @override
  String get dateOfBirth => 'ಜನ್ಮ ದಿನಾಂಕ';

  @override
  String get forgotPassword => 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿರಾ?';

  @override
  String get next => 'ಮುಂದೆ';

  @override
  String get noStoriesExist => 'ಪ್ರಸ್ತುತಪಡಿಸಲು ಯಾವುದೇ ಕಥೆಗಳು ಇಲ್ಲ';

  @override
  String get enterVerificationCode => 'ನಿಮ್ಮ ಪರಿಶೀಲನಾ\nಕೋಡ್ ನಮೂದಿಸಿ';

  @override
  String get verificationCodeSent =>
      'ನಾವು 6-ಅಂಕಿಯ ಪರಿಶೀಲನಾ ಕೋಡ್ ಕಳುಹಿಸಿದ್ದೇವೆ\n';

  @override
  String get verificationComplete => 'ಪರಿಶೀಲನೆ ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get verificationCompleteMessage =>
      'ಅಭಿನಂದನೆಗಳು ನೀವು ನಿಮ್ಮ ಇಮೇಲ್ ಅನ್ನು ಪರಿಶೀಲಿಸಿದ್ದೀರಿ';

  @override
  String get verificationFailed => 'ಪರಿಶೀಲನೆ ವಿಫಲವಾಗಿದೆ';

  @override
  String get otpMismatch =>
      'OTP ಹೊಂದಾಣಿಕೆಯಾಗುತ್ತಿಲ್ಲ ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get otpResent => 'OTP ಮರು ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get requestNewCode => 'ಹೊಸ ಕೋಡ್ ವಿನಂತಿಸಿ';

  @override
  String get requestNewCodeIn => 'ಹೊಸ ಕೋಡ್ ವಿನಂತಿಸಿ';

  @override
  String get clickPictureCamera => 'ಕ್ಯಾಮೆರಾ ಬಳಸಿ ಚಿತ್ರ ತೆಗೆಯಿರಿ';

  @override
  String get pickImageGallery => 'ಗ್ಯಾಲರಿಯಿಂದ ಚಿತ್ರ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get deleteMyAccount => 'ನನ್ನ ಖಾತೆ ಅಳಿಸಿ';

  @override
  String get createNewRoom => 'ಹೊಸ ರೂಮ್ ರಚಿಸಿ';

  @override
  String get pleaseEnterScheduledDateTime =>
      'ದಯವಿಟ್ಟು ನಿಗದಿತ ದಿನಾಂಕ-ಸಮಯ ನಮೂದಿಸಿ';

  @override
  String get scheduleDateTimeLabel => 'ದಿನಾಂಕ ಸಮಯ ನಿಗದಿಪಡಿಸಿ';

  @override
  String get enterTags => 'ಟ್ಯಾಗ್‌ಗಳನ್ನು ನಮೂದಿಸಿ';

  @override
  String get joinCommunity => 'ಕಮ್ಯೂನಿಟಿಗೆ ಸೇರಿ';

  @override
  String get followUsOnX => 'X ನಲ್ಲಿ ನಮ್ಮನ್ನು ಫಾಲೋ ಮಾಡಿ';

  @override
  String get joinDiscordServer => 'Discord ಸರ್ವರ್‌ಗೆ ಸೇರಿ';

  @override
  String get noLyrics => 'ಯಾವುದೇ ಸಾಹಿತ್ಯ ಇಲ್ಲ';

  @override
  String noStoriesInCategory(String categoryName) {
    return '$categoryName ವರ್ಗದಲ್ಲಿ ಪ್ರಸ್ತುತ ಯಾವುದೇ ಕಥೆಗಳು ಇಲ್ಲ';
  }

  @override
  String get newChapters => 'ಹೊಸ ಅಧ್ಯಾಯಗಳು';

  @override
  String get helpToGrow => 'ಬೆಳೆಯಲು ಸಹಾಯ ಮಾಡಿ';

  @override
  String get share => 'ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String get rate => 'ರೇಟ್ ಮಾಡಿ';

  @override
  String get aboutResonate => 'ರೆಸೋನೇಟ್ ಬಗ್ಗೆ';

  @override
  String get description => 'ವಿವರಣೆ';

  @override
  String get confirm => 'ದೃಢೀಕರಿಸಿ';

  @override
  String get classic => 'ಕ್ಲಾಸಿಕ್';

  @override
  String get time => 'ಟೈಮ್';

  @override
  String get vintage => 'ವಿಂಟೇಜ್';

  @override
  String get amber => 'ಆಂಬರ್';

  @override
  String get forest => 'ಫಾರೆಸ್ಟ್';

  @override
  String get cream => 'ಕ್ರೀಮ್';

  @override
  String get none => 'ಯಾವುದೂ ಇಲ್ಲ';

  @override
  String checkOutGitHub(String url) {
    return 'ನಮ್ಮ GitHub ರೆಪೊಸಿಟರಿ ನೋಡಿ: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'aossie ಲೋಗೋ';

  @override
  String get errorLoadPackageInfo =>
      'ಪ್ಯಾಕೇಜ್ ಮಾಹಿತಿಯನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get searchFailed => 'Failed to search rooms. Please try again.';

  @override
  String get updateAvailable => 'ಅಪ್ಡೇಟ್ ಲಭ್ಯವಿದೆ';

  @override
  String get newVersionAvailable => 'ಹೊಸ ಅಪ್ಡೇಟ್ ಲಭ್ಯವಿದೆ!';

  @override
  String get upToDate => 'ಅಪ್ಡೇಟ್ ಆಗಿದೆ';

  @override
  String get latestVersion => 'ನೀವು ಇತ್ತೀಚಿನ ಅಪ್ಡೇಟ್ಅನ್ನು ಬಳಸುತ್ತಿದ್ದೀರಿ';

  @override
  String get profileCreatedSuccessfully => 'ಪ್ರೊಫೈಲ್ ಯಶಸ್ವಿಯಾಗಿ ರಚಿಸಲಾಗಿದೆ';

  @override
  String get invalidScheduledDateTime => 'ನಿಗದಿತ ದಿನಾಂಕ ಸಮಯ ಅಮಾನ್ಯವಾಗಿದೆ';

  @override
  String get scheduledDateTimePast => 'ನಿಗದಿತ ದಿನಾಂಕ ಸಮಯ ಹಿಂದಿನ ದಿನವಾಗಿರಬಾರದು';

  @override
  String get joinRoom => 'ರೂಮ್‌ಗೆ ಸೇರಿ';

  @override
  String get unknownUser => 'ಅಜ್ಞಾತ/ಅನ್ನೋನ್';

  @override
  String get canceled => 'ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get english => 'en';

  @override
  String get emailVerificationRequired => 'ಇಮೇಲ್ ಪರಿಶೀಲನೆ ಅಗತ್ಯವಿದೆ';

  @override
  String get verify => 'ಪರಿಶೀಲಿಸಿ';

  @override
  String get audioRoom => 'ಆಡಿಯೋ ರೂಮ್';

  @override
  String toRoomAction(String action) {
    return 'ರೂಮ್ ಅನ್ನು $action ಮಾಡಲು';
  }

  @override
  String get mailSentMessage => 'ಮೇಲ್ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get disconnected => 'ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕ ಕಡಿತಗೊಂಡಿದೆ';

  @override
  String get micOn => 'ಮೈಕ್';

  @override
  String get speakerOn => 'ಮಾತನಾಡುವವರು';

  @override
  String get endChat => 'ಚಾಟ್ ಮುಗಿಸಿ';

  @override
  String get monthJan => 'ಜನವರಿ';

  @override
  String get monthFeb => 'ಫೆಬ್ರವರಿ';

  @override
  String get monthMar => 'ಮಾರ್ಚ್';

  @override
  String get monthApr => 'ಏಪ್ರಿಲ್';

  @override
  String get monthMay => 'ಮೇ';

  @override
  String get monthJun => 'ಜೂನ್';

  @override
  String get monthJul => 'ಜುಲೈ';

  @override
  String get monthAug => 'ಆಗಸ್ಟ್';

  @override
  String get monthSep => 'ಸೆಪ್ಟೆಂಬರ್';

  @override
  String get monthOct => 'ಅಕ್ಟೋಬರ್';

  @override
  String get monthNov => 'ನವೆಂಬರ್';

  @override
  String get monthDec => 'ಡಿಸೆಂಬರ್';

  @override
  String get register => 'ನೋಂದಾಯಿಸಿ';

  @override
  String get newToResonate => 'ರೆಸೋನೇಟ್‌ಗೆ ಹೊಸಬರೇ? ';

  @override
  String get alreadyHaveAccount => 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ? ';

  @override
  String get checking => 'ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String get forgotPasswordMessage =>
      'ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ಮರುಹೊಂದಿಸಲು ನಿಮ್ಮ ನೋಂದಾಯಿತ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ.';

  @override
  String get usernameUnavailable => 'ಹೆಸರು ಲಭ್ಯವಿಲ್ಲ!';

  @override
  String get usernameInvalidOrTaken =>
      'ಈ ಹೆಸರು ಅಮಾನ್ಯವಾಗಿದೆ ಅಥವಾ ಈಗಾಗಲೇ ತೆಗೆದುಕೊಳ್ಳಲಾಗಿದೆ.';

  @override
  String get otpResentMessage => 'ಹೊಸ OTP ಗಾಗಿ ದಯವಿಟ್ಟು ನಿಮ್ಮ ಮೇಲ್ ಪರಿಶೀಲಿಸಿ.';

  @override
  String get connectionError =>
      'ಸಂಪರ್ಕ ದೋಷವಿದೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಇಂಟರ್ನೆಟ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get seconds => 'ಸೆಕೆಂಡುಗಳು.';

  @override
  String get unsavedChangesWarning =>
      'ನೀವು ಸೇವ್ ಮಾಡದೆ ಮುಂದುವರಿದರೆ, ಸೇವ್ ಮಾಡದ ಬದಲಾವಣೆಗಳು ಕಳೆದುಹೋಗುತ್ತವೆ.';

  @override
  String get deleteAccountPermanent =>
      'ಈ ಕ್ರಿಯೆ ನಿಮ್ಮ ಖಾತೆಯನ್ನು ಶಾಶ್ವತವಾಗಿ ಅಳಿಸುತ್ತದೆ. ಇದು ಬದಲಾಯಿಸಲಾಗದ ಪ್ರಕ್ರಿಯೆ. ನಾವು ನಿಮ್ಮ ಬಳಕೆದಾರ ಹೆಸರು, ಇಮೇಲ್ ವಿಳಾಸ ಮತ್ತು ನಿಮ್ಮ ಖಾತೆಗೆ ಸಂಬಂಧಿಸಿದ ಎಲ್ಲಾ ಇತರ ಡೇಟಾವನ್ನು ಅಳಿಸುತ್ತೇವೆ. ನೀವು ಅದನ್ನು ಮರುಪಡೆಯಲು ಸಾಧ್ಯವಾಗುವುದಿಲ್ಲ.';

  @override
  String get giveGreatName => 'ಉತ್ತಮ ಹೆಸರು ನೀಡಿ..';

  @override
  String get joinCommunityDescription =>
      'ಕಮ್ಯೂನಿಟಿ ಸೇರುವ ಮೂಲಕ ನೀವು ನಿಮ್ಮ ಸಂದೇಹಗಳನ್ನು ಸ್ಪಷ್ಟಪಡಿಸಬಹುದು, ಹೊಸ ವೈಶಿಷ್ಟ್ಯಗಳಿಗಾಗಿ ಸಲಹೆ ನೀಡಬಹುದು, ನೀವು ಎದುರಿಸಿದ ಸಮಸ್ಯೆಗಳನ್ನು ವರದಿ ಮಾಡಬಹುದು ಮತ್ತು ಇನ್ನಷ್ಟು ಆಯ್ಕೆಗಳು ಲಭ್ಯವಿದೆ.';

  @override
  String get resonateDescription =>
      'ರೆಸೊನೇಟ್ ಒಂದು ಸಾಮಾಜಿಕ ಮಾಧ್ಯಮ ವೇದಿಕೆ — ಇಲ್ಲಿ ಪ್ರತಿಯೊಬ್ಬರ ಧ್ವನಿಗೂ ಮಹತ್ವ ಇದೆ, ನಿಮ್ಮ ಆಲೋಚನೆಗಳು, ಕಥೆಗಳು ಮತ್ತು ಅನುಭವಗಳನ್ನು ಇತರರೊಂದಿಗೆ ಹಂಚಿಕೊಳ್ಳಿ, ಇಗಲೇ ನಿಮ್ಮ ಧ್ವನಿ ಪ್ರಯಾಣವನ್ನು ಪ್ರಾರಂಭಿಸಿ, ವಿವಿಧ ಚರ್ಚೆಗಳು ಮತ್ತು ವಿಷಯಗಳಲ್ಲಿ ಮುಳುಗಿ ನೋಡಿ. ನಿಮ್ಮ ಮನಸ್ಸಿಗೆ ಹತ್ತಿರವಾದ ರೂಮ್ಗಳನ್ನು ಹುಡುಕಿ ಮತ್ತು ಕಮ್ಯೂನಿಟಿಯ ಭಾಗವಾಗಿರಿ.ಈಗಲೇ ಈ ಮಾತುಕತೆಗಳಿಗೆ ಸೇರಿ!, ರೂಮ್ಗಳನ್ನು ಅನ್ವೇಷಿಸಿ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂಪರ್ಕಿಸಿ ಮತ್ತು ನಿಮ್ಮ ಧ್ವನಿಯನ್ನು ವಿಶ್ವದೊಂದಿಗೆ ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String get resonateFullDescription =>
      'ರೆಸೋನೇಟ್ ಒಂದು ಕ್ರಾಂತಿಕಾರಿ ಧ್ವನಿ-ಆಧಾರಿತ ಸಾಮಾಜಿಕ ಮಾಧ್ಯಮ ವೇದಿಕೆಯಾಗಿದ್ದು, ಇಲ್ಲಿ ಪ್ರತಿಯೊಂದು ಧ್ವನಿ ಮಹತ್ವವಾಗಿದೆ. \nಲೈವ್ ಆಡಿಯೋ ಸಂಭಾಷಣೆಗಳಿಗೆ ಸೇರಿ, ವೈವಿಧ್ಯಮಯ ಚರ್ಚೆಗಳಲ್ಲಿ ಭಾಗವಹಿಸಿ, ಮತ್ತು \nಸಮಾನ ಮನಸ್ಸಿನ ವ್ಯಕ್ತಿಗಳೊಂದಿಗೆ ಸಂಪರ್ಕ ಸಾಧಿಸಿ. ನಮ್ಮ ವೇದಿಕೆ ನಿಮಗೆ:\n- ವಿಷಯ-ಆಧಾರಿತ ಚರ್ಚೆಗಳೊಂದಿಗೆ ಲೈವ್ ಆಡಿಯೋ ರೂಮ್‌ಗಳು\n- ಧ್ವನಿಯ ಮೂಲಕ ಸರಾಗವಾದ ಸಾಮಾಜಿಕ ನೆಟ್‌ವರ್ಕಿಂಗ್\n- ಕಮ್ಯೂನಿಟಿ-ನಡೆಸುವ ವಿಷಯ ಮಾಡರೇಶನ್\n- ಕ್ರಾಸ್-ಪ್ಲಾಟ್‌ಫಾರ್ಮ್ ಹೊಂದಾಣಿಕೆ\n- ಎಂಡ್-ಟು-ಎಂಡ್ ಎನ್‌ಕ್ರಿಪ್ಟ್ ಮಾಡಿದ ಖಾಸಗಿ ಸಂಭಾಷಣೆಗಳು\n\nAOSSIE ಓಪನ್ ಸೋರ್ಸ್ ಕಂಮ್ಯುನಿಟಿಯಿಂದ ಅಭಿವೃದ್ಧಿಪಡಿಸಲಾಗಿದೆ, ನಾವು ಬಳಕೆದಾರರ ಗೌಪ್ಯತೆ ಮತ್ತು \nಕಮ್ಯೂನಿಟಿ ನಡೆಸುವ ಅಭಿವೃದ್ಧಿಗೆ ಆದ್ಯತೆ ನೀಡುತ್ತೇವೆ. ಸಾಮಾಜಿಕ ಆಡಿಯೋದ ಭವಿಷ್ಯವನ್ನು ರೂಪಿಸುವಲ್ಲಿ ನಮ್ಮೊಂದಿಗೆ ಸೇರಿ!';

  @override
  String get stable => 'ಸ್ಥಿರ';

  @override
  String get usernameCharacterLimit =>
      'ಬಳಕೆದಾರ ಹೆಸರು 5 ಅಕ್ಷರಗಳಿಗಿಂತ ಹೆಚ್ಚು ಇರಬೇಕು.';

  @override
  String get submit => 'ಸಲ್ಲಿಸಿ';

  @override
  String get anonymous => 'ಅನಾಮಧೇಯ';

  @override
  String get noSearchResults => 'ಫಲಿತಾಂಶಗಳು ಇಲ್ಲ';

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
    return '🚀 ಈ ಅದ್ಭುತ ರೂಮ್ ನೋಡಿ: $roomName!\n\n📖 ವಿವರಣೆ: $description\n👥 ಈಗಲೇ $participants ಭಾಗವಹಿಸುವವರೊಂದಿಗೆ ಸೇರಿ!';
  }

  @override
  String participantsCount(int count) {
    return '$count ಭಾಗವಹಿಸುವವರು';
  }

  @override
  String get join => 'ಸೇರಿ';

  @override
  String get invalidTags => 'ಅಮಾನ್ಯ ಟ್ಯಾಗ್:';

  @override
  String get cropImage => 'ಚಿತ್ರ ಕತ್ತರಿಸಿ';

  @override
  String get profileSavedSuccessfully => 'ಪ್ರೊಫೈಲ್ ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get profileUpdatedSuccessfully =>
      'ಎಲ್ಲಾ ಬದಲಾವಣೆಗಳನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಉಳಿಸಲಾಗಿದೆ.';

  @override
  String get profileUpToDate => 'ಪ್ರೊಫೈಲ್ ನವೀಕೃತವಾಗಿದೆ';

  @override
  String get noChangesToSave =>
      'ಯಾವುದೇ ಹೊಸ ಬದಲಾವಣೆಗಳನ್ನು ಮಾಡಲಾಗಿಲ್ಲ, ಉಳಿಸಲು ಏನೂ ಇಲ್ಲ.';

  @override
  String get connectionFailed => 'ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕ ವಿಫಲವಾಗಿದೆ';

  @override
  String get unableToJoinRoom =>
      'ರೂಮ್‌ಗೆ ಸೇರಲು ಸಾಧ್ಯವಾಗುತ್ತಿಲ್ಲ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ನೆಟ್‌ವರ್ಕ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get connectionLost => 'ಸಂಪರ್ಕ ಕಳೆದುಹೋಗಿದೆ';

  @override
  String get unableToReconnect =>
      'ರೂಮ್‌ಗೆ ಮರುಸಂಪರ್ಕಿಸಲು ಸಾಧ್ಯವಾಗುತ್ತಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಸೇರಲು ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get invalidFormat => 'ಅಮಾನ್ಯ ರೂಪ/ಫಾರ್ಮ್ಯಾಟ್!';

  @override
  String get usernameAlphanumeric =>
      'ಬಳಕೆದಾರ ಹೆಸರಿನಲ್ಲಿ ಇಂಗ್ಲಿಷ್ ಅಕ್ಷರಗಳು ಅಥವಾ ಸಂಖ್ಯೆಗಳು ಇರಬಹುದು ಮತ್ತು ವಿಶೇಷ ಅಕ್ಷರಗಳನ್ನು ಒಳಗೊಂಡಿರಬಾರದು.';

  @override
  String get userProfileCreatedSuccessfully =>
      'ನಿಮ್ಮ ಬಳಕೆದಾರ ಪ್ರೊಫೈಲ್ ಅನ್ನು ಯಶಸ್ವಿಯಾಗಿ ರಚಿಸಲಾಗಿದೆ.';

  @override
  String get emailVerificationMessage =>
      'ಮುಂದುವರೆಯಲು, ನಿಮ್ಮ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ಪರಿಶೀಲಿಸಿ.';

  @override
  String addNewChaptersToStory(String storyName) {
    return '$storyName ಗೆ ಹೊಸ ಅಧ್ಯಾಯಗಳನ್ನು ಸೇರಿಸಿ';
  }

  @override
  String get currentChapters => 'ಪ್ರಸ್ತುತ ಅಧ್ಯಾಯಗಳು';

  @override
  String get sourceCodeOnGitHub => 'GitHub ನಲ್ಲಿ ಸೋರ್ಸ್ ಕೋಡ್';

  @override
  String get createAChapter => 'ಅಧ್ಯಾಯ ರಚಿಸಿ';

  @override
  String get chapterTitle => 'ಅಧ್ಯಾಯದ ಶೀರ್ಷಿಕೆ *';

  @override
  String get aboutRequired => 'ಬಗ್ಗೆ *';

  @override
  String get changeCoverImage => 'ಕವರ್ ಚಿತ್ರ ಬದಲಾಯಿಸಿ';

  @override
  String get uploadAudioFile => 'ಆಡಿಯೋ ಫೈಲ್ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String get uploadLyricsFile => 'ಸಾಹಿತ್ಯ ಫೈಲ್ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String get createChapter => 'ಅಧ್ಯಾಯ ರಚಿಸಿ';

  @override
  String audioFileSelected(String fileName) {
    return 'ಆಡಿಯೋ ಫೈಲ್ ಆಯ್ಕೆಯಾಗಿದೆ: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'ಸಾಹಿತ್ಯ ಫೈಲ್ ಆಯ್ಕೆಯಾಗಿದೆ: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'ದಯವಿಟ್ಟು ಎಲ್ಲಾ ಅಗತ್ಯ ಕ್ಷೇತ್ರಗಳನ್ನು ಭರ್ತಿ ಮಾಡಿ ಮತ್ತು ನಿಮ್ಮ ಆಡಿಯೋ ಫೈಲ್ ಮತ್ತು ಸಾಹಿತ್ಯ ಫೈಲ್ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String get scheduled => 'ನಿಗದಿಪಡಿಸಲಾಗಿದೆ';

  @override
  String get ok => 'ಸರಿ';

  @override
  String get roomDescriptionOptional => 'ರೂಮ್ ವಿವರಣೆ (ಐಚ್ಛಿಕ/optional)';

  @override
  String get deleteAccount => 'ಖಾತೆ ಅಳಿಸಿ';

  @override
  String get createYourStory => 'ನಿಮ್ಮ ಕಥೆ ರಚಿಸಿ';

  @override
  String get titleRequired => 'ಶೀರ್ಷಿಕೆ *';

  @override
  String get category => 'ವರ್ಗ *';

  @override
  String get addChapter => 'ಅಧ್ಯಾಯ ಸೇರಿಸಿ';

  @override
  String get createStory => 'ಕಥೆ ರಚಿಸಿ';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'ದಯವಿಟ್ಟು ಎಲ್ಲಾ ಅಗತ್ಯ ಕ್ಷೇತ್ರಗಳನ್ನು ಭರ್ತಿ ಮಾಡಿ, ಕನಿಷ್ಠ ಒಂದು ಅಧ್ಯಾಯವನ್ನು ಸೇರಿಸಿ ಮತ್ತು ಕವರ್ ಚಿತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get toConfirmType => 'ದೃಢೀಕರಿಸಲು, ಟೈಪ್ ಮಾಡಿ';

  @override
  String get inTheBoxBelow => 'ಕೆಳಗಿನ ಬಾಕ್ಸ್‌ನಲ್ಲಿ';

  @override
  String get iUnderstandDeleteMyAccount =>
      'ನನಗೆ ಅರ್ಥವಾಗಿದೆ, ನನ್ನ ಖಾತೆಯನ್ನು ಅಳಿಸಿ';

  @override
  String get whatDoYouWantToListenTo => 'ನೀವು ಏನನ್ನು ಕೇಳಲು ಬಯಸುತ್ತೀರಿ?';

  @override
  String get categories => 'ವರ್ಗಗಳು';

  @override
  String get stories => 'ಕಥೆಗಳು';

  @override
  String get someSuggestions => 'ಕೆಲವು ಸಲಹೆಗಳು';

  @override
  String get getStarted => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get skip => 'ಬಿಟ್ಟುಬಿಡಿ';

  @override
  String get welcomeToResonate => 'ರೆಸೋನೇಟ್‌ಗೆ ಸ್ವಾಗತ';

  @override
  String get exploreDiverseConversations => 'ವೈವಿಧ್ಯಮಯ ಸಂಭಾಷಣೆಗಳನ್ನು ಅನ್ವೇಷಿಸಿ';

  @override
  String get yourVoiceMatters => 'ನಿಮ್ಮ ಧ್ವನಿ ಮಹತ್ವವಾಗಿದೆ';

  @override
  String get joinConversationExploreRooms =>
      'ಸಂಭಾಷಣೆಗೆ ಸೇರಿ! ರೂಮ್‌ಗಳನ್ನು ಅನ್ವೇಷಿಸಿ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂಪರ್ಕ ಸಾಧಿಸಿ ಮತ್ತು ನಿಮ್ಮ ಧ್ವನಿಯನ್ನು ಜಗತ್ತಿನೊಂದಿಗೆ ಹಂಚಿಕೊಳ್ಳಿ.';

  @override
  String get diveIntoDiverseDiscussions =>
      'ವೈವಿಧ್ಯಮಯ ಚರ್ಚೆಗಳು ಮತ್ತು ವಿಷಯಗಳಲ್ಲಿ ಮುಳುಗಿ. \nನಿಮಗೆ ಹೊಂದಿಕೆಯಾಗುವ ರೂಮ್‌ಗಳನ್ನು ಹುಡುಕಿ ಮತ್ತು ಕಂಮ್ಯುನಿಟಿಯ ಭಾಗವಾಗಿರಿ.';

  @override
  String get atResonateEveryVoiceValued =>
      'ರೆಸೋನೇಟ್‌ನಲ್ಲಿ, ಪ್ರತಿಯೊಂದು ಧ್ವನಿಯನ್ನು ಮೌಲ್ಯೀಕರಿಸಲಾಗುತ್ತದೆ. ನಿಮ್ಮ ಆಲೋಚನೆಗಳು, ಕಥೆಗಳು ಮತ್ತು ಅನುಭವಗಳನ್ನು ಇತರರೊಂದಿಗೆ ಹಂಚಿಕೊಳ್ಳಿ. ಈಗಲೇ ನಿಮ್ಮ ಆಡಿಯೋ ಪ್ರಯಾಣವನ್ನು ಪ್ರಾರಂಭಿಸಿ.';

  @override
  String get notifications => 'ಮೆಸೇಜ್ಗಳು';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username ನಿಮ್ಮನ್ನು ಮುಂಬರುವ ರೂಮ್‌ನಲ್ಲಿ ಟ್ಯಾಗ್ ಮಾಡಿದ್ದಾರೆ: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username ನಿಮ್ಮನ್ನು ರೂಮ್‌ನಲ್ಲಿ ಟ್ಯಾಗ್ ಮಾಡಿದ್ದಾರೆ: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username ನಿಮ್ಮ ಕಥೆಯನ್ನು ಇಷ್ಟಪಟ್ಟಿದ್ದಾರೆ: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username ನಿಮ್ಮ ರೂಮ್‌ಗೆ ಸಬ್‌ಸ್ಕ್ರೈಬರಾಗಿದ್ದಾರೆ: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username ನಿಮ್ಮನ್ನು ಫಾಲೋ ಮಾಡುತ್ತಿದ್ದಾರೆ';
  }

  @override
  String get youHaveNewNotification => 'ನಿಮಗೆ ಹೊಸ ಮೆಸೇಜ್ ಇದೆ';

  @override
  String get hangOnGoodThingsTakeTime =>
      'ತಾಳ್ಮೆಯಿಂದಿರಿ, ಉತ್ತಮ ವಿಷಯಗಳಿಗೆ ಸಮಯ ಬೇಕು 🔍';

  @override
  String get resonateOpenSourceProject =>
      'ರೆಸೋನೇಟ್ AOSSIE ನಿರ್ವಹಿಸುವ ಓಪನ್ ಸೋರ್ಸ್ ಪ್ರಾಜೆಕ್ಟ್ ಆಗಿದೆ.ನಿಮ್ಮ ಕೊಡುಗೆ ನೀಡಲು ನಮ್ಮ github ನೋಡಿ.';

  @override
  String get mute => 'ಮ್ಯೂಟ್';

  @override
  String get speakerLabel => 'ಮಾತನಾಡುವವರು';

  @override
  String get audioOptions => 'Audio Options';

  @override
  String get end => 'ಮುಗಿಸಿ';

  @override
  String get saveChanges => 'ಬದಲಾವಣೆಗಳನ್ನು ಉಳಿಸಿ';

  @override
  String get discard => 'ತ್ಯಜಿಸಿ';

  @override
  String get save => 'ಉಳಿಸಿ';

  @override
  String get changeProfilePicture => 'ಪ್ರೊಫೈಲ್ ಚಿತ್ರ ಬದಲಾಯಿಸಿ';

  @override
  String get camera => 'ಕ್ಯಾಮೆರಾ';

  @override
  String get gallery => 'ಗ್ಯಾಲರಿ';

  @override
  String get remove => 'ತೆಗೆದುಹಾಕಿ';

  @override
  String created(String date) {
    return 'ರಚಿಸಲಾಗಿದೆ $date';
  }

  @override
  String get chapters => 'ಅಧ್ಯಾಯಗಳು';

  @override
  String get deleteStory => 'ಕಥೆ ಅಳಿಸಿ';

  @override
  String createdBy(String creatorName) {
    return 'ರಚಿಸಿರುವವವರು $creatorName';
  }

  @override
  String get start => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get unsubscribe => 'ಅನ್‌ಸಬ್‌ಸ್ಕ್ರೈಬ್';

  @override
  String get subscribe => 'ಸಬ್‌ಸ್ಕ್ರೈಬ್';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'ನಾಟಕ',
      'comedy': 'ಹಾಸ್ಯ',
      'horror': 'ಭಯಾನಕ',
      'romance': 'ಪ್ರಣಯ',
      'thriller': 'ರೋಮಾಂಚಕ',
      'spiritual': 'ಆಧ್ಯಾತ್ಮಿಕ',
      'other': 'ಇತರೆ',
    });
    return '$_temp0';
  }

  @override
  String chooseTheme(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'classicTheme': 'ಕ್ಲಾಸಿಕ್',
      'timeTheme': 'ಟೈಮ್',
      'vintageTheme': 'ವಿಂಟೇಜ್',
      'amberTheme': 'ಆಂಬರ್',
      'forestTheme': 'ಫಾರೆಸ್ಟ್',
      'creamTheme': 'ಕ್ರೀಮ್',
      'other': 'ಇತರೆ',
    });
    return '$_temp0';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ನಿಮಿಷಗಳ ಹಿಂದೆ',
      one: '1 ನಿಮಿಷದ ಹಿಂದೆ',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಗಂಟೆಗಳ ಹಿಂದೆ',
      one: '1 ಗಂಟೆ ಹಿಂದೆ',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ದಿನಗಳ ಹಿಂದೆ',
      one: '1 ದಿನದ ಹಿಂದೆ',
    );
    return '$_temp0';
  }

  @override
  String get by => 'ರಿಂದ';

  @override
  String get likes => 'ಲೈಕ್‌ಗಳು';

  @override
  String get lengthMinutes => 'ನಿಮಿಷ';

  @override
  String get requiredField => 'ಈ ಕ್ಷೇತ್ರ ಭರ್ತಿಮಾಡಿ';

  @override
  String get onlineUsers => 'ಆನ್‌ಲೈನ್ ಬಳಕೆದಾರರು';

  @override
  String get noOnlineUsers => 'ಪ್ರಸ್ತುತ ಯಾವುದೇ ಬಳಕೆದಾರರು ಆನ್‌ಲೈನ್‌ನಲ್ಲಿ ಇಲ್ಲ';

  @override
  String get chooseUser => 'ಚಾಟ್ ಮಾಡಲು ಬಳಕೆದಾರರನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get quickMatch => 'ಕ್ವಿಕ್ ಮ್ಯಾಚ್';

  @override
  String get story => 'ಕಥೆ';

  @override
  String get user => 'ಬಳಕೆದಾರ';

  @override
  String get following => 'ಫಾಲೋವಿಂಗ್';

  @override
  String get followers => 'ಫಾಲ್ಲೋವರ್ಸ್';

  @override
  String get friendRequests => 'ಸ್ನೇಹಿತರ ವಿನಂತಿಗಳು';

  @override
  String get friendRequestSent => 'ಸ್ನೇಹಿತರ ವಿನಂತಿ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String friendRequestSentTo(String username) {
    return '$username ಗೆ ನಿಮ್ಮ ಸ್ನೇಹಿತರ ವಿನಂತಿ ಕಳುಹಿಸಲಾಗಿದೆ.';
  }

  @override
  String get friendRequestCancelled => 'ಸ್ನೇಹಿತರ ವಿನಂತಿ ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String friendRequestCancelledTo(String username) {
    return '$username ಗೆ ನಿಮ್ಮ ಸ್ನೇಹಿತರ ವಿನಂತಿ ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ.';
  }

  @override
  String get requested => 'ವಿನಂತಿಸಲಾಗಿದೆ';

  @override
  String get friends => 'ಸ್ನೇಹಿತರು';

  @override
  String get addFriend => 'ಸ್ನೇಹಿತರನ್ನು ಸೇರಿಸಿ';

  @override
  String get friendRequestAccepted => 'ಸ್ನೇಹಿತರ ವಿನಂತಿ ಸ್ವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'ನೀವು ಈಗ $username ಜೊತೆ ಸ್ನೇಹಿತರಾಗಿದ್ದೀರಿ.';
  }

  @override
  String get friendRequestDeclined => 'ಸ್ನೇಹಿತರ ವಿನಂತಿ ನಿರಾಕರಿಸಲಾಗಿದೆ';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'ನೀವು $username ರಿಂದ ಸ್ನೇಹಿತರ ವಿನಂತಿಯನ್ನು ನಿರಾಕರಿಸಿದ್ದೀರಿ.';
  }

  @override
  String get accept => 'ಸ್ವೀಕರಿಸಿ';

  @override
  String get callDeclined => 'ಕರೆ ನಿರಾಕರಿಸಲಾಗಿದೆ';

  @override
  String callDeclinedTo(String username) {
    return 'ಬಳಕೆದಾರ $username ಕರೆಯನ್ನು ನಿರಾಕರಿಸಿದ್ದಾರೆ.';
  }

  @override
  String get checkForUpdates => 'ಅಪ್ಡೇಟ್ಸ್‌ಗಳನ್ನು ಪರಿಶೀಲಿಸಿ';

  @override
  String get updateNow => 'ಈಗಲೇ ನವೀಕರಿಸಿ';

  @override
  String get updateLater => 'ನಂತರ';

  @override
  String get updateSuccessful => 'ಅಪ್ಡೇಟ್ಸ್ ಯಶಸ್ವಿಯಾಗಿದೆ';

  @override
  String get updateSuccessfulMessage =>
      'ರೆಸೋನೇಟ್ ಅನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಅಪ್ಡೇಟ್ಸ್ ಮಾಡಲಾಗಿದೆ!';

  @override
  String get updateCancelled => 'ಅಪ್ಡೇಟ್ಸ್ ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get updateCancelledMessage => 'ಬಳಕೆದಾರರಿಂದ ಅಪ್ಡೇಟ್ಸ್ ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get updateFailed => 'ಅಪ್ಡೇಟ್ಸ್ ವಿಫಲವಾಗಿದೆ';

  @override
  String get updateFailedMessage =>
      'ಅಪ್ಡೇಟ್ಸ್ ವಿಫಲವಾಗಿದೆ. ದಯವಿಟ್ಟು ಪ್ಲೇ ಸ್ಟೋರ್ ನಿಂದ ಅಪ್ಡೇಟ್ಸ್ ಮಾಡಲು ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get updateError => 'ಅಪ್ಡೇಟ್ಸ್ ದೋಷ';

  @override
  String get updateErrorMessage =>
      'ಅಪ್ಡೇಟ್ಸ್ ಮಾಡುವಾಗ ದೋಷ ಸಂಭವಿಸಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get platformNotSupported => 'ಪ್ಲಾಟ್‌ಫಾರ್ಮ್ ಸಪೋರ್ಟ್ ಮಾಡುತ್ತಿಲ್ಲ';

  @override
  String get platformNotSupportedMessage =>
      'ಅಪ್ಡೇಟ್ಸ್ ಪರಿಶೀಲನೆ ಆಂಡ್ರಾಯ್ಡ್ ಸಾಧನಗಳಲ್ಲಿ ಮಾತ್ರ ಲಭ್ಯವಿದೆ';

  @override
  String get updateCheckFailed => 'ಅಪ್ಡೇಟ್ಸ್ ಪರಿಶೀಲನೆ ವಿಫಲವಾಗಿದೆ';

  @override
  String get updateCheckFailedMessage =>
      'ಅಪ್ಡೇಟ್ಸ್‌ಗಳನ್ನ ಪರಿಶೀಲಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get upToDateTitle => 'ನೀವು ಅಪ್ಡೇಟೆಡ್ ಆಗಿದ್ದೀರಿ!';

  @override
  String get upToDateMessage =>
      'ನೀವು ರೆಸೋನೇಟ್‌ನ ಇತ್ತೀಚಿನ ವರ್ಷನನ್ನು ಬಳಸುತ್ತಿದ್ದೀರಿ';

  @override
  String get updateAvailableTitle => 'ಅಪ್ಡೇಟ್ ಲಭ್ಯವಿದೆ!';

  @override
  String get updateAvailableMessage =>
      'ರೆಸೋನೇಟ್‌ನ ಹೊಸ ವರ್ಷನ್ ಪ್ಲೇ ಸ್ಟೋರ್ ನಲ್ಲಿ ಲಭ್ಯವಿದೆ';

  @override
  String get updateFeaturesImprovement =>
      'ಇತ್ತೀಚಿನ ವೈಶಿಷ್ಟ್ಯಗಳು ಮತ್ತು ಸುಧಾರಣೆಗಳನ್ನು ಪಡೆಯಿರಿ!';

  @override
  String get failedToRemoveRoom => 'Failed to remove room';

  @override
  String get roomRemovedSuccessfully =>
      'Room removed from your list successfully';

  @override
  String get alert => 'ಎಚ್ಚರಿಕೆ';

  @override
  String get removedFromRoom =>
      'ನಿಮ್ಮನ್ನು ವರದಿ ಮಾಡಲಾಗಿದೆ ಅಥವಾ ರೂಮ್‌ನಿಂದ ತೆಗೆದುಹಾಕಲಾಗಿದೆ';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'ಕಿರುಕುಳ / ದ್ವೇಷದ ಭಾಷಣ',
      'abuse': 'ನಿಂದನೀಯ ವಿಷಯ / ಹಿಂಸೆ',
      'spam': 'ಸ್ಪ್ಯಾಮ್ / ವಂಚನೆಗಳು / ಮೋಸ',
      'impersonation': 'ವ್ಯಕ್ತಿತ್ವ ಸೋಗು / ನಕಲಿ ಖಾತೆಗಳು',
      'illegal': 'ಕಾನೂನುಬಾಹಿರ ಚಟುವಟಿಕೆಗಳು',
      'selfharm': 'ಆತ್ಮಹಾನಿ / ಆತ್ಮಹತ್ಯೆ / ಮಾನಸಿಕ ಆರೋಗ್ಯ',
      'misuse': 'ವೇದಿಕೆಯ ದುರುಪಯೋಗ',
      'other': 'ಇತರೆ',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate =>
      'ನೀವು ಬಳಕೆದಾರರಿಂದ ಅನೇಕ ವರದಿಗಳನ್ನು ಸ್ವೀಕರಿಸಿದ್ದೀರಿ ಮತ್ತು ರೆಸೋನೇಟ್ ಬಳಸುವುದರಿಂದ ನಿಮ್ಮನ್ನು ನಿರ್ಬಂಧಿಸಲಾಗಿದೆ. ಇದರಲ್ಲಿ ಏನೋ ತಪ್ಪಿದೆ ಎಂದು ನೀವು ನಂಬಿದರೆ ದಯವಿಟ್ಟು AOSSIE ಅನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get reportParticipant => 'ಭಾಗವಹಿಸುವವರನ್ನು ವರದಿ ಮಾಡಿ';

  @override
  String get selectReportType => 'ದಯವಿಟ್ಟು ವರದಿ ಪ್ರಕಾರವನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get reportSubmitted => 'ವರದಿ ಯಶಸ್ವಿಯಾಗಿ ಸಲ್ಲಿಸಲಾಗಿದೆ';

  @override
  String get reportFailed => 'ವರದಿ ಸಲ್ಲಿಕೆ ವಿಫಲವಾಗಿದೆ';

  @override
  String get additionalDetailsOptional => 'ಹೆಚ್ಚುವರಿ ವಿವರಗಳು (ಐಚ್ಛಿಕ)';

  @override
  String get submitReport => 'ವರದಿ ಸಲ್ಲಿಸಿ';

  @override
  String get actionBlocked => 'ಕ್ರಿಯೆ ನಿರ್ಬಂಧಿಸಲಾಗಿದೆ';

  @override
  String get cannotStopRecording =>
      'ನೀವು ರೆಕಾರ್ಡಿಂಗ್ ಅನ್ನು ನಿಲ್ಲಿಸಲು ಸಾಧ್ಯವಿಲ್ಲ, ರೂಮ್ ಮುಚ್ಚಿದಾಗ ರೆಕಾರ್ಡಿಂಗ್ ನಿಲ್ಲುತ್ತದೆ.';

  @override
  String get liveChapter => 'ಲೈವ್ ಅಧ್ಯಾಯ';

  @override
  String get viewOrEditLyrics => 'ಸಾಹಿತ್ಯ ನೋಡಿ ಅಥವಾ ಎಡಿಟ್ ಮಾಡಿ';

  @override
  String get close => 'ಮುಚ್ಚಿ';

  @override
  String get verifyChapterDetails => 'ಅಧ್ಯಾಯ ವಿವರಗಳನ್ನು ಪರಿಶೀಲಿಸಿ';

  @override
  String get author => 'ಲೇಖಕ';

  @override
  String get startLiveChapter => 'ಲೈವ್ ಅಧ್ಯಾಯ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get fillAllFields => 'ದಯವಿಟ್ಟು ಎಲ್ಲಾ ಅಗತ್ಯ ಕ್ಷೇತ್ರಗಳನ್ನು ಭರ್ತಿ ಮಾಡಿ';

  @override
  String get noRecordingError =>
      'ನೀವು ಅಧ್ಯಾಯಕ್ಕಾಗಿ ಏನನ್ನೂ ರೆಕಾರ್ಡ್ ಮಾಡಿಲ್ಲ. ದಯವಿಟ್ಟು ರೂಮ್‌ನಿಂದ ನಿರ್ಗಮಿಸುವ ಮೊದಲು ಅಧ್ಯಾಯವನ್ನು ರೆಕಾರ್ಡ್ ಮಾಡಿ';

  @override
  String get audioOutput => 'Audio Output';

  @override
  String get selectPreferredSpeaker => 'Select your preferred speaker';

  @override
  String get noAudioOutputDevices => 'No audio output devices detected';

  @override
  String get refresh => 'Refresh';

  @override
  String get done => 'Done';

  @override
  String get deleteMessageTitle => 'Delete Message';

  @override
  String get deleteMessageContent =>
      'Are you sure you want to delete this message?';

  @override
  String get thisMessageWasDeleted => 'This message was deleted';

  @override
  String get failedToDeleteMessage => 'Failed to delete message';

  @override
  String get usernameInvalidFormat =>
      'Please enter a valid username. Only letters, numbers, dots, underscores, and hyphens are allowed.';

  @override
  String get usernameAlreadyTaken =>
      'This username is already taken. Try a different one.';

  @override
  String get networkError =>
      'Please check your internet connection and try again.';

  @override
  String get authenticationError => 'Authentication failed. Please try again.';

  @override
  String get storageError => 'Failed to save or load data. Please try again.';

  @override
  String get databaseError => 'Failed to access data. Please try again.';

  @override
  String get validationError => 'Please check your input and try again.';

  @override
  String get generalError => 'Something went wrong. Please try again.';

  @override
  String get authError => 'Authentication Error';

  @override
  String get invalidInput => 'Invalid Input';

  @override
  String get userAlreadyExists => 'An account with this email already exists.';

  @override
  String get userNotFound => 'User not found.';

  @override
  String get dataNotFound => 'The requested data was not found.';
}
