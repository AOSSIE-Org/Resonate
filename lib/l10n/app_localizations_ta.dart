// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get title => 'Resonate';

  @override
  String get roomDescription =>
      'மற்றவர்களின் கருத்துகளை மதித்து மரியாதையாக பேசுங்கள். தவறான அல்லது கடுமையான கருத்துகளை தவிர்க்கவும்.';

  @override
  String get hidePassword => 'கடவுச்சொல்லை மறை';

  @override
  String get showPassword => 'கடவுச்சொல்லை காண்பி';

  @override
  String get passwordEmpty => 'கடவுச்சொல் காலியாக இருக்கக்கூடாது';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get confirmPassword => 'கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get passwordsNotMatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get userCreatedStories => 'பயனர் உருவாக்கிய கதைகள்';

  @override
  String get yourStories => 'உங்கள் கதைகள்';

  @override
  String get userNoStories => 'இந்த பயனர் எந்தக் கதையும் உருவாக்கவில்லை';

  @override
  String get youNoStories => 'நீங்கள் எந்தக் கதையும் உருவாக்கவில்லை';

  @override
  String get follow => 'பின்தொடர்';

  @override
  String get editProfile => 'சுயவிவரத்தை திருத்து';

  @override
  String get verifyEmail => 'மின்னஞ்சலை சரிபார்க்கவும்';

  @override
  String get verified => 'சரிபார்க்கப்பட்டது';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get userLikedStories => 'பயனர் விரும்பிய கதைகள்';

  @override
  String get yourLikedStories => 'நீங்கள் விரும்பிய கதைகள்';

  @override
  String get userNoLikedStories => 'இந்த பயனர் எந்தக் கதையையும் விரும்பவில்லை';

  @override
  String get youNoLikedStories => 'நீங்கள் எந்தக் கதையையும் விரும்பவில்லை';

  @override
  String get live => 'நேரலை';

  @override
  String get upcoming => 'வரவிருக்கும்';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'எந்த அறையும் கிடைக்கவில்லை',
      'false': 'வரவிருக்கும் அறைகள் இல்லை',
      'other': 'அறை தொடர்பான தகவல் இல்லை',
    });
    return '$_temp0\nகீழே ஒன்றை சேர்த்து தொடங்குங்கள்!';
  }

  @override
  String get user1 => 'பயனர் 1';

  @override
  String get user2 => 'பயனர் 2';

  @override
  String get you => 'நீங்கள்';

  @override
  String get areYouSure => 'நிச்சயமாகவா?';

  @override
  String get loggingOut => 'நீங்கள் Resonate இலிருந்து வெளியேறுகிறீர்கள்.';

  @override
  String get yes => 'ஆம்';

  @override
  String get no => 'இல்லை';

  @override
  String get incorrectEmailOrPassword => 'தவறான மின்னஞ்சல் அல்லது கடவுச்சொல்';

  @override
  String get passwordShort => 'கடவுச்சொல் 8 எழுத்துகளுக்கு குறைவாக உள்ளது';

  @override
  String get tryAgain => 'மீண்டும் முயற்சிக்கவும்!';

  @override
  String get success => 'வெற்றி';

  @override
  String get passwordResetSent =>
      'கடவுச்சொல் மீட்டமைப்பு மின்னஞ்சல் அனுப்பப்பட்டது!';

  @override
  String get error => 'பிழை';

  @override
  String get resetPassword => 'கடவுச்சொல்லை மீட்டமை';

  @override
  String get enterNewPassword => 'புதிய கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get newPassword => 'புதிய கடவுச்சொல்';

  @override
  String get setNewPassword => 'புதிய கடவுச்சொல்லை அமைக்கவும்';

  @override
  String get emailChanged => 'மின்னஞ்சல் மாற்றப்பட்டது';

  @override
  String get emailChangeSuccess => 'மின்னஞ்சல் வெற்றிகரமாக மாற்றப்பட்டது!';

  @override
  String get failed => 'தோல்வி';

  @override
  String get emailChangeFailed => 'மின்னஞ்சலை மாற்ற முடியவில்லை';

  @override
  String get oops => 'அச்சச்சோ!';

  @override
  String get emailExists => 'இந்த மின்னஞ்சல் ஏற்கனவே உள்ளது';

  @override
  String get changeEmail => 'மின்னஞ்சலை மாற்றவும்';

  @override
  String get enterValidEmail => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';

  @override
  String get newEmail => 'புதிய மின்னஞ்சல்';

  @override
  String get currentPassword => 'தற்போதைய கடவுச்சொல்';

  @override
  String get emailChangeInfo =>
      'கூடுதல் பாதுகாப்பிற்காக, உங்கள் மின்னஞ்சலை மாற்றும்போது தற்போதைய கடவுச்சொல்லை வழங்க வேண்டும். மின்னஞ்சல் மாற்றப்பட்ட பிறகு, எதிர்கால உள்நுழைவுகளுக்கு புதிய மின்னஞ்சலை பயன்படுத்தவும்.';

  @override
  String get oauthUsersMessage =>
      '(Google அல்லது Github மூலம் உள்நுழைந்த பயனர்களுக்கு மட்டும்)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'உங்கள் மின்னஞ்சலை மாற்ற, \"தற்போதைய கடவுச்சொல்\" பகுதியில் ஒரு புதிய கடவுச்சொல்லை உள்ளிடவும். இதை நினைவில் வைத்துக் கொள்ளுங்கள், ஏனெனில் எதிர்கால மின்னஞ்சல் மாற்றங்களுக்கு இது தேவைப்படும். இனிமேல் Google/GitHub அல்லது உங்கள் புதிய மின்னஞ்சல் மற்றும் கடவுச்சொல் மூலம் உள்நுழையலாம்.';

  @override
  String get resonateTagline =>
      'வரம்பில்லா\nஉரையாடல்களின் உலகிற்கு நுழையுங்கள்.';

  @override
  String get signInWithEmail => 'மின்னஞ்சல் மூலம் உள்நுழையவும்';

  @override
  String get or => 'அல்லது';

  @override
  String get continueWith => 'இதன் மூலம் தொடரவும்';

  @override
  String get continueWithGoogle => 'Google மூலம் தொடரவும்';

  @override
  String get continueWithGitHub => 'GitHub மூலம் தொடரவும்';

  @override
  String get resonateLogo => 'Resonate லோகோ';

  @override
  String get iAlreadyHaveAnAccount => 'எனக்கு ஏற்கனவே கணக்கு உள்ளது';

  @override
  String get createNewAccount => 'புதிய கணக்கை உருவாக்கவும்';

  @override
  String get userProfile => 'பயனர் சுயவிவரம்';

  @override
  String get passwordIsStrong => 'கடவுச்சொல் வலுவாக உள்ளது';

  @override
  String get admin => 'நிர்வாகி';

  @override
  String get moderator => 'மேற்பார்வையாளர்';

  @override
  String get speaker => 'பேச்சாளர்';

  @override
  String get listener => 'கேட்பவர்';

  @override
  String get removeModerator => 'மேற்பார்வையாளரை நீக்கு';

  @override
  String get kickOut => 'வெளியேற்று';

  @override
  String get addModerator => 'மேற்பார்வையாளரை சேர்க்கவும்';

  @override
  String get addSpeaker => 'பேச்சாளராக மாற்றவும்';

  @override
  String get makeListener => 'கேட்பவராக மாற்றவும்';

  @override
  String get pairChat => 'ஜோடி உரையாடல்';

  @override
  String get chooseIdentity => 'அடையாளத்தை தேர்வு செய்யவும்';

  @override
  String get selectLanguage => 'மொழியை தேர்வு செய்யவும்';

  @override
  String get noConnection => 'இணைப்பு இல்லை';

  @override
  String get loadingDialog => 'ஏற்றப்படுகிறது';

  @override
  String get createAccount => 'கணக்கை உருவாக்கவும்';

  @override
  String get enterValidEmailAddress => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get passwordRequirements =>
      'கடவுச்சொல் குறைந்தது 8 எழுத்துகள் இருக்க வேண்டும்';

  @override
  String get includeNumericDigit => 'குறைந்தது 1 எண் சேர்க்கவும்';

  @override
  String get includeUppercase => 'குறைந்தது 1 பெரிய எழுத்து சேர்க்கவும்';

  @override
  String get includeLowercase => 'குறைந்தது 1 சிறிய எழுத்து சேர்க்கவும்';

  @override
  String get includeSymbol => 'குறைந்தது 1 சிறப்பு குறியீடு சேர்க்கவும்';

  @override
  String get signedUpSuccessfully => 'பதிவு வெற்றிகரமாக முடிந்தது';

  @override
  String get newAccountCreated =>
      'நீங்கள் புதிய கணக்கை வெற்றிகரமாக உருவாக்கியுள்ளீர்கள்';

  @override
  String get signUp => 'பதிவு செய்யவும்';

  @override
  String get login => 'உள்நுழை';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get accountSettings => 'கணக்கு அமைப்புகள்';

  @override
  String get account => 'கணக்கு';

  @override
  String get appSettings => 'செயலி அமைப்புகள்';

  @override
  String get themes => 'தீம்கள்';

  @override
  String get about => 'பற்றி';

  @override
  String get other => 'மற்றவை';

  @override
  String get contribute => 'பங்களிக்கவும்';

  @override
  String get appPreferences => 'செயலி விருப்பங்கள்';

  @override
  String get transcriptionModel => 'மொழிபெயர்ப்பு மாடல்';

  @override
  String get transcriptionModelDescription =>
      'குரல் உரை மாற்றத்திற்கு AI மாடலை தேர்வு செய்யவும். பெரிய மாடல்கள் அதிக துல்லியமானவை ஆனால் மெதுவாகவும் அதிக சேமிப்பிடம் தேவைப்படும்.';

  @override
  String get whisperModelTiny => 'சிறியது';

  @override
  String get whisperModelTinyDescription =>
      'மிக வேகமானது, குறைந்த துல்லியம் (~39 MB)';

  @override
  String get whisperModelBase => 'அடிப்படை';

  @override
  String get whisperModelBaseDescription =>
      'வேகம் மற்றும் துல்லியத்தின் சமநிலை (~74 MB)';

  @override
  String get whisperModelSmall => 'சிறிய';

  @override
  String get whisperModelSmallDescription =>
      'நல்ல துல்லியம், மெதுவாக (~244 MB)';

  @override
  String get whisperModelMedium => 'நடுத்தர';

  @override
  String get whisperModelMediumDescription =>
      'உயர் துல்லியம், மெதுவாக (~769 MB)';

  @override
  String get whisperModelLargeV1 => 'பெரியது V1';

  @override
  String get whisperModelLargeV1Description =>
      'மிக உயர்ந்த துல்லியம், மிகவும் மெதுவாக (~1.55 GB)';

  @override
  String get whisperModelLargeV2 => 'பெரியது V2';

  @override
  String get whisperModelLargeV2Description =>
      'மேம்படுத்தப்பட்ட பெரிய மாடல், அதிக துல்லியம் (~1.55 GB)';

  @override
  String get modelDownloadInfo =>
      'மாடல்கள் முதல் முறையாக பயன்படுத்தும்போது பதிவிறக்கப்படும். Base, Small அல்லது Medium பயன்படுத்த பரிந்துரைக்கப்படுகிறது. Large மாடல்களுக்கு மிக உயர்தர சாதனங்கள் தேவை.';

  @override
  String get logOut => 'வெளியேறு';

  @override
  String get participants => 'பங்கேற்பாளர்கள்';

  @override
  String get delete => 'நீக்கு';

  @override
  String get leave => 'வெளியேறு';

  @override
  String get leaveButton => 'வெளியேறு';

  @override
  String get findingRandomPartner =>
      'உங்களுக்கு ஒரு சீரற்ற இணைப்பாளரை தேடுகிறது';

  @override
  String get quickFact => 'விரைவான தகவல்';

  @override
  String get cancel => 'ரத்து';

  @override
  String get hide => 'மறை';

  @override
  String get removeRoom => 'அறையை நீக்கு';

  @override
  String get removeRoomFromList => 'பட்டியலிலிருந்து நீக்கு';

  @override
  String get removeRoomConfirmation =>
      'இந்த வரவிருக்கும் அறையை உங்கள் பட்டியலிலிருந்து நீக்க விரும்புகிறீர்களா?';

  @override
  String get completeYourProfile => 'உங்கள் சுயவிவரத்தை முழுமைப்படுத்தவும்';

  @override
  String get uploadProfilePicture => 'சுயவிவர புகைப்படத்தை பதிவேற்றவும்';

  @override
  String get enterValidName => 'சரியான பெயரை உள்ளிடவும்';

  @override
  String get name => 'பெயர்';

  @override
  String get username => 'பயனர் பெயர்';

  @override
  String get enterValidDOB => 'சரியான பிறந்த தேதியை உள்ளிடவும்';

  @override
  String get dateOfBirth => 'பிறந்த தேதி';

  @override
  String get forgotPassword => 'கடவுச்சொல்லை மறந்துவிட்டீர்களா?';

  @override
  String get next => 'அடுத்தது';

  @override
  String get noStoriesExist => 'காண்பிக்க எந்தக் கதைகளும் இல்லை';

  @override
  String get enterVerificationCode =>
      'உங்கள்\nசரிபார்ப்பு குறியீட்டை உள்ளிடவும்';

  @override
  String get verificationCodeSent =>
      '6 இலக்க சரிபார்ப்பு குறியீடு அனுப்பப்பட்டுள்ளது\n';

  @override
  String get verificationComplete => 'சரிபார்ப்பு முடிந்தது';

  @override
  String get verificationCompleteMessage =>
      'வாழ்த்துகள்! உங்கள் மின்னஞ்சல் சரிபார்க்கப்பட்டுள்ளது';

  @override
  String get verificationFailed => 'சரிபார்ப்பு தோல்வியடைந்தது';

  @override
  String get otpMismatch => 'OTP பொருந்தவில்லை, மீண்டும் முயற்சிக்கவும்';

  @override
  String get otpResent => 'OTP மீண்டும் அனுப்பப்பட்டது';

  @override
  String get requestNewCode => 'புதிய குறியீட்டை கோரவும்';

  @override
  String get requestNewCodeIn => 'புதிய குறியீட்டை கோரவும்';

  @override
  String get clickPictureCamera => 'கேமராவைப் பயன்படுத்தி படம் எடுக்கவும்';

  @override
  String get pickImageGallery => 'கேலரியிலிருந்து படத்தை தேர்வு செய்யவும்';

  @override
  String get deleteMyAccount => 'என் கணக்கை நீக்கு';

  @override
  String get createNewRoom => 'புதிய அறையை உருவாக்கவும்';

  @override
  String get pleaseEnterScheduledDateTime =>
      'தயவுசெய்து திட்டமிட்ட தேதி மற்றும் நேரத்தை உள்ளிடவும்';

  @override
  String get scheduleDateTimeLabel => 'திட்டமிட்ட தேதி & நேரம்';

  @override
  String get enterTags => 'குறிச்சொற்களை உள்ளிடவும்';

  @override
  String get joinCommunity => 'சமூகத்தில் சேரவும்';

  @override
  String get followUsOnX => 'X-ல் எங்களை பின்தொடரவும்';

  @override
  String get followUsOnYouTube => 'Follow us on YouTube';

  @override
  String get joinDiscordServer => 'Discord சர்வரில் சேரவும்';

  @override
  String get noLyrics => 'வரிகள் கிடைக்கவில்லை';

  @override
  String noStoriesInCategory(String categoryName) {
    return '$categoryName பிரிவில் தற்போது எந்தக் கதைகளும் இல்லை';
  }

  @override
  String get newChapters => 'புதிய அத்தியாயங்கள்';

  @override
  String get helpToGrow => 'வளர உதவுங்கள்';

  @override
  String get share => 'பகிர்';

  @override
  String get rate => 'மதிப்பிடு';

  @override
  String get aboutResonate => 'Resonate பற்றி';

  @override
  String get description => 'விளக்கம்';

  @override
  String get confirm => 'உறுதிப்படுத்து';

  @override
  String get classic => 'பாரம்பரியம்';

  @override
  String get time => 'நேரம்';

  @override
  String get vintage => 'பழமையான';

  @override
  String get amber => 'அம்பர்';

  @override
  String get forest => 'காடு';

  @override
  String get cream => 'க்ரீம்';

  @override
  String get none => 'எதுவும் இல்லை';

  @override
  String checkOutGitHub(String url) {
    return 'எங்கள் GitHub repository-யை பார்க்கவும்: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'AOSSIE லோகோ';

  @override
  String get errorLoadPackageInfo => 'பேக்கேஜ் தகவலை ஏற்ற முடியவில்லை';

  @override
  String get searchFailed => 'அறைகளை தேட முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get updateAvailable => 'புதுப்பிப்பு கிடைக்கிறது';

  @override
  String get newVersionAvailable => 'ஒரு புதிய பதிப்பு கிடைக்கிறது!';

  @override
  String get upToDate => 'புதுப்பித்த நிலையில் உள்ளது';

  @override
  String get latestVersion => 'நீங்கள் சமீபத்திய பதிப்பை பயன்படுத்துகிறீர்கள்';

  @override
  String get profileCreatedSuccessfully =>
      'சுயவிவரம் வெற்றிகரமாக உருவாக்கப்பட்டது';

  @override
  String get invalidScheduledDateTime => 'தவறான திட்டமிட்ட தேதி மற்றும் நேரம்';

  @override
  String get scheduledDateTimePast =>
      'திட்டமிட்ட தேதி மற்றும் நேரம் கடந்ததாக இருக்கக்கூடாது';

  @override
  String get joinRoom => 'அறையில் சேரவும்';

  @override
  String get unknownUser => 'அறியப்படாதவர்';

  @override
  String get canceled => 'ரத்து செய்யப்பட்டது';

  @override
  String get english => 'en';

  @override
  String get emailVerificationRequired => 'மின்னஞ்சல் சரிபார்ப்பு தேவை';

  @override
  String get verify => 'சரிபார்க்கவும்';

  @override
  String get audioRoom => 'ஒலி அறை';

  @override
  String toRoomAction(String action) {
    return 'அறையை $action செய்ய';
  }

  @override
  String get mailSentMessage => 'மின்னஞ்சல் அனுப்பப்பட்டது';

  @override
  String get disconnected => 'இணைப்பு துண்டிக்கப்பட்டது';

  @override
  String get micOn => 'மைக்';

  @override
  String get speakerOn => 'ஸ்பீக்கர்';

  @override
  String get endChat => 'உரையாடலை முடிக்கவும்';

  @override
  String get monthJan => 'ஜன';

  @override
  String get monthFeb => 'பிப்';

  @override
  String get monthMar => 'மார்ச்';

  @override
  String get monthApr => 'ஏப்ரல்';

  @override
  String get monthMay => 'மே';

  @override
  String get monthJun => 'ஜூன்';

  @override
  String get monthJul => 'ஜூலை';

  @override
  String get monthAug => 'ஆக';

  @override
  String get monthSep => 'செப்';

  @override
  String get monthOct => 'அக்';

  @override
  String get monthNov => 'நவ';

  @override
  String get monthDec => 'டிச';

  @override
  String get register => 'பதிவு செய்யவும்';

  @override
  String get newToResonate => 'Resonate-க்கு புதியவரா? ';

  @override
  String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா? ';

  @override
  String get checking => 'சரிபார்க்கப்படுகிறது...';

  @override
  String get forgotPasswordMessage =>
      'உங்கள் கடவுச்சொல்லை மீட்டமைக்க பதிவு செய்யப்பட்ட மின்னஞ்சலை உள்ளிடவும்.';

  @override
  String get usernameUnavailable => 'பயனர் பெயர் கிடைக்கவில்லை!';

  @override
  String get usernameInvalidOrTaken =>
      'இந்த பயனர் பெயர் தவறானது அல்லது ஏற்கனவே பயன்படுத்தப்படுகிறது.';

  @override
  String get otpResentMessage =>
      'புதிய OTP-க்கு உங்கள் மின்னஞ்சலை சரிபார்க்கவும்.';

  @override
  String get connectionError =>
      'இணைப்பு பிழை ஏற்பட்டுள்ளது. உங்கள் இணைய இணைப்பை சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get seconds => 'வினாடிகள்.';

  @override
  String get unsavedChangesWarning =>
      'சேமிக்காமல் தொடர்ந்தால், சேமிக்கப்படாத மாற்றங்கள் அனைத்தும் இழக்கப்படும்.';

  @override
  String get deleteAccountPermanent =>
      'இந்த செயல் உங்கள் கணக்கை நிரந்தரமாக நீக்கும். இதை மீட்டெடுக்க முடியாது. உங்கள் பயனர் பெயர், மின்னஞ்சல் முகவரி மற்றும் கணக்குடன் தொடர்புடைய அனைத்து தரவுகளும் நீக்கப்படும்.';

  @override
  String get giveGreatName => 'ஒரு சிறந்த பெயரை கொடுங்கள்..';

  @override
  String get joinCommunityDescription =>
      'சமூகத்தில் சேர்வதன் மூலம் உங்கள் சந்தேகங்களை தீர்க்கலாம், புதிய அம்சங்களை பரிந்துரைக்கலாம், நீங்கள் சந்தித்த பிரச்சனைகளை அறிக்கையிடலாம் மற்றும் பலவற்றை செய்யலாம்.';

  @override
  String get resonateDescription =>
      'Resonate என்பது ஒவ்வொரு குரலும் மதிக்கப்படும் ஒரு சமூக ஊடக தளம். உங்கள் எண்ணங்கள், கதைகள் மற்றும் அனுபவங்களை மற்றவர்களுடன் பகிருங்கள். இப்போதே உங்கள் ஒலி பயணத்தை தொடங்குங்கள்.';

  @override
  String get resonateFullDescription =>
      'Resonate என்பது ஒவ்வொரு குரலும் முக்கியமானதாக கருதப்படும் ஒரு புரட்சிகர ஒலி அடிப்படையிலான சமூக ஊடக தளம்.\nநேரடி ஒலி உரையாடல்களில் கலந்து கொள்ளுங்கள், பல்வேறு விவாதங்களில் பங்கேற்கவும், ஒரே எண்ணம் கொண்டவர்களுடன் இணைக்கவும்.\nஎங்கள் தளத்தின் அம்சங்கள்:\n- தலைப்புகளின் அடிப்படையிலான நேரடி ஒலி அறைகள்\n- குரல் மூலம் எளிய சமூக இணைப்பு\n- சமூக இயக்கப்படும் உள்ளடக்க மேலாண்மை\n- பல தள ஆதரவு\n- முழுமையான குறியாக்கத்துடன் தனிப்பட்ட உரையாடல்கள்\n\nAOSSIE திறந்த மூல சமூகத்தால் உருவாக்கப்பட்ட Resonate, பயனர் தனியுரிமை மற்றும் சமூக வளர்ச்சியை முன்னுரிமையாகக் கொள்கிறது. சமூக ஒலியின் எதிர்காலத்தை உருவாக்க எங்களுடன் சேருங்கள்!';

  @override
  String get stable => 'நிலையானது';

  @override
  String get usernameCharacterLimit =>
      'பயனர் பெயர் குறைந்தது 8 எழுத்துகள் கொண்டிருக்க வேண்டும்.';

  @override
  String get submit => 'சமர்ப்பிக்கவும்';

  @override
  String get anonymous => 'அடையாளமற்ற';

  @override
  String get noSearchResults => 'தேடல் முடிவுகள் இல்லை';

  @override
  String get searchRooms => 'அறைகளை தேடுங்கள்...';

  @override
  String get searchingRooms => 'அறைகள் தேடப்படுகின்றன...';

  @override
  String get clearSearch => 'தேடலை அழிக்கவும்';

  @override
  String get searchError => 'தேடல் பிழை';

  @override
  String get searchRoomsError =>
      'அறைகளை தேட முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get searchUpcomingRoomsError =>
      'வரவிருக்கும் அறைகளை தேட முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get search => 'தேடல்';

  @override
  String get clear => 'அழி';

  @override
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  ) {
    return '🚀 இந்த அற்புதமான அறையைப் பாருங்கள்: $roomName!\n\n📖 விளக்கம்: $description\n👥 இப்போது $participants பேர் கலந்து கொள்ளுங்கள்!';
  }

  @override
  String participantsCount(int count) {
    return '$count பங்கேற்பாளர்கள்';
  }

  @override
  String get join => 'சேரவும்';

  @override
  String get invalidTags => 'தவறான குறிச்சொல்:';

  @override
  String get cropImage => 'படத்தை வெட்டு';

  @override
  String get profileSavedSuccessfully => 'சுயவிவரம் புதுப்பிக்கப்பட்டது';

  @override
  String get profileUpdatedSuccessfully =>
      'அனைத்து மாற்றங்களும் வெற்றிகரமாக சேமிக்கப்பட்டுள்ளன.';

  @override
  String get profileUpToDate => 'சுயவிவரம் புதுப்பித்த நிலையில் உள்ளது';

  @override
  String get noChangesToSave =>
      'புதிய மாற்றங்கள் எதுவும் இல்லை, சேமிக்க எதுவும் இல்லை.';

  @override
  String get connectionFailed => 'இணைப்பு தோல்வியடைந்தது';

  @override
  String get unableToJoinRoom =>
      'அறையில் சேர முடியவில்லை. உங்கள் இணைய இணைப்பை சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get connectionLost => 'இணைப்பு துண்டிக்கப்பட்டது';

  @override
  String get unableToReconnect =>
      'அறையுடன் மீண்டும் இணைக்க முடியவில்லை. மீண்டும் சேர முயற்சிக்கவும்.';

  @override
  String get invalidFormat => 'தவறான வடிவம்!';

  @override
  String get usernameAlphanumeric =>
      'பயனர் பெயர் எழுத்துகள் மற்றும் எண்கள் மட்டும் கொண்டிருக்க வேண்டும். சிறப்பு குறியீடுகள் இருக்கக்கூடாது.';

  @override
  String get userProfileCreatedSuccessfully =>
      'உங்கள் பயனர் சுயவிவரம் வெற்றிகரமாக உருவாக்கப்பட்டுள்ளது.';

  @override
  String get emailVerificationMessage =>
      'தொடர்வதற்கு, உங்கள் மின்னஞ்சல் முகவரியை சரிபார்க்கவும்.';

  @override
  String addNewChaptersToStory(String storyName) {
    return '$storyName கதைக்கு புதிய அத்தியாயங்களை சேர்க்கவும்';
  }

  @override
  String get currentChapters => 'தற்போதைய அத்தியாயங்கள்';

  @override
  String get sourceCodeOnGitHub => 'GitHub-இல் மூலக் குறியீடு';

  @override
  String get createAChapter => 'ஒரு அத்தியாயத்தை உருவாக்கவும்';

  @override
  String get chapterTitle => 'அத்தியாய தலைப்பு *';

  @override
  String get aboutRequired => 'பற்றி *';

  @override
  String get changeCoverImage => 'முகப்பு படத்தை மாற்றவும்';

  @override
  String get uploadAudioFile => 'ஒலி கோப்பை பதிவேற்றவும்';

  @override
  String get uploadLyricsFile => 'வரிகள் கோப்பை பதிவேற்றவும்';

  @override
  String get createChapter => 'அத்தியாயத்தை உருவாக்கவும்';

  @override
  String audioFileSelected(String fileName) {
    return 'தேர்ந்தெடுக்கப்பட்ட ஒலி கோப்பு: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'தேர்ந்தெடுக்கப்பட்ட வரிகள் கோப்பு: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'தயவுசெய்து அனைத்து தேவையான புலங்களையும் நிரப்பி, ஒலி கோப்பும் வரிகள் கோப்பையும் பதிவேற்றவும்';

  @override
  String get scheduled => 'திட்டமிடப்பட்டது';

  @override
  String get ok => 'சரி';

  @override
  String get roomDescriptionOptional => 'அறை விளக்கம் (விருப்பம்)';

  @override
  String get deleteAccount => 'கணக்கை நீக்கு';

  @override
  String get createYourStory => 'உங்கள் கதையை உருவாக்கவும்';

  @override
  String get titleRequired => 'தலைப்பு *';

  @override
  String get category => 'வகை *';

  @override
  String get addChapter => 'அத்தியாயம் சேர்க்கவும்';

  @override
  String get createStory => 'கதையை உருவாக்கவும்';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'தயவுசெய்து அனைத்து தேவையான புலங்களையும் நிரப்பி, குறைந்தது ஒரு அத்தியாயத்தை சேர்த்து, ஒரு முகப்பு படத்தை தேர்வு செய்யவும்.';

  @override
  String get toConfirmType => 'உறுதிப்படுத்த, தட்டச்சு செய்யவும்';

  @override
  String get inTheBoxBelow => 'கீழே உள்ள பெட்டியில்';

  @override
  String get iUnderstandDeleteMyAccount =>
      'நான் புரிந்துகொண்டேன், என் கணக்கை நீக்கு';

  @override
  String get whatDoYouWantToListenTo => 'நீங்கள் என்ன கேட்க விரும்புகிறீர்கள்?';

  @override
  String get categories => 'வகைகள்';

  @override
  String get stories => 'கதைகள்';

  @override
  String get someSuggestions => 'சில பரிந்துரைகள்';

  @override
  String get getStarted => 'தொடங்குங்கள்';

  @override
  String get skip => 'தவிர்க்கவும்';

  @override
  String get welcomeToResonate => 'Resonate-க்கு வரவேற்கிறோம்';

  @override
  String get exploreDiverseConversations => 'பல்வேறு உரையாடல்களை ஆராயுங்கள்';

  @override
  String get yourVoiceMatters => 'உங்கள் குரல் முக்கியம்';

  @override
  String get joinConversationExploreRooms =>
      'உரையாடலில் சேருங்கள்! அறைகளை ஆராயுங்கள், நண்பர்களுடன் இணைக, உங்கள் குரலை உலகுடன் பகிருங்கள்.';

  @override
  String get diveIntoDiverseDiscussions =>
      'பல்வேறு விவாதங்களிலும் தலைப்புகளிலும் ஆழமாக ஈடுபடுங்கள்.\nஉங்களுக்கு பொருந்தும் அறைகளை கண்டுபிடித்து சமூகத்தின் ஒரு பகுதியாகுங்கள்.';

  @override
  String get atResonateEveryVoiceValued =>
      'Resonate-இல், ஒவ்வொரு குரலும் மதிக்கப்படுகிறது. உங்கள் எண்ணங்கள், கதைகள் மற்றும் அனுபவங்களை மற்றவர்களுடன் பகிருங்கள். இப்போதே உங்கள் ஒலி பயணத்தை தொடங்குங்கள்.';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username உங்களை ஒரு வரவிருக்கும் அறையில் குறித்துள்ளார்: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username உங்களை ஒரு அறையில் குறித்துள்ளார்: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username உங்கள் கதையை விரும்பினார்: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username உங்கள் அறையை சந்தாதாரராக இணைந்தார்: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username உங்களை பின்தொடர தொடங்கினார்';
  }

  @override
  String get youHaveNewNotification => 'உங்களுக்கு புதிய அறிவிப்பு உள்ளது';

  @override
  String get hangOnGoodThingsTakeTime =>
      'சற்றுக் காத்திருக்கவும், நல்ல விஷயங்களுக்கு நேரம் எடுக்கும் 🔍';

  @override
  String get resonateOpenSourceProject =>
      'Resonate என்பது AOSSIE பராமரிக்கும் ஒரு திறந்த மூல திட்டம். பங்களிக்க எங்கள் GitHub-ஐ பாருங்கள்.';

  @override
  String get mute => 'மியூட்';

  @override
  String get speakerLabel => 'ஸ்பீக்கர்';

  @override
  String get audioOptions => 'ஒலி விருப்பங்கள்';

  @override
  String get end => 'முடிக்கவும்';

  @override
  String get saveChanges => 'மாற்றங்களை சேமிக்கவும்';

  @override
  String get discard => 'கைவிடு';

  @override
  String get save => 'சேமி';

  @override
  String get changeProfilePicture => 'சுயவிவரப் புகைப்படத்தை மாற்றவும்';

  @override
  String get camera => 'கேமரா';

  @override
  String get gallery => 'கேலரி';

  @override
  String get remove => 'நீக்கு';

  @override
  String created(String date) {
    return '$date அன்று உருவாக்கப்பட்டது';
  }

  @override
  String get chapters => 'அத்தியாயங்கள்';

  @override
  String get deleteStory => 'கதையை நீக்கு';

  @override
  String createdBy(String creatorName) {
    return '$creatorName உருவாக்கியது';
  }

  @override
  String get start => 'தொடங்கு';

  @override
  String get unsubscribe => 'சந்தாவை ரத்து செய்';

  @override
  String get subscribe => 'சந்தா பெற';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'நாடகம்',
      'comedy': 'நகைச்சுவை',
      'horror': 'திகில்',
      'romance': 'காதல்',
      'thriller': 'திரில்லர்',
      'spiritual': 'ஆன்மீகம்',
      'other': 'மற்றவை',
    });
    return '$_temp0';
  }

  @override
  String chooseTheme(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'classicTheme': 'பாரம்பரியம்',
      'timeTheme': 'நேரம்',
      'vintageTheme': 'பழமையான',
      'amberTheme': 'அம்பர்',
      'forestTheme': 'காடு',
      'creamTheme': 'க்ரீம்',
      'other': 'மற்றவை',
    });
    return '$_temp0';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நிமிடங்கள் முன்பு',
      one: '1 நிமிடம் முன்பு',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மணி நேரங்கள் முன்பு',
      one: '1 மணி நேரம் முன்பு',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நாட்கள் முன்பு',
      one: '1 நாள் முன்பு',
    );
    return '$_temp0';
  }

  @override
  String get by => 'மூலம்';

  @override
  String get likes => 'விருப்பங்கள்';

  @override
  String get lengthMinutes => 'நிமி.';

  @override
  String get requiredField => 'தேவையான புலம்';

  @override
  String get onlineUsers => 'ஆன்லைன் பயனர்கள்';

  @override
  String get noOnlineUsers => 'தற்போது ஆன்லைனில் யாரும் இல்லை';

  @override
  String get chooseUser => 'உரையாட பயனரை தேர்வு செய்யவும்';

  @override
  String get quickMatch => 'விரைவு இணைப்பு';

  @override
  String get story => 'கதை';

  @override
  String get user => 'பயனர்';

  @override
  String get following => 'நீங்கள் பின்தொடர்பவர்கள்';

  @override
  String get followers => 'உங்களை பின்தொடர்வோர்';

  @override
  String get friendRequests => 'நண்பர் கோரிக்கைகள்';

  @override
  String get friendRequestSent => 'நண்பர் கோரிக்கை அனுப்பப்பட்டது';

  @override
  String friendRequestSentTo(String username) {
    return '$username அவர்களுக்கு உங்கள் நண்பர் கோரிக்கை அனுப்பப்பட்டுள்ளது.';
  }

  @override
  String get friendRequestCancelled => 'நண்பர் கோரிக்கை ரத்து செய்யப்பட்டது';

  @override
  String friendRequestCancelledTo(String username) {
    return '$username அவர்களுக்கு அனுப்பிய நண்பர் கோரிக்கை ரத்து செய்யப்பட்டது.';
  }

  @override
  String get requested => 'கோரப்பட்டது';

  @override
  String get friends => 'நண்பர்கள்';

  @override
  String get addFriend => 'நண்பரை சேர்க்கவும்';

  @override
  String get friendRequestAccepted => 'நண்பர் கோரிக்கை ஏற்கப்பட்டது';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'நீங்கள் இப்போது $username அவர்களின் நண்பர்.';
  }

  @override
  String get friendRequestDeclined => 'நண்பர் கோரிக்கை நிராகரிக்கப்பட்டது';

  @override
  String friendRequestDeclinedTo(String username) {
    return '$username அவர்களிடமிருந்து வந்த நண்பர் கோரிக்கையை நீங்கள் நிராகரித்துள்ளீர்கள்.';
  }

  @override
  String get accept => 'ஏற்கவும்';

  @override
  String get callDeclined => 'அழைப்பு நிராகரிக்கப்பட்டது';

  @override
  String callDeclinedTo(String username) {
    return '$username அழைப்பை நிராகரித்தார்.';
  }

  @override
  String get checkForUpdates => 'புதுப்பிப்புகளை சரிபார்க்கவும்';

  @override
  String get updateNow => 'இப்போதே புதுப்பிக்கவும்';

  @override
  String get updateLater => 'பின்னர்';

  @override
  String get updateSuccessful => 'புதுப்பிப்பு வெற்றிகரமாக முடிந்தது';

  @override
  String get updateSuccessfulMessage =>
      'Resonate வெற்றிகரமாக புதுப்பிக்கப்பட்டுள்ளது!';

  @override
  String get updateCancelled => 'புதுப்பிப்பு ரத்து செய்யப்பட்டது';

  @override
  String get updateCancelledMessage =>
      'புதுப்பிப்பு பயனரால் ரத்து செய்யப்பட்டது';

  @override
  String get updateFailed => 'புதுப்பிப்பு தோல்வியடைந்தது';

  @override
  String get updateFailedMessage =>
      'புதுப்பிக்க முடியவில்லை. தயவுசெய்து Play Store-இல் இருந்து கைமுறையாக புதுப்பிக்கவும்.';

  @override
  String get updateError => 'புதுப்பிப்பு பிழை';

  @override
  String get updateErrorMessage =>
      'புதுப்பிக்கும் போது பிழை ஏற்பட்டது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get platformNotSupported => 'இந்த தளம் ஆதரிக்கப்படவில்லை';

  @override
  String get platformNotSupportedMessage =>
      'புதுப்பிப்பு சரிபார்ப்பு Android சாதனங்களில் மட்டுமே கிடைக்கும்';

  @override
  String get updateCheckFailed => 'புதுப்பிப்பு சரிபார்ப்பு தோல்வியடைந்தது';

  @override
  String get updateCheckFailedMessage =>
      'புதுப்பிப்புகளை சரிபார்க்க முடியவில்லை. பின்னர் மீண்டும் முயற்சிக்கவும்.';

  @override
  String get upToDateTitle => 'நீங்கள் புதுப்பித்த நிலையில் உள்ளீர்கள்!';

  @override
  String get upToDateMessage =>
      'நீங்கள் Resonate-இன் சமீபத்திய பதிப்பை பயன்படுத்துகிறீர்கள்';

  @override
  String get updateAvailableTitle => 'புதுப்பிப்பு கிடைக்கிறது!';

  @override
  String get updateAvailableMessage =>
      'Resonate-இன் புதிய பதிப்பு Play Store-இல் கிடைக்கிறது';

  @override
  String get updateFeaturesImprovement =>
      'புதிய அம்சங்களையும் மேம்பாடுகளையும் பெறுங்கள்!';

  @override
  String get failedToRemoveRoom => 'அறையை நீக்க முடியவில்லை';

  @override
  String get roomRemovedSuccessfully =>
      'அறை உங்கள் பட்டியலிலிருந்து வெற்றிகரமாக நீக்கப்பட்டது';

  @override
  String get alert => 'எச்சரிக்கை';

  @override
  String get removedFromRoom =>
      'நீங்கள் அறையிலிருந்து புகாரளிக்கப்பட்டோ அல்லது நீக்கப்பட்டோ உள்ளீர்கள்';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'தொந்தரவு / வெறுப்பு பேச்சு',
      'abuse': 'அவமதிக்கும் உள்ளடக்கம் / வன்முறை',
      'spam': 'ஸ்பாம் / மோசடி',
      'impersonation': 'போலி அடையாளம்',
      'illegal': 'சட்டவிரோத செயல்கள்',
      'selfharm': 'சுயதீங்கு / தற்கொலை / மனநலம்',
      'misuse': 'தளத்தின் தவறான பயன்பாடு',
      'other': 'மற்றவை',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate =>
      'பல பயனர்களிடமிருந்து புகார்கள் வந்துள்ளதால், Resonate-ஐ பயன்படுத்த நீங்கள் தடைசெய்யப்பட்டுள்ளீர்கள். இது தவறு என நினைத்தால் AOSSIE-யை தொடர்புகொள்ளவும்.';

  @override
  String get reportParticipant => 'பங்கேற்பாளரை புகாரளிக்கவும்';

  @override
  String get selectReportType => 'புகார் வகையை தேர்வு செய்யவும்';

  @override
  String get reportSubmitted => 'புகார் வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது';

  @override
  String get reportFailed => 'புகார் சமர்ப்பிப்பு தோல்வியடைந்தது';

  @override
  String get additionalDetailsOptional => 'கூடுதல் விவரங்கள் (விருப்பம்)';

  @override
  String get submitReport => 'புகாரை சமர்ப்பிக்கவும்';

  @override
  String get actionBlocked => 'செயல் தடுக்கப்பட்டது';

  @override
  String get cannotStopRecording =>
      'பதிவை கைமுறையாக நிறுத்த முடியாது; அறை மூடப்படும் போது பதிவு தானாக நிறுத்தப்படும்.';

  @override
  String get liveChapter => 'நேரடி அத்தியாயம்';

  @override
  String get viewOrEditLyrics => 'வரிகளை பார்க்க அல்லது திருத்த';

  @override
  String get close => 'மூடு';

  @override
  String get verifyChapterDetails => 'அத்தியாய விவரங்களை சரிபார்க்கவும்';

  @override
  String get author => 'ஆசிரியர்';

  @override
  String get startLiveChapter => 'நேரடி அத்தியாயத்தை தொடங்கவும்';

  @override
  String get fillAllFields =>
      'தயவுசெய்து அனைத்து தேவையான புலங்களையும் நிரப்பவும்';

  @override
  String get noRecordingError =>
      'இந்த அத்தியாயத்திற்கு எந்த பதிவும் செய்யப்படவில்லை. அறையை விட்டு வெளியேறும் முன் தயவுசெய்து ஒரு பதிவை செய்யவும்';

  @override
  String get audioOutput => 'ஒலி வெளியீடு';

  @override
  String get selectPreferredSpeaker =>
      'உங்களுக்கு விருப்பமான ஸ்பீக்கரை தேர்வு செய்யவும்';

  @override
  String get noAudioOutputDevices =>
      'ஒலி வெளியீட்டு சாதனங்கள் எதுவும் கண்டறியப்படவில்லை';

  @override
  String get refresh => 'புதுப்பி';

  @override
  String get done => 'முடிந்தது';

  @override
  String get deleteMessageTitle => 'செய்தியை நீக்கு';

  @override
  String get deleteMessageContent => 'இந்த செய்தியை நீக்க விரும்புகிறீர்களா?';

  @override
  String get thisMessageWasDeleted => 'இந்த செய்தி நீக்கப்பட்டது';

  @override
  String get failedToDeleteMessage => 'செய்தியை நீக்க முடியவில்லை';

  @override
  String get noFriendsYet => 'No Friends Yet';

  @override
  String get noFriendsDescription =>
      'Your friends list is empty. Start connecting with people and grow your network!';

  @override
  String get findFriends => 'Find Friends';

  @override
  String get inviteFriend => 'Invite a Friend';

  @override
  String get noFriendRequestsYet => 'No Friend Requests';

  @override
  String get noFriendRequestsDescription =>
      'You don\'t have any pending friend requests. Invite your friends to connect!';

  @override
  String inviteToResonate(String url) {
    return 'Hey! Join me on Resonate - a social audio platform where every voice is valued. Download now: $url';
  }

  @override
  String get usernameInvalidFormat =>
      'சரியான பயனர் பெயரை உள்ளிடவும். எழுத்துகள், எண்கள், புள்ளிகள், அடிக்கோடுகள் மற்றும் ஹைபன்கள் மட்டுமே அனுமதிக்கப்படுகின்றன.';

  @override
  String get usernameAlreadyTaken =>
      'இந்த பயனர் பெயர் ஏற்கனவே பயன்படுத்தப்படுகிறது. வேறு ஒன்றை முயற்சிக்கவும்.';
}
