// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get title => 'ਰੇਜ਼ੋਨੇਟ';

  @override
  String get roomDescription =>
      'ਵਿਨਮ੍ਰ ਰਹੋ ਅਤੇ ਦੂਜੇ ਵਿਅਕਤੀ ਦੀ ਰਾਏ ਦਾ ਆਦਰ ਕਰੋ। ਅਪਮਾਨਜਨਕ ਟਿੱਪਣੀਆਂ ਤੋਂ ਬਚੋ।';

  @override
  String get hidePassword => 'ਪਾਸਵਰਡ ਲੁਕਾਓ';

  @override
  String get showPassword => 'ਪਾਸਵਰਡ ਦਿਖਾਓ';

  @override
  String get passwordEmpty => 'ਪਾਸਵਰਡ ਖਾਲੀ ਨਹੀਂ ਹੋ ਸਕਦਾ';

  @override
  String get password => 'ਪਾਸਵਰਡ';

  @override
  String get confirmPassword => 'ਪਾਸਵਰਡ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ';

  @override
  String get passwordsNotMatch => 'ਪਾਸਵਰਡ ਮਿਲਦੇ ਨਹੀਂ ਹਨ';

  @override
  String get userCreatedStories => 'ਯੂਜ਼ਰ ਵਲੋਂ ਬਣਾਈਆਂ ਕਹਾਣੀਆਂ';

  @override
  String get yourStories => 'ਤੁਹਾਡੀਆਂ ਕਹਾਣੀਆਂ';

  @override
  String get userNoStories => 'ਯੂਜ਼ਰ ਨੇ ਹਾਲੇ ਕੋਈ ਕਹਾਣੀ ਨਹੀਂ ਬਣਾਈ';

  @override
  String get youNoStories => 'ਤੁਸੀਂ ਹਾਲੇ ਕੋਈ ਕਹਾਣੀ ਨਹੀਂ ਬਣਾਈ';

  @override
  String get follow => 'ਫਾਲो ਕਰੋ';

  @override
  String get editProfile => 'ਪ੍ਰੋਫਾਈਲ ਐਡਿਟ ਕਰੋ';

  @override
  String get verifyEmail => 'ਈਮੇਲ ਵੇਰੀਫਾਈ ਕਰੋ';

  @override
  String get verified => 'ਵੇਰੀਫਾਈਡ';

  @override
  String get profile => 'ਪ੍ਰੋਫਾਈਲ';

  @override
  String get userLikedStories => 'ਯੂਜ਼ਰ ਨੂੰ ਪਸੰਦ ਆਈਆਂ ਕਹਾਣੀਆਂ';

  @override
  String get yourLikedStories => 'ਤੁਹਾਨੂੰ ਪਸੰਦ ਆਈਆਂ ਕਹਾਣੀਆਂ';

  @override
  String get userNoLikedStories => 'ਯੂਜ਼ਰ ਨੇ ਹਾਲੇ ਕੋਈ ਕਹਾਣੀ ਲਾਈਕ ਨਹੀਂ ਕੀਤੀ';

  @override
  String get youNoLikedStories => 'ਤੁਸੀਂ ਹਾਲੇ ਕੋਈ ਕਹਾਣੀ ਲਾਈਕ ਨਹੀਂ ਕੀਤੀ';

  @override
  String get live => 'ਲਾਈਵ';

  @override
  String get upcoming => 'ਆਉਣ ਵਾਲਾ';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'ਕੋਈ ਰੂਮ ਉਪਲਬਧ ਨਹੀਂ ਹੈ',
      'false': 'ਕੋਈ ਆਉਣ ਵਾਲਾ ਰੂਮ ਉਪਲਬਧ ਨਹੀਂ ਹੈ',
      'other': 'ਰੂਮ ਦੀ ਜਾਣਕਾਰੀ ਉਪਲਬਧ ਨਹੀਂ ਹੈ',
    });
    return '$_temp0\nਹੇਠਾਂ ਤੋਂ ਇੱਕ ਰੂਮ ਬਣਾਕੇ ਸ਼ੁਰੂਆਤ ਕਰੋ!';
  }

  @override
  String get user1 => 'ਯੂਜ਼ਰ 1';

  @override
  String get user2 => 'ਯੂਜ਼ਰ 2';

  @override
  String get you => 'ਤੁਸੀਂ';

  @override
  String get areYouSure => 'ਕੀ ਤੁਸੀਂ ਪੱਕੇ ਹੋ?';

  @override
  String get loggingOut => 'ਤੁਸੀਂ ਰੇਜ਼ੋਨੇਟ ਤੋਂ ਲੌਗ ਆਉਟ ਹੋ ਰਹੇ ਹੋ।';

  @override
  String get yes => 'ਹਾਂ';

  @override
  String get no => 'ਨਹੀਂ';

  @override
  String get incorrectEmailOrPassword => 'ਈਮੇਲ ਜਾਂ ਪਾਸਵਰਡ ਗਲਤ ਹੈ';

  @override
  String get passwordShort => 'ਪਾਸਵਰਡ 8 ਅੱਖਰ ਤੋਂ ਛੋਟਾ ਹੈ';

  @override
  String get tryAgain => 'ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ!';

  @override
  String get success => 'ਸਫਲਤਾ';

  @override
  String get passwordResetSent => 'ਪਾਸਵਰਡ ਰੀਸੈਟ ਈਮੇਲ ਭੇਜੀ ਗਈ!';

  @override
  String get error => 'ਗਲਤੀ';

  @override
  String get resetPassword => 'ਪਾਸਵਰਡ ਰੀਸੈਟ ਕਰੋ';

  @override
  String get enterNewPassword => 'ਨਵਾਂ ਪਾਸਵਰਡ ਦਾਖਲ ਕਰੋ';

  @override
  String get newPassword => 'ਨਵਾਂ ਪਾਸਵਰਡ';

  @override
  String get setNewPassword => 'ਨਵਾਂ ਪਾਸਵਰਡ ਸੈੱਟ ਕਰੋ';

  @override
  String get emailChanged => 'ਈਮੇਲ ਬਦਲ ਦਿੱਤੀ ਗਈ';

  @override
  String get emailChangeSuccess => 'ਈਮੇਲ ਸਫਲਤਾਪੂਰਵਕ ਬਦਲ ਗਈ!';

  @override
  String get failed => 'ਅਸਫਲ';

  @override
  String get emailChangeFailed => 'ਈਮੇਲ ਬਦਲਣ ਵਿੱਚ ਅਸਫਲ';

  @override
  String get oops => 'ਉਫ਼!';

  @override
  String get emailExists => 'ਈਮੇਲ ਪਹਿਲਾਂ ਤੋਂ ਮੌਜੂਦ ਹੈ';

  @override
  String get changeEmail => 'ਈਮੇਲ ਬਦਲੋ';

  @override
  String get enterValidEmail => 'ਕਿਰਪਾ ਕਰਕੇ ਇੱਕ ਵੈਧ ਈਮੇਲ ਦਾਖਲ ਕਰੋ';

  @override
  String get newEmail => 'ਨਵੀਂ ਈਮੇਲ';

  @override
  String get currentPassword => 'ਮੌਜੂਦਾ ਪਾਸਵਰਡ';

  @override
  String get emailChangeInfo =>
      'ਸੁਰੱਖਿਆ ਲਈ, ਈਮੇਲ ਬਦਲਣ ਲਈ ਮੌਜੂਦਾ ਪਾਸਵਰਡ ਦਾਖਲ ਕਰੋ। ਬਦਲਣ ਤੋਂ ਬਾਅਦ, ਨਵੀਂ ਈਮੇਲ ਨਾਲ ਲੌਗਿਨ ਕਰੋ।';

  @override
  String get oauthUsersMessage =>
      '(ਕੇਵਲ ਗੂਗਲ ਜਾਂ ਗਿਥੁਬ ਨਾਲ ਲੌਗਿਨ ਕਰਨ ਵਾਲੇ ਯੂਜ਼ਰਾਂ ਲਈ)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'ਈਮੇਲ ਬਦਲਣ ਲਈ, \"ਮੌਜੂਦਾ ਪਾਸਵਰਡ\" ਫੀਲਡ ਵਿੱਚ ਨਵਾਂ ਪਾਸਵਰਡ ਦਾਖਲ ਕਰੋ। ਇਸ ਨੂੰ ਯਾਦ ਰੱਖੋ—ਅੱਗੇ ਕੇਵਲ ਗੂਗਲ/ਗਿਥੁਬ ਜਾਂ ਨਵੇਂ ਪਾਸਵਰਡ ਨਾਲ ਲੌਗਿਨ ਹੋਵੇਗਾ।';

  @override
  String get resonateTagline => 'ਗੱਲਾਂ ਦੀ ਇੱਕ ਅਨੰਤ ਦੁਨੀਆ ਵਿੱਚ ਕਦਮ ਰੱਖੋ';

  @override
  String get signInWithEmail => 'ਈਮੇਲ ਨਾਲ ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String get or => 'ਜਾਂ';

  @override
  String get continueWith => 'ਇਨ੍ਹਾਂ ਵਿੱਚੋਂ ਕਿਸੇ ਇੱਕ ਨਾਲ ਲੌਗਿਨ ਕਰੋ';

  @override
  String get continueWithGoogle => 'ਗੂਗਲ ਨਾਲ ਲੌਗਿਨ ਕਰੋ';

  @override
  String get continueWithGitHub => 'ਗਿਥੁਬ ਨਾਲ ਲੌਗਿਨ ਕਰੋ';

  @override
  String get resonateLogo => 'ਰੇਜ਼ੋਨੇਟ ਲੋਗੋ';

  @override
  String get iAlreadyHaveAnAccount => 'ਮੇਰੇ ਕੋਲ ਪਹਿਲਾਂ ਤੋਂ ਇੱਕ ਅਕਾਊਂਟ ਹੈ';

  @override
  String get createNewAccount => 'ਨਵਾਂ ਅਕਾਊਂਟ ਬਣਾਓ';

  @override
  String get userProfile => 'ਯੂਜ਼ਰ ਪ੍ਰੋਫਾਈਲ';

  @override
  String get passwordIsStrong => 'ਪਾਸਵਰਡ ਮਜ਼ਬੂਤ ਹੈ';

  @override
  String get admin => 'ਐਡਮਿਨ';

  @override
  String get moderator => 'ਮੋਡਰੇਟਰ';

  @override
  String get speaker => 'ਸਪੀਕਰ';

  @override
  String get listener => 'ਲਿਸਨਰ';

  @override
  String get removeModerator => 'ਮੋਡਰੇਟਰ ਹਟਾਓ';

  @override
  String get kickOut => 'ਕਿਕ ਆਉਟ ਕਰੋ';

  @override
  String get addModerator => 'ਮੋਡਰੇਟਰ ਜੋੜੋ';

  @override
  String get addSpeaker => 'ਸਪੀਕਰ ਜੋੜੋ';

  @override
  String get makeListener => 'ਲਿਸਨਰ ਬਣਾਓ';

  @override
  String get pairChat => 'ਪੇਅਰ ਚੈਟ';

  @override
  String get chooseIdentity => 'ਪਛਾਣ ਚੁਣੋ';

  @override
  String get selectLanguage => 'ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String get noConnection => 'ਕੋਈ ਕਨੈਕਸ਼ਨ ਨਹੀਂ';

  @override
  String get loadingDialog => 'ਲੋਡ ਹੋ ਰਿਹਾ ਹੈ...';

  @override
  String get createAccount => 'ਅਕਾਊਂਟ ਬਣਾਓ';

  @override
  String get enterValidEmailAddress => 'ਵੈਧ ਈਮੇਲ ਪਤਾ ਦਾਖਲ ਕਰੋ';

  @override
  String get email => 'ਈਮੇਲ';

  @override
  String get passwordRequirements => 'ਪਾਸਵਰਡ ਘੱਟੋ-ਘੱਟ 8 ਅੱਖਰ ਦਾ ਹੋਣਾ ਚਾਹੀਦਾ ਹੈ';

  @override
  String get includeNumericDigit => 'ਘੱਟੋ-ਘੱਟ 1 ਸੰਖਿਆ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get includeUppercase => 'ਘੱਟੋ-ਘੱਟ 1 ਵੱਡਾ ਅੱਖਰ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get includeLowercase => 'ਘੱਟੋ-ਘੱਟ 1 ਛੋਟਾ ਅੱਖਰ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get includeSymbol => 'ਘੱਟੋ-ਘੱਟ 1 ਚਿੰਨ੍ਹ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get signedUpSuccessfully => 'ਸਫਲਤਾਪੂਰਵਕ ਸਾਈਨ ਅੱਪ ਹੋ ਗਿਆ!';

  @override
  String get newAccountCreated => 'ਤੁਹਾਡਾ ਨਵਾਂ ਅਕਾਊਂਟ ਸਫਲਤਾਪੂਰਵਕ ਬਣ ਗਿਆ ਹੈ';

  @override
  String get signUp => 'ਸਾਈਨ ਅੱਪ';

  @override
  String get login => 'ਲੌਗਿਨ';

  @override
  String get settings => 'ਸੈਟਿੰਗਜ਼';

  @override
  String get accountSettings => 'ਅਕਾਊਂਟ ਸੈਟਿੰਗਜ਼';

  @override
  String get account => 'ਅਕਾਊਂਟ';

  @override
  String get appSettings => 'ਐਪ ਸੈਟਿੰਗਜ਼';

  @override
  String get themes => 'ਥੀਮਜ਼';

  @override
  String get about => 'ਰੇਜ਼ੋਨੇਟ ਬਾਰੇ';

  @override
  String get other => 'ਹੋਰ';

  @override
  String get contribute => 'ਯੋਗਦਾਨ ਕਰੋ';

  @override
  String get appPreferences => 'ਐਪ ਪਸੰਦ';

  @override
  String get transcriptionModel => 'ਟ੍ਰਾਂਸਕ੍ਰਿਪਸ਼ਨ ਮਾਡਲ';

  @override
  String get transcriptionModelDescription =>
      'ਵਾਇਸ ਟ੍ਰਾਂਸਕ੍ਰਿਪਸ਼ਨ ਲਈ AI ਮਾਡਲ ਚੁਣੋ। ਵੱਡੇ ਮਾਡਲ ਵਧੇਰੇ ਸਟੀਕ ਹਨ ਪਰ ਹੌਲੇ ਹਨ ਅਤੇ ਵਧੇਰੇ ਸਟੋਰੇਜ ਦੀ ਲੋੜ ਹੁੰਦੀ ਹੈ।';

  @override
  String get whisperModelTiny => 'ਟਾਈਨੀ';

  @override
  String get whisperModelTinyDescription => 'ਸਭ ਤੋਂ ਤੇਜ਼, ਘੱਟ ਸਟੀਕ (~39 MB)';

  @override
  String get whisperModelBase => 'ਬੇਸ';

  @override
  String get whisperModelBaseDescription => 'ਸੰਤੁਲਿਤ ਗਤੀ ਅਤੇ ਸਟੀਕਤਾ (~74 MB)';

  @override
  String get whisperModelSmall => 'ਸਮਾਲ';

  @override
  String get whisperModelSmallDescription => 'ਚੰਗੀ ਸਟੀਕਤਾ, ਹੌਲਾ (~244 MB)';

  @override
  String get whisperModelMedium => 'ਮੀਡੀਅਮ';

  @override
  String get whisperModelMediumDescription => 'ਉੱਚ ਸਟੀਕਤਾ, ਹੌਲਾ (~769 MB)';

  @override
  String get whisperModelLargeV1 => 'ਲਾਰਜ V1';

  @override
  String get whisperModelLargeV1Description =>
      'ਸਭ ਤੋਂ ਵਧੇਰੇ ਸਟੀਕ, ਸਭ ਤੋਂ ਹੌਲਾ (~1.55 GB)';

  @override
  String get whisperModelLargeV2 => 'ਲਾਰਜ V2';

  @override
  String get whisperModelLargeV2Description =>
      'ਉੱਚ ਸਟੀਕਤਾ ਨਾਲ ਵਧੀਆ ਵੱਡਾ ਮਾਡਲ (~1.55 GB)';

  @override
  String get modelDownloadInfo =>
      'ਮਾਡਲ ਪਹਿਲੀ ਵਾਰ ਵਰਤਣ \'ਤੇ ਡਾਊਨਲੋਡ ਹੋ ਜਾਂਦੇ ਹਨ। ਅਸੀਂ ਬੇਸ, ਸਮਾਲ ਜਾਂ ਮੀਡੀਅਮ ਵਰਤਣ ਦੀ ਸਿਫਾਰਸ਼ ਕਰਦੇ ਹਾਂ। ਵੱਡੇ ਮਾਡਲ ਲਈ ਬਹੁਤ ਉੱਚ-ਅੰਤ ਡਿਵਾਈਸ ਦੀ ਲੋੜ ਹੁੰਦੀ ਹੈ।';

  @override
  String get logOut => 'ਲੌਗ ਆਉਟ';

  @override
  String get participants => 'ਭਾਗੀਦਾਰ';

  @override
  String get delete => 'ਡਿਲੀਟ';

  @override
  String get leave => 'ਛੱਡੋ';

  @override
  String get leaveButton => 'ਛੱਡੋ';

  @override
  String get findingRandomPartner => 'ਤੁਹਾਡੇ ਲਈ ਇੱਕ ਰੈਂਡਮ ਭਾਗੀਦਾਰ ਲੱਭ ਰਹੇ ਹਾਂ';

  @override
  String get quickFact => 'ਤੁਰੰਤ ਤੱਥ';

  @override
  String get cancel => 'ਕੈਂਸਲ';

  @override
  String get hide => 'ਲੁਕਾਓ';

  @override
  String get removeRoom => 'ਰੂਮ ਹਟਾਓ';

  @override
  String get removeRoomFromList => 'ਲਿਸਟ ਤੋਂ ਰੂਮ ਹਟਾਓ';

  @override
  String get removeRoomConfirmation => 'ਕੀ ਤੁਸੀਂ ਇਹ ਰੂਮ ਹਟਾਉਣਾ ਚਾਹੁੰਦੇ ਹੋ?';

  @override
  String get completeYourProfile => 'ਆਪਣੀ ਪ੍ਰੋਫਾਈਲ ਪੂਰੀ ਕਰੋ';

  @override
  String get uploadProfilePicture => 'ਪ੍ਰੋਫਾਈਲ ਪਿਕਚਰ ਅੱਪਲੋਡ ਕਰੋ';

  @override
  String get enterValidName => 'ਵੈਧ ਨਾਮ ਦਾਖਲ ਕਰੋ';

  @override
  String get name => 'ਨਾਮ';

  @override
  String get username => 'ਯੂਜ਼ਰਨੇਮ';

  @override
  String get enterValidDOB => 'ਠੀक ਜਨਮ ਤਾਰੀਖ ਦਾਖਲ ਕਰੋ';

  @override
  String get dateOfBirth => 'ਜਨਮ ਤਾਰੀਖ';

  @override
  String get forgotPassword => 'ਪਾਸਵਰਡ ਭੁੱਲ ਗਏ?';

  @override
  String get next => 'ਅੱਗੇ';

  @override
  String get noStoriesExist => 'ਕੋਈ ਕਹਾਣੀ ਹਾਲੇ ਮੌਜੂਦ ਨਹੀਂ ਹੈ';

  @override
  String get enterVerificationCode => 'ਆਪਣਾ\nਵੇਰੀਫਿਕੇਸ਼ਨ ਕੋਡ ਦਾਖਲ ਕਰੋ';

  @override
  String get verificationCodeSent => 'ਅਸੀਂ 6-ਅੰਕਾਂ ਦਾ ਕੋਡ ਭੇਜਿਆ ਹੈ\n';

  @override
  String get verificationComplete => 'ਵੇਰੀਫਿਕੇਸ਼ਨ ਪੂਰਾ ਹੋ ਗਿਆ';

  @override
  String get verificationCompleteMessage =>
      'ਵਧਾਈ ਹੋ! ਤੁਹਾਡੀ ਈਮੇਲ ਵੇਰੀਫਾਈ ਹੋ ਗਈ ਹੈ';

  @override
  String get verificationFailed => 'ਵੇਰੀਫਿਕੇਸ਼ਨ ਅਸਫਲ ਹੋ ਗਿਆ';

  @override
  String get otpMismatch => 'OTP ਮਿਲਦਾ ਨਹੀਂ, ਕਿਰਪਾ ਕਰਕੇ ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get otpResent => 'OTP ਮੁੜ ਭੇਜਿਆ ਗਿਆ';

  @override
  String get requestNewCode => 'ਨਵਾਂ ਕੋਡ ਮੰਗੋ';

  @override
  String get requestNewCodeIn => 'ਨਵਾਂ ਕੋਡ ਮੰਗਣ ਲਈ ਉਡੀਕ ਕਰੋ';

  @override
  String get clickPictureCamera => 'ਕੈਮਰਾ ਨਾਲ ਫੋਟੋ ਲਓ';

  @override
  String get pickImageGallery => 'ਗੈਲਰੀ ਤੋਂ ਚਿੱਤਰ ਚੁਣੋ';

  @override
  String get deleteMyAccount => 'ਮੇਰਾ ਅਕਾਊਂਟ ਹਟਾਓ';

  @override
  String get createNewRoom => 'ਨਵਾਂ ਰੂਮ ਬਣਾਓ';

  @override
  String get pleaseEnterScheduledDateTime =>
      'ਕਿਰਪਾ ਕਰਕੇ ਨਿਰਧਾਰਤ ਤਾਰੀਖ ਅਤੇ ਸਮਾਂ ਦਾਖਲ ਕਰੋ';

  @override
  String get scheduleDateTimeLabel => 'ਨਿਰਧਾਰਤ ਤਾਰੀਖ ਅਤੇ ਸਮਾਂ';

  @override
  String get enterTags => 'ਟੈਗ ਦਾਖਲ ਕਰੋ';

  @override
  String get joinCommunity => 'ਕਮਿਊਨਿਟੀ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਵੋ';

  @override
  String get followUsOnX => 'X \'ਤੇ ਸਾਡਾ ਪਾਲਣਾ ਕਰੋ';

  @override
  String get joinDiscordServer => 'Discord ਸਰਵਰ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਵੋ';

  @override
  String get noLyrics => 'ਕੋਈ ਲਿਰਿਕਸ ਨਹੀਂ';

  @override
  String noStoriesInCategory(String categoryName) {
    return '$categoryName ਸ਼੍ਰੇਣੀ ਵਿੱਚ ਕੋਈ ਕਹਾਣੀ ਨਹੀਂ';
  }

  @override
  String get newChapters => 'ਨਵੇਂ ਅਧਿਆਇ';

  @override
  String get helpToGrow => 'ਵਧਣ ਵਿੱਚ ਮਦਦ ਕਰੋ';

  @override
  String get share => 'ਸਾਂਝਾ ਕਰੋ';

  @override
  String get rate => 'ਰੇਟ ਕਰੋ';

  @override
  String get aboutResonate => 'ਰੇਜ਼ੋਨੇਟ ਬਾਰੇ';

  @override
  String get description => 'ਵਰਣਨ';

  @override
  String get confirm => 'ਪੁਸ਼ਟੀ ਕਰੋ';

  @override
  String get classic => 'ਕਲਾਸਿਕ';

  @override
  String get time => 'ਸਮਾਂ';

  @override
  String get vintage => 'ਵਿੰਟੇਜ';

  @override
  String get amber => 'ਐਂਬਰ';

  @override
  String get forest => 'ਫਾਰਸਟ';

  @override
  String get cream => 'ਕਰੀਮ';

  @override
  String get none => 'ਕੋਈ ਨਹੀਂ';

  @override
  String checkOutGitHub(String url) {
    return 'ਸਾਡਾ GitHub ਰੈਪੋ ਦੇਖੋ: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'AOSSIE ਲੋਗੋ';

  @override
  String get errorLoadPackageInfo => 'ਪੈਕੇਜ ਜਾਣਕਾਰੀ ਲੋਡ ਕਰਨ ਵਿੱਚ ਗਲਤੀ';

  @override
  String get searchFailed => 'ਖੋਜ ਅਸਫਲ ਰਹੀ';

  @override
  String get updateAvailable => 'ਅੱਪਡੇਟ ਉਪਲਬਧ ਹੈ';

  @override
  String get newVersionAvailable => 'ਨਵਾਂ ਵਰਜਨ ਉਪਲਬਧ ਹੈ';

  @override
  String get upToDate => 'ਅੱਪ-ਟੂ-ਡੇਟ';

  @override
  String get latestVersion => 'ਨਵਾਂ ਵਰਜਨ';

  @override
  String get profileCreatedSuccessfully => 'ਪ੍ਰੋਫਾਈਲ ਸਫਲਤਾਪੂਰਵਕ ਬਣਾਈ ਗਈ';

  @override
  String get invalidScheduledDateTime => 'ਅਵੈਧ ਨਿਰਧਾਰਤ ਤਾਰੀਖ/ਸਮਾਂ';

  @override
  String get scheduledDateTimePast => 'ਨਿਰਧਾਰਤ ਤਾਰੀਖ/ਸਮਾਂ ਪਿਛਲੇ ਸਮੇਂ ਵਿੱਚ ਹੈ';

  @override
  String get joinRoom => 'ਰੂਮ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਵੋ';

  @override
  String get unknownUser => 'ਅਣਜਾਣ ਯੂਜ਼ਰ';

  @override
  String get canceled => 'ਰੱਦ ਕੀਤਾ ਗਿਆ';

  @override
  String get english => 'ਅੰਗਰੇਜ਼ੀ';

  @override
  String get emailVerificationRequired => 'ਈਮੇਲ ਵੈਰੀਫਿਕੇਸ਼ਨ ਲਾਜ਼ਮੀ ਹੈ';

  @override
  String get verify => 'ਵੇਰੀਫਾਈ ਕਰੋ';

  @override
  String get audioRoom => 'ਆਡੀਓ ਰੂਮ';

  @override
  String toRoomAction(String action) {
    return 'ਰੂਮ ਨੂੰ $action ਕਰਨ ਲਈ';
  }

  @override
  String get mailSentMessage => 'ਮੇਲ ਭੇਜੀ ਗਈ';

  @override
  String get disconnected => 'ਡਿਸਕਨੈਕਟ ਕੀਤਾ ਗਿਆ';

  @override
  String get micOn => 'ਮਾਈਕ ਚਾਲੂ';

  @override
  String get speakerOn => 'ਸਪੀਕਰ ਚਾਲੂ';

  @override
  String get endChat => 'ਚੈਟ ਖਤਮ ਕਰੋ';

  @override
  String get monthJan => 'ਜਨਵਰੀ';

  @override
  String get monthFeb => 'ਫਰਵਰੀ';

  @override
  String get monthMar => 'ਮਾਰਚ';

  @override
  String get monthApr => 'ਅਪ੍ਰੈਲ';

  @override
  String get monthMay => 'ਮਈ';

  @override
  String get monthJun => 'ਜੂਨ';

  @override
  String get monthJul => 'ਜੁਲਾਈ';

  @override
  String get monthAug => 'ਅਗਸਤ';

  @override
  String get monthSep => 'ਸਤੰਬਰ';

  @override
  String get monthOct => 'ਅਕਤੂਬਰ';

  @override
  String get monthNov => 'ਨਵੰਬਰ';

  @override
  String get monthDec => 'ਦਸੰਬਰ';

  @override
  String get register => 'ਰਜਿਸਟਰ ਕਰੋ';

  @override
  String get newToResonate => 'ਰੇਜ਼ੋਨੇਟ ਲਈ ਨਵੇਂ ਹੋ?';

  @override
  String get alreadyHaveAccount => 'ਪਹਿਲਾਂ ਤੋਂ ਅਕਾਊਂਟ ਹੈ?';

  @override
  String get checking => 'ਚੈੱਕ ਕੀਤਾ ਜਾ ਰਿਹਾ ਹੈ...';

  @override
  String get forgotPasswordMessage => 'ਪਾਸਵਰਡ ਭੁੱਲ ਗਏ?';

  @override
  String get usernameUnavailable => 'ਯੂਜ਼ਰਨੇਮ ਉਪਲਬਧ ਨਹੀਂ ਹੈ';

  @override
  String get usernameInvalidOrTaken =>
      'ਯੂਜ਼ਰਨੇਮ ਗਲਤ ਜਾਂ ਪਹਿਲਾਂ ਤੋਂ ਲਿਆ ਹੋਇਆ ਹੈ';

  @override
  String get otpResentMessage => 'OTP ਮੁੜ ਭੇਜਿਆ ਗਿਆ';

  @override
  String get connectionError => 'ਕਨੈਕਸ਼ਨ ਵਿੱਚ ਗਲਤੀ';

  @override
  String get seconds => 'ਸਕਿੰਟ';

  @override
  String get unsavedChangesWarning => 'ਅਸੁਰੱਖਿਅਤ ਤਬਦੀਲੀਆਂ ਚੇਤਾਵਨੀ';

  @override
  String get deleteAccountPermanent => 'ਅਕਾਊਂਟ ਸਥਾਈ ਤੌਰ \'ਤੇ ਹਟਾਓ';

  @override
  String get giveGreatName => 'ਵਧੀਆ ਨਾਮ ਦਿਓ';

  @override
  String get joinCommunityDescription =>
      'ਰੇਜ਼ੋਨੇਟ ਕਮਿਊਨਿਟੀ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਵੋ ਅਤੇ ਵਧੋ!';

  @override
  String get resonateDescription =>
      'ਰੇਜ਼ੋਨੇਟ ਇੱਕ ਸੋਸ਼ਲ ਮੀਡੀਆ ਪਲੇਟਫਾਰਮ ਹੈ, ਜਿੱਥੇ ਹਰ ਆਵਾਜ਼ ਦੀ ਕਦਰ ਕੀਤੀ ਜਾਂਦੀ ਹੈ। ਆਪਣੇ ਵਿਚਾਰ, ਕਹਾਣੀਆਂ ਅਤੇ ਤਜ਼ਰਬੇ ਹੋਰਾਂ ਨਾਲ ਸਾਂਝੇ ਕਰੋ। ਆਪਣੀ ਆਡੀਓ ਯਾਤਰਾ ਹੁਣ ਸ਼ੁਰੂ ਕਰੋ। ਵੱਖ-ਵੱਖ ਚਰਚਾਵਾਂ ਅਤੇ ਵਿਸ਼ਿਆਂ ਵਿੱਚ ਡੁੱਬੋ। ਉਹ ਰੂਮ ਲੱਭੋ ਜੋ ਤੁਹਾਡੇ ਨਾਲ ਗੂੰਝਦੇ ਹਨ ਅਤੇ ਕਮਿਊਨਿਟੀ ਦਾ ਹਿੱਸਾ ਬਣੋ। ਗੱਲਬਾਤ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਵੋ! ਰੂਮ ਖੋਜੋ, ਦੋਸਤਾਂ ਨਾਲ ਜੁੜੋ, ਅਤੇ ਦੁਨੀਆਂ ਨਾਲ ਆਪਣੀ ਆਵਾਜ਼ ਸਾਂਝੀ ਕਰੋ।';

  @override
  String get resonateFullDescription => 'ਰੇਜ਼ੋਨੇਟ - ਗੱਲਾਂ ਦੀ ਦੁਨੀਆ!';

  @override
  String get stable => 'ਸਥਿਰ';

  @override
  String get usernameCharacterLimit => 'ਯੂਜ਼ਰਨੇਮ ਅੱਖਰ ਸੀਮਾ';

  @override
  String get submit => 'ਸਬਮਿਟ ਕਰੋ';

  @override
  String get anonymous => 'ਅਗਿਆਤ';

  @override
  String get noSearchResults => 'ਕੋਈ ਖੋਜ ਨਤੀਜੇ ਨਹੀਂ';

  @override
  String get searchRooms => 'ਰੂਮ ਖੋਜੋ';

  @override
  String get searchingRooms => 'ਰੂਮ ਖੋਜੇ ਜਾ ਰਹੇ ਹਨ...';

  @override
  String get clearSearch => 'ਖੋਜ ਸਾਫ਼ ਕਰੋ';

  @override
  String get searchError => 'ਖੋਜ ਵਿੱਚ ਗਲਤੀ';

  @override
  String get searchRoomsError => 'ਰੂਮ ਖੋਜਣ ਵਿੱਚ ਗਲਤੀ';

  @override
  String get searchUpcomingRoomsError => 'ਆਉਣ ਵਾਲੇ ਰੂਮ ਖੋਜਣ ਵਿੱਚ ਗਲਤੀ';

  @override
  String get search => 'ਖੋਜੋ';

  @override
  String get clear => 'ਸਾਫ਼ ਕਰੋ';

  @override
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  ) {
    return 'ਇਸ ਸ਼ਾਨਦਾਰ ਰੂਮ ਨੂੰ ਦੇਖੋ: $roomName!\n\n📖 ਵੇਰਵਾ: $description\n👥 ਹੁਣੇ $participants ਲੋਕ ਜੁੜ ਚੁੱਕੇ ਹਨ!';
  }

  @override
  String participantsCount(int count) {
    return '$count ਭਾਗੀਦਾਰ';
  }

  @override
  String get join => 'ਸ਼ਾਮਲ ਹੋਵੋ';

  @override
  String get invalidTags => 'ਅਵੈਧ ਟੈਗ';

  @override
  String get cropImage => 'ਚਿੱਤਰ ਕੱਟੋ';

  @override
  String get profileSavedSuccessfully => 'ਪ੍ਰੋਫਾਈਲ ਸਫਲਤਾਪੂਰਵਕ ਸੰਭਾਲੀ ਗਈ';

  @override
  String get profileUpdatedSuccessfully => 'ਪ੍ਰੋਫਾਈਲ ਸਫਲਤਾਪੂਰਵਕ ਅੱਪਡੇਟ ਹੋਈ';

  @override
  String get profileUpToDate => 'ਪ੍ਰੋਫਾਈਲ ਅੱਪ-ਟੂ-ਡੇਟ ਹੈ';

  @override
  String get noChangesToSave => 'ਸੰਭਾਲਣ ਲਈ ਕੋਈ ਤਬਦੀਲੀਆਂ ਨਹੀਂ';

  @override
  String get connectionFailed => 'ਕਨੈਕਸ਼ਨ ਅਸਫਲ';

  @override
  String get unableToJoinRoom => 'ਰੂਮ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਣ ਵਿੱਚ ਅਸਮਰਥ';

  @override
  String get connectionLost => 'ਕਨੈਕਸ਼ਨ ਖਤਮ ਹੋ ਗਿਆ';

  @override
  String get unableToReconnect => 'ਮੁੜ-ਕਨੈਕਟ ਕਰਨ ਵਿੱਚ ਅਸਮਰਥ';

  @override
  String get invalidFormat => 'ਅਵੈਧ ਫਾਰਮੈਟ';

  @override
  String get usernameAlphanumeric => 'ਯੂਜ਼ਰਨੇਮ ਅਲਫਾ-ਨਿਊਮੈਰਿਕ ਹੋਣਾ ਚਾਹੀਦਾ ਹੈ';

  @override
  String get userProfileCreatedSuccessfully =>
      'ਯੂਜ਼ਰ ਪ੍ਰੋਫਾਈਲ ਸਫਲਤਾਪੂਰਵਕ ਬਣਾਈ ਗਈ';

  @override
  String get emailVerificationMessage => 'ਈਮੇਲ ਵੈਰੀਫਿਕੇਸ਼ਨ ਸੁਨੇਹਾ';

  @override
  String addNewChaptersToStory(String storyName) {
    return '$storyName ਵਿੱਚ ਨਵੇਂ ਅਧਿਆਇ ਜੋੜੋ';
  }

  @override
  String get currentChapters => 'ਮੌਜੂਦਾ ਅਧਿਆਇ';

  @override
  String get sourceCodeOnGitHub => 'ਗਿਥੁਬ ਤੇ ਸਰੋਤ ਕੋਡ';

  @override
  String get createAChapter => 'ਅਧਿਆਇ ਬਣਾਓ';

  @override
  String get chapterTitle => 'ਅਧਿਆਇ ਸਿਰਲੇਖ';

  @override
  String get aboutRequired => '\'ਬਾਰੇ\' ਲਾਜ਼ਮੀ ਹੈ';

  @override
  String get changeCoverImage => 'ਕਵਰ ਚਿੱਤਰ ਬਦਲੋ';

  @override
  String get uploadAudioFile => 'ਆਡੀਓ ਫਾਈਲ ਅੱਪਲੋਡ ਕਰੋ';

  @override
  String get uploadLyricsFile => 'ਲਿਰਿਕਸ ਫਾਈਲ ਅੱਪਲੋਡ ਕਰੋ';

  @override
  String get createChapter => 'ਅਧਿਆਇ ਬਣਾਓ';

  @override
  String audioFileSelected(String fileName) {
    return 'ਆਡੀਓ ਫਾਈਲ ਚੁਣੀ ਗਈ';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'ਲਿਰਿਕਸ ਫਾਈਲ ਚੁਣੀ ਗਈ';
  }

  @override
  String get fillAllRequiredFields => 'ਸਾਰੇ ਲਾਜ਼ਮੀ ਖੇਤਰ ਭਰੋ';

  @override
  String get scheduled => 'ਨਿਰਧਾਰਤ';

  @override
  String get ok => 'ਠੀਕ ਹੈ';

  @override
  String get roomDescriptionOptional => 'ਰੂਮ ਵਰਣਨ ਵਿਕਲਪਿਕ ਹੈ';

  @override
  String get deleteAccount => 'ਅਕਾਊਂਟ ਹਟਾਓ';

  @override
  String get createYourStory => 'ਆਪਣੀ ਕਹਾਣੀ ਬਣਾਓ';

  @override
  String get titleRequired => 'ਸਿਰਲੇਖ ਲਾਜ਼ਮੀ ਹੈ';

  @override
  String get category => 'ਸ਼੍ਰੇਣੀ';

  @override
  String get addChapter => 'ਅਧਿਆਇ ਜੋੜੋ';

  @override
  String get createStory => 'ਕਹਾਣੀ ਬਣਾਓ';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'ਸਾਰੇ ਲਾਜ਼ਮੀ ਖੇਤਰ ਅਤੇ ਅਧਿਆਇ ਭਰੋ';

  @override
  String get toConfirmType => 'ਪੁਸ਼ਟੀ ਕਰਨ ਲਈ ਟਾਈਪ ਕਰੋ';

  @override
  String get inTheBoxBelow => 'ਹੇਠਾਂ ਵਾਲੇ ਬਾਕਸ ਵਿੱਚ';

  @override
  String get iUnderstandDeleteMyAccount =>
      'ਮੈਂ ਸਮਝਦਾ ਹਾਂ ਕਿ ਮੇਰਾ ਅਕਾਊਂਟ ਹਟਾ ਦਿੱਤਾ ਜਾਵੇਗਾ';

  @override
  String get whatDoYouWantToListenTo => 'ਤੁਸੀਂ ਕੀ ਸੁਣਨਾ ਚਾਹੁੰਦੇ ਹੋ?';

  @override
  String get categories => 'ਸ਼੍ਰੇਣੀਆਂ';

  @override
  String get stories => 'ਕਹਾਣੀਆਂ';

  @override
  String get someSuggestions => 'ਕੁਝ ਸੁਝਾਵ';

  @override
  String get getStarted => 'ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get skip => 'ਛੱਡੋ';

  @override
  String get welcomeToResonate => 'ਰੇਜ਼ੋਨੇਟ ਵਿੱਚ ਤੁਹਾਡਾ ਸੁਆਗਤ ਹੈ';

  @override
  String get exploreDiverseConversations => 'ਵੱਖ-ਵੱਖ ਗੱਲਬਾਤਾਂ ਦੀ ਖੋਜ ਕਰੋ';

  @override
  String get yourVoiceMatters => 'ਤੁਹਾਡੀ ਆਵਾਜ਼ ਮਹੱਤਵਪੂਰਨ ਹੈ';

  @override
  String get joinConversationExploreRooms => 'ਗੱਲਬਾਤ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਵੋ, ਰੂਮ ਖੋਜੋ';

  @override
  String get diveIntoDiverseDiscussions => 'ਵੱਖ-ਵੱਖ ਚਰਚਾਵਾਂ ਵਿੱਚ ਡੁੱਬੋ';

  @override
  String get atResonateEveryVoiceValued =>
      'ਰੇਜ਼ੋਨੇਟ \'ਤੇ ਹਰ ਆवਾਜ਼ ਦੀ ਕਦਰ ਕੀਤੀ ਜਾਂਦੀ ਹੈ';

  @override
  String get notifications => 'ਨੋਟੀਫਿਕੇਸ਼ਨ';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username ਨੇ ਤੁਹਾਨੂੰ ਇੱਕ ਆਉਣ ਵਾਲੇ ਰੂਮ ਵਿੱਚ ਟੈਗ ਕੀਤਾ: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username ਨੇ ਤੁਹਾਨੂੰ ਇੱਕ ਰੂਮ ਵਿੱਚ ਟੈਗ ਕੀਤਾ: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username ਨੇ ਤੁਹਾਡੀ ਕਹਾਣੀ ਨੂੰ ਪਸੰਦ ਕੀਤਾ: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username ਨੇ ਤੁਹਾਡੇ ਰੂਮ ਨੂੰ ਸਬਸਕ੍ਰਾਈਬ ਕੀਤਾ: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username ਨੇ ਤੁਹਾਨੂੰ ਫਾਲੋ ਕਰਨਾ ਸ਼ੁਰੂ ਕੀਤਾ';
  }

  @override
  String get youHaveNewNotification => 'ਤੁਹਾਨੂੰ ਨਵੀਂ ਨੋਟੀਫਿਕੇਸ਼ਨ ਮਿਲੀ ਹੈ';

  @override
  String get hangOnGoodThingsTakeTime =>
      'ਇੰਤਜ਼ਾਰ ਕਰੋ, ਚੰਗੀਆਂ ਚੀਜ਼ਾਂ ਸਮਾਂ ਲੈਂਦੀਆਂ ਹਨ';

  @override
  String get resonateOpenSourceProject => 'ਰੇਜ਼ੋਨੇਟ ਖੁੱਲਾ ਸਰੋਤ ਪ੍ਰੋਜੈਕਟ ਹੈ';

  @override
  String get mute => 'ਮਿਊਟ';

  @override
  String get speakerLabel => 'ਸਪੀਕਰ';

  @override
  String get end => 'ਅੰਤ';

  @override
  String get saveChanges => 'ਤਬਦੀਲੀਆਂ ਸੰਭਾਲੋ';

  @override
  String get discard => 'ਅਣਡਿੱਠਾ ਕਰੋ';

  @override
  String get save => 'ਸੰਭਾਲੋ';

  @override
  String get changeProfilePicture => 'ਪ੍ਰੋਫਾਈਲ ਚਿੱਤਰ ਬਦਲੋ';

  @override
  String get camera => 'ਕੈਮਰਾ';

  @override
  String get gallery => 'ਗੈਲਰੀ';

  @override
  String get remove => 'ਹਟਾਓ';

  @override
  String created(String date) {
    return 'ਬਣਾਇਆ ਗਿਆ: $date';
  }

  @override
  String get chapters => 'ਅਧਿਆਇ';

  @override
  String get deleteStory => 'ਕਹਾਣੀ ਹਟਾਓ';

  @override
  String createdBy(String creatorName) {
    return '$creatorName ਦੁਆਰਾ ਬਣਾਇਆ ਗਿਆ';
  }

  @override
  String get start => 'ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get unsubscribe => 'ਅਣ-ਸਬਸਕ੍ਰਾਈਬ ਕਰੋ';

  @override
  String get subscribe => 'ਸਬਸਕ੍ਰਾਈਬ ਕਰੋ';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'ਨਾਟਕ',
      'comedy': 'ਹਾਸਿਆਸਪਦ',
      'horror': 'ਭਿਆਨਕ',
      'romance': 'ਰੋਮਾਂਟਿਕ',
      'thriller': 'ਥ੍ਰਿਲਰ',
      'spiritual': 'ਆਧਿਆਤਮਿਕ',
      'other': 'ਹੋਰ',
    });
    return '$_temp0';
  }

  @override
  String chooseTheme(String category) {
    return 'ਥੀਮ ਚੁਣੋ';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਮਿੰਟ ਪਹਿਲਾਂ',
      one: '1 ਮਿੰਟ ਪਹਿਲਾਂ',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਘੰਟੇ ਪਹਿਲਾਂ',
      one: '1 ਘੰਟਾ ਪਹਿਲਾਂ',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਦਿਨ ਪਹਿਲਾਂ',
      one: '1 ਦਿਨ ਪਹਿਲਾਂ',
    );
    return '$_temp0';
  }

  @override
  String get by => 'ਦੁਆਰਾ';

  @override
  String get likes => 'ਪਸੰਦ';

  @override
  String get lengthMinutes => 'ਮਿੰਟ ਲੰਬਾਈ';

  @override
  String get requiredField => 'ਲਾਜ਼ਮੀ ਖੇਤਰ';

  @override
  String get onlineUsers => 'ਆਨਲਾਈਨ ਯੂਜ਼ਰ';

  @override
  String get noOnlineUsers => 'ਕੋਈ ਆਨਲਾਈਨ ਯੂਜ਼ਰ ਨਹੀਂ';

  @override
  String get chooseUser => 'ਯੂਜ਼ਰ ਚੁਣੋ';

  @override
  String get quickMatch => 'ਤੁਰੰਤ ਮੇਲ';

  @override
  String get story => 'ਕਹਾਣੀ';

  @override
  String get user => 'ਯੂਜ਼ਰ';

  @override
  String get following => 'ਫਾਲੋ ਕਰ ਰਹੇ ਹੋ';

  @override
  String get followers => 'ਫਾਲੋਅਰ';

  @override
  String get friendRequests => 'ਦੋਸਤ ਅਰਜ਼ੀਆਂ';

  @override
  String get friendRequestSent => 'ਦੋਸਤ ਅਰਜ਼ੀ ਭੇਜੀ ਗਈ';

  @override
  String friendRequestSentTo(String username) {
    return 'ਤੁਹਾਡੀ ਦੋਸਤ ਅਰਜ਼ੀ $username ਨੂੰ ਭੇਜੀ ਗਈ ਹੈ';
  }

  @override
  String get friendRequestCancelled => 'ਦੋਸਤ ਅਰਜ਼ੀ ਰੱਦ ਕੀਤੀ ਗਈ';

  @override
  String friendRequestCancelledTo(String username) {
    return 'ਤੁਹਾਡੀ $username ਨੂੰ ਭੇਜੀ ਦੋਸਤ ਅਰਜ਼ੀ ਰੱਦ ਕਰ ਦਿੱਤੀ ਗਈ ਹੈ';
  }

  @override
  String get requested => 'ਅਰਜ਼ੀ ਕੀਤੀ';

  @override
  String get friends => 'ਦੋਸਤ';

  @override
  String get addFriend => 'ਦੋਸਤ ਜੋੜੋ';

  @override
  String get friendRequestAccepted => 'ਦੋਸਤ ਅਰਜ਼ੀ ਮਨਜ਼ੂਰ ਹੋਈ';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'ਤੁਸੀਂ $username ਦੀ ਦੋਸਤ ਅਰਜ਼ੀ ਮਨਜ਼ੂਰ ਕਰ ਲਈ ਹੈ';
  }

  @override
  String get friendRequestDeclined => 'ਦੋਸਤ ਅਰਜ਼ੀ ਅਸਵੀਕਾਰ ਕੀਤੀ ਗਈ';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'ਤੁਸੀਂ $username ਦੀ ਦੋਸਤ ਅਰਜ਼ੀ ਅਸਵੀਕਾਰ ਕਰ ਦਿੱਤੀ ਹੈ';
  }

  @override
  String get accept => 'ਮਨਜ਼ੂਰ ਕਰੋ';

  @override
  String get callDeclined => 'ਕਾਲ ਅਸਵੀਕਾਰ ਕੀਤੀ ਗਈ';

  @override
  String callDeclinedTo(String username) {
    return '$username ਨੇ ਕਾਲ ਅਸਵੀਕਾਰ ਕਰ ਦਿੱਤੀ';
  }

  @override
  String get checkForUpdates => 'ਅੱਪਡੇਟ ਲਈ ਚੈੱਕ ਕਰੋ';

  @override
  String get updateNow => 'ਹੁਣ ਅੱਪਡੇਟ ਕਰੋ';

  @override
  String get updateLater => 'ਬਾਅਦ ਵਿੱਚ ਅੱਪਡੇਟ ਕਰੋ';

  @override
  String get updateSuccessful => 'ਅੱਪਡੇਟ ਸਫਲ';

  @override
  String get updateSuccessfulMessage => 'ਅੱਪਡੇਟ ਸਫਲਤਾਪੂਰਵਕ ਹੋ ਗਿਆ';

  @override
  String get updateCancelled => 'ਅੱਪਡੇਟ ਰੱਦ ਕੀਤਾ ਗਿਆ';

  @override
  String get updateCancelledMessage => 'ਅੱਪਡੇਟ ਰੱਦ ਹੋ ਗਿਆ';

  @override
  String get updateFailed => 'ਅੱਪਡੇਟ ਅਸਫਲ';

  @override
  String get updateFailedMessage => 'ਅੱਪਡੇਟ ਅਸਫਲ ਹੋ ਗਿਆ';

  @override
  String get updateError => 'ਅੱਪਡੇਟ ਵਿੱਚ ਗਲਤੀ';

  @override
  String get updateErrorMessage => 'ਅੱਪਡੇਟ ਵਿੱਚ ਗਲਤੀ ਆਈ';

  @override
  String get platformNotSupported => 'ਪਲੇਟਫਾਰਮ ਸਹਾਇਕ ਨਹੀਂ ਹੈ';

  @override
  String get platformNotSupportedMessage => 'ਇਹ ਪਲੇਟਫਾਰਮ ਸਹਾਇਕ ਨਹੀਂ ਹੈ';

  @override
  String get updateCheckFailed => 'ਅੱਪਡੇਟ ਚੈੱਕ ਅਸਫਲ';

  @override
  String get updateCheckFailedMessage => 'ਅੱਪਡੇਟ ਚੈੱਕ ਕਰਨ ਵਿੱਚ ਅਸਫਲਤਾ';

  @override
  String get upToDateTitle => 'ਅੱਪ-ਟੂ-ਡੇਟ';

  @override
  String get upToDateMessage => 'ਐਪ ਅੱਪ-ਟੂ-ਡੇਟ ਹੈ';

  @override
  String get updateAvailableTitle => 'ਅੱਪਡੇਟ ਉਪਲਬਧ';

  @override
  String get updateAvailableMessage => 'ਨਵਾਂ ਅੱਪਡੇਟ ਉਪਲਬਧ ਹੈ';

  @override
  String get updateFeaturesImprovement => 'ਅੱਪਡੇਟ ਵਿਸ਼ੇਸ਼ਤਾਵਾਂ ਅਤੇ ਸੁਧਾਰ';

  @override
  String get failedToRemoveRoom => 'ਰੂਮ ਹਟਾਉਣ ਵਿੱਚ ਅਸਫਲ';

  @override
  String get roomRemovedSuccessfully => 'ਰੂਮ ਸਫਲਤਾਪੂਰਵਕ ਹਟਾਇਆ ਗਿਆ';

  @override
  String get alert => 'ਚੇਤਾਵਨੀ';

  @override
  String get removedFromRoom => 'ਰੂਮ ਤੋਂ ਹਟਾਇਆ ਗਿਆ';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'ਪਰੇਸ਼ਾਨੀ / ਨਫ਼ਰਤ ਭਰਿਆ ਭਾਸ਼ਣ',
      'abuse': 'ਅਪਮਾਨਜਨਕ ਸਮੱਗਰੀ / ਹਿੰਸਾ',
      'spam': 'ਸਪੈਮ / ਘੁਟਾਲੇ / ਧੋਖਾਧੜੀ',
      'impersonation': 'ਰੂਪ ਬਦਲਣਾ / ਜਾਅਲੀ ਖਾਤੇ',
      'illegal': 'ਗੈਰ-ਕਾਨੂੰਨੀ ਗਤੀਵਿਧੀਆਂ',
      'selfharm': 'ਆਤਮ-ਹੱਤਿਆ / ਖੁਦਕੁਸ਼ੀ / ਮਾਨਸਿਕ ਸਿਹਤ',
      'misuse': 'ਪਲੇਟਫਾਰਮ ਦੀ ਦੁਰਵਰਤੋਂ',
      'other': 'ਹੋਰ',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate => 'ਰੇਜ਼ੋਨੇਟ ਤੋਂ ਯੂਜ਼ਰ ਬਲੌਕ ਕੀਤਾ ਗਿਆ';

  @override
  String get reportParticipant => 'ਭਾਗੀਦਾਰ ਦੀ ਰਿਪੋਰਟ ਕਰੋ';

  @override
  String get selectReportType => 'ਰਿਪੋਰਟ ਕਿਸਮ ਚੁਣੋ';

  @override
  String get reportSubmitted => 'ਰਿਪੋਰਟ ਜਮ੍ਹਾਂ ਹੋਈ';

  @override
  String get reportFailed => 'ਰਿਪੋਰਟ ਅਸਫਲ';

  @override
  String get additionalDetailsOptional => 'ਵਾਧੂ ਵੇਰਵੇ ਵਿਕਲਪਿਕ ਹਨ';

  @override
  String get submitReport => 'ਰਿਪੋਰਟ ਜਮ੍ਹਾਂ ਕਰੋ';

  @override
  String get actionBlocked => 'ਕਾਰਵਾਈ ਰੋਕੀ ਗਈ';

  @override
  String get cannotStopRecording => 'ਰਿਕਾਰਡਿੰਗ ਰੋਕੀ ਨਹੀਂ ਜਾ ਸਕਦੀ';

  @override
  String get liveChapter => 'ਲਾਈਵ ਅਧਿਆਇ';

  @override
  String get viewOrEditLyrics => 'ਲਿਰਿਕਸ ਵੇਖੋ ਜਾਂ ਐਡਿਟ ਕਰੋ';

  @override
  String get close => 'ਬੰਦ ਕਰੋ';

  @override
  String get verifyChapterDetails => 'ਅਧਿਆਇ ਵੇਰਵੇ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ';

  @override
  String get author => 'ਲੇਖਕ';

  @override
  String get startLiveChapter => 'ਲਾਈਵ ਅਧਿਆਇ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get fillAllFields => 'ਸਾਰੇ ਖੇਤਰ ਭਰੋ';

  @override
  String get noRecordingError =>
      'ਤੁਸੀਂ ਇਸ ਅਧਿਆਇ ਲਈ ਕੁਝ ਵੀ ਰਿਕਾਰਡ ਨਹੀਂ ਕੀਤਾ। ਕਿਰਪਾ ਕਰਕੇ ਰੂਮ ਬੰਦ ਕਰਨ ਤੋਂ ਪਹਿਲਾਂ ਰਿਕਾਰਡ ਕਰੋ';

  @override
  String get audioOutput => 'ਆਡੀਓ ਆਊਟਪੁੱਟ';

  @override
  String get selectPreferredSpeaker => 'ਆਪਣਾ ਪਸੰਦੀਦਾ ਸਪੀਕਰ ਚੁਣੋ';

  @override
  String get noAudioOutputDevices => 'ਕੋਈ ਆਡੀਓ ਆਊਟਪੁੱਟ ਡਿਵਾਈਸ ਨਹੀਂ ਮਿਲੀ';

  @override
  String get refresh => 'ਰਿਫ੍ਰੈਸ਼ ਕਰੋ';

  @override
  String get done => 'ਹੋ ਗਿਆ';

  @override
  String get deleteMessageTitle => 'ਸੁਨੇਹਾ ਹਟਾਓ';

  @override
  String get deleteMessageContent =>
      'ਕੀ ਤੁਸੀਂ ਯਕੀਨਨ ਇਸ ਸੁਨੇਹੇ ਨੂੰ ਹਟਾਉਣਾ ਚਾਹੁੰਦੇ ਹੋ?';

  @override
  String get thisMessageWasDeleted => 'ਇਹ ਸੁਨੇਹਾ ਹਟਾ ਦਿੱਤਾ ਗਿਆ ਹੈ';

  @override
  String get failedToDeleteMessage => 'ਸੁਨੇਹਾ ਹਟਾਉਣ ਵਿੱਚ ਅਸਫਲ';
}
