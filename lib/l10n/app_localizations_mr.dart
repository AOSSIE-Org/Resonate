// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get title => 'रेजोनेट';

  @override
  String get roomDescription =>
      'विनम्र रहा आणि दुसऱ्या व्यक्तीच्या मतीचा सन्मान करा. असभ्य टिप्पण्या टाळा.';

  @override
  String get hidePassword => 'पासवर्ड लपवा';

  @override
  String get showPassword => 'पासवर्ड दाखवा';

  @override
  String get passwordEmpty => 'पासवर्ड रिक्त असू शकत नाही';

  @override
  String get password => 'पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड पुष्टी करा';

  @override
  String get passwordsNotMatch => 'पासवर्ड जुळत नाहीत';

  @override
  String get userCreatedStories => 'वापरकर्त्याने तयार केलेल्या कथा';

  @override
  String get yourStories => 'आपल्या कथा';

  @override
  String get userNoStories => 'वापरकर्त्याने कोणतीही कथा तयार केलेली नाही';

  @override
  String get youNoStories => 'आपण कोणतीही कथा तयार केलेली नाही';

  @override
  String get follow => 'फॉलो करा';

  @override
  String get editProfile => 'प्रोफाइल संपादित करा';

  @override
  String get verifyEmail => 'ईमेल सत्यापित करा';

  @override
  String get verified => 'सत्यापित';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get userLikedStories => 'वापरकर्त्याने आवडलेल्या कथा';

  @override
  String get yourLikedStories => 'आपल्या आवडीची कथा';

  @override
  String get userNoLikedStories => 'वापरकर्त्याने कोणतीही कथा आवडलेली नाही';

  @override
  String get youNoLikedStories => 'आपण कोणतीही कथा आवडलेली नाही';

  @override
  String get live => 'लाइव्ह';

  @override
  String get upcoming => 'आगामी';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'कोणताही कक्ष उपलब्ध नाही',
      'false': 'आगामी कक्ष उपलब्ध नाही',
      'other': 'कोणतीही माहिती उपलब्ध नाही',
    });
    return '$_temp0\nखाली एक जोडून सुरुवात करा!';
  }

  @override
  String get user1 => 'वापरकर्ता १';

  @override
  String get user2 => 'वापरकर्ता २';

  @override
  String get you => 'आपण';

  @override
  String get areYouSure => 'आपण खात्रीने सांगता का?';

  @override
  String get loggingOut => 'आपण रेजोनेटमधून लॉगआउट करत आहात.';

  @override
  String get yes => 'होय';

  @override
  String get no => 'नाही';

  @override
  String get incorrectEmailOrPassword => 'चुकीचा ईमेल किंवा पासवर्ड';

  @override
  String get passwordShort => 'पासवर्ड किमान ८ अक्षरांचा असावा';

  @override
  String get tryAgain => 'पुन्हा प्रयत्न करा!';

  @override
  String get success => 'यशस्वी';

  @override
  String get passwordResetSent => 'पासवर्ड रीसेट ईमेल पाठवली गेली!';

  @override
  String get error => 'त्रुटी';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करा';

  @override
  String get enterNewPassword => 'आपला नवीन पासवर्ड प्रविष्ट करा';

  @override
  String get newPassword => 'नवीन पासवर्ड';

  @override
  String get setNewPassword => 'नवीन पासवर्ड सेट करा';

  @override
  String get emailChanged => 'ईमेल बदलली आहे';

  @override
  String get emailChangeSuccess => 'ईमेल यशस्वीरित्या बदलली!';

  @override
  String get failed => 'अयशस्वी';

  @override
  String get emailChangeFailed => 'ईमेल बदल अयशस्वी झाला';

  @override
  String get oops => 'अरे!';

  @override
  String get emailExists => 'ईमेल आधीच अस्तित्वात आहे';

  @override
  String get changeEmail => 'ईमेल बदला';

  @override
  String get enterValidEmail => 'कृपया एक वैध ईमेल पत्ता प्रविष्ट करा';

  @override
  String get newEmail => 'नवीन ईमेल';

  @override
  String get currentPassword => 'वर्तमान पासवर्ड';

  @override
  String get emailChangeInfo =>
      'अतिरिक्त सुरक्षेसाठी, आपले ईमेल पत्ता बदलताना आपण आपल्या खात्याचा वर्तमान पासवर्ड प्रदान करणे आवश्यक आहे. आपला ईमेल बदल्यानंतर, भविष्यातील लॉगिनसाठी अद्यतन ईमेल वापरा.';

  @override
  String get oauthUsersMessage =>
      '(फक्त Google किंवा Github वापरून लॉगिन केलेल्या वापरकर्त्यांसाठी)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'आपले ईमेल बदलण्यासाठी, कृपया \"वर्तमान पासवर्ड\" फील्डमध्ये नवीन पासवर्ड प्रविष्ट करा. हा पासवर्ड लक्षात ठेवा, कारण भविष्यातील ईमेल बदलांसाठी आपल्याला हवा असेल. पुढे, आपण Google/GitHub किंवा आपला नवीन ईमेल आणि पासवर्ड संयोजन वापरून लॉगिन करू शकता.';

  @override
  String get resonateTagline => 'अमर्याद संभाषणांच्या जगात प्रवेश करा.';

  @override
  String get signInWithEmail => 'ईमेलने साइन इन करा';

  @override
  String get or => 'किंवा';

  @override
  String get continueWith => 'यासह सुरू ठेवा';

  @override
  String get continueWithGoogle => 'Google सह सुरू ठेवा';

  @override
  String get continueWithGitHub => 'GitHub सह सुरू ठेवा';

  @override
  String get resonateLogo => 'रेजोनेट लोगो';

  @override
  String get iAlreadyHaveAnAccount => 'माझ्याकडे आधीच खाते आहे';

  @override
  String get createNewAccount => 'नवीन खाते तयार करा';

  @override
  String get userProfile => 'वापरकर्ता प्रोफाइल';

  @override
  String get passwordIsStrong => 'पासवर्ड मजबूत आहे';

  @override
  String get admin => 'प्रशासक';

  @override
  String get moderator => 'मॉडरेटर';

  @override
  String get speaker => 'स्पीकर';

  @override
  String get listener => 'श्रोता';

  @override
  String get removeModerator => 'मॉडरेटर काढून टाका';

  @override
  String get kickOut => 'बाहेर काढा';

  @override
  String get addModerator => 'मॉडरेटर सामील व्हा';

  @override
  String get addSpeaker => 'स्पीकर सामील व्हा';

  @override
  String get makeListener => 'श्रोता बनवा';

  @override
  String get pairChat => 'जोडी संभाषण';

  @override
  String get chooseIdentity => 'ओळख निवडा';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get noConnection => 'कोणतेही कनेक्शन नाही';

  @override
  String get loadingDialog => 'लोडिंग संवाद';

  @override
  String get createAccount => 'खाते तयार करा';

  @override
  String get enterValidEmailAddress => 'वैध ईमेल पत्ता प्रविष्ट करा';

  @override
  String get email => 'ईमेल';

  @override
  String get passwordRequirements =>
      'पासवर्ड किमान ८ अक्षरांचा असणे आवश्यक आहे';

  @override
  String get includeNumericDigit => 'किमान १ संख्या अंक समाविष्ट करा';

  @override
  String get includeUppercase => 'किमान १ मोठे अक्षर समाविष्ट करा';

  @override
  String get includeLowercase => 'किमान १ लहान अक्षर समाविष्ट करा';

  @override
  String get includeSymbol => 'किमान १ चिन्ह समाविष्ट करा';

  @override
  String get signedUpSuccessfully => 'यशस्वीरित्या साइन अप केले';

  @override
  String get newAccountCreated => 'आपण यशस्वीरित्या नवीन खाते तयार केले आहे';

  @override
  String get signUp => 'साइन अप करा';

  @override
  String get login => 'लॉगिन';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get accountSettings => 'खाता सेटिंग्स';

  @override
  String get account => 'खाता';

  @override
  String get appSettings => 'अॅप सेटिंग्स';

  @override
  String get themes => 'थीम्स';

  @override
  String get about => 'बद्दल';

  @override
  String get other => 'इतर';

  @override
  String get contribute => 'योगदान द्या';

  @override
  String get appPreferences => 'अॅप प्राधान्ये';

  @override
  String get transcriptionModel => 'प्रतिलेखन मॉडेल';

  @override
  String get transcriptionModelDescription =>
      'व्हॉयस प्रतिलेखनसाठी एआई मॉडेल निवडा. मोठे मॉडेल अधिक अचूक आहेत परंतु हळू आणि अधिक स्टोरेज आवश्यक आहे.';

  @override
  String get whisperModelTiny => 'सूक्ष्म';

  @override
  String get whisperModelTinyDescription =>
      'सर्वात वेगवान, कमीत कमी अचूक (~३९ एमबी)';

  @override
  String get whisperModelBase => 'बेस';

  @override
  String get whisperModelBaseDescription => 'संतुलित गती आणि अचूकता (~७४ एमबी)';

  @override
  String get whisperModelSmall => 'लहान';

  @override
  String get whisperModelSmallDescription => 'चांगली अचूकता, हळू (~२४४ एमबी)';

  @override
  String get whisperModelMedium => 'मध्यम';

  @override
  String get whisperModelMediumDescription => 'उच्च अचूकता, हळू (~७६९ एमबी)';

  @override
  String get whisperModelLargeV1 => 'मोठे व्ही१';

  @override
  String get whisperModelLargeV1Description =>
      'सर्वात अचूक, सर्वात हळू (~१.५५ जीबी)';

  @override
  String get whisperModelLargeV2 => 'मोठे व्ही२';

  @override
  String get whisperModelLargeV2Description =>
      'उन्नत मोठे मॉडेल उच्च अचूकतेसह (~१.५५ जीबी)';

  @override
  String get modelDownloadInfo =>
      'मॉडेल्स प्रथम वापरणे सुरू असताना डाउनलोड केले जातात. आम्ही बेस, लहान किंवा मध्यम वापरण्याची शिफारस करतो. मोठ्या मॉडेल्ससाठी अत्यंत उच्च-अंत डिव्हाइस आवश्यक आहे.';

  @override
  String get logOut => 'लॉगआउट करा';

  @override
  String get participants => 'सहभागी';

  @override
  String get delete => 'हटवा';

  @override
  String get leave => 'सोडून द्या';

  @override
  String get leaveButton => 'सोडून द्या';

  @override
  String get findingRandomPartner => 'आपल्यासाठी यादृच्छिक सहभागी शोधत आहे';

  @override
  String get quickFact => 'द्रुत माहिती';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get hide => 'काढून टाका';

  @override
  String get removeRoom => 'कक्ष काढून टाका';

  @override
  String get removeRoomFromList => 'यादीतून काढून टाका';

  @override
  String get removeRoomConfirmation =>
      'आपण हा आगामी कक्ष आपल्या यादीतून काढून टाकू इच्छिता का?';

  @override
  String get completeYourProfile => 'आपल्या प्रोफाइल पूर्ण करा';

  @override
  String get uploadProfilePicture => 'प्रोफाइल चित्र अपलोड करा';

  @override
  String get enterValidName => 'वैध नाव प्रविष्ट करा';

  @override
  String get name => 'नाव';

  @override
  String get username => 'वापरकर्तानाव';

  @override
  String get enterValidDOB => 'वैध जन्मतारीख प्रविष्ट करा';

  @override
  String get dateOfBirth => 'जन्मतारीख';

  @override
  String get forgotPassword => 'पासवर्ड विसरलात?';

  @override
  String get next => 'पुढील';

  @override
  String get noStoriesExist => 'सादर करण्यासाठी कोणतीही कथा नाही';

  @override
  String get enterVerificationCode => 'आपला\nसत्यापन कोड प्रविष्ट करा';

  @override
  String get verificationCodeSent =>
      'आम्ही आपल्याला एक ६-अंकीय सत्यापन कोड पाठवला आहे\n';

  @override
  String get verificationComplete => 'सत्यापन पूर्ण';

  @override
  String get verificationCompleteMessage =>
      'अभिनंदन! आपण आपले ईमेल यशस्वीरित्या सत्यापित केले आहे.';

  @override
  String get verificationFailed => 'सत्यापन अयशस्वी';

  @override
  String get otpMismatch => 'ओटीपी चुकीचा आहे. कृपया पुन्हा प्रयत्न करा';

  @override
  String get otpResent => 'ओटीपी पुन्हा पाठवली गेली';

  @override
  String get requestNewCode => 'नवीन कोड विनंती करा';

  @override
  String get requestNewCodeIn => 'नवीन कोड विनंती करा';

  @override
  String get clickPictureCamera => 'कॅमेरा वापरून चित्र क्लिक करा';

  @override
  String get pickImageGallery => 'गॅलेरीमधून प्रतिमा निवडा';

  @override
  String get deleteMyAccount => 'माझे खाते हटवा';

  @override
  String get createNewRoom => 'नवीन कक्ष तयार करा';

  @override
  String get pleaseEnterScheduledDateTime =>
      'कृपया शेड्यूल केलेली तारीख-वेळ प्रविष्ट करा';

  @override
  String get scheduleDateTimeLabel => 'शेड्यूल तारीख वेळ';

  @override
  String get enterTags => 'टॅग्स प्रविष्ट करा';

  @override
  String get joinCommunity => 'समुदाय सामील व्हा';

  @override
  String get followUsOnX => 'X वर आमचे अनुसरण करा';

  @override
  String get joinDiscordServer => 'Discord सर्व्हर सामील व्हा';

  @override
  String get noLyrics => 'कोणतेही गीत नाहीत';

  @override
  String noStoriesInCategory(String categoryName) {
    return '$categoryName श्रेणीमध्ये सादर करण्यासाठी कोणतीही कथा नाही';
  }

  @override
  String get newChapters => 'नवीन अध्याय';

  @override
  String get helpToGrow => 'वाढायला मदत करा';

  @override
  String get share => 'शेअर करा';

  @override
  String get rate => 'रेटिंग द्या';

  @override
  String get aboutResonate => 'रेजोनेटबद्दल';

  @override
  String get description => 'वर्णन';

  @override
  String get confirm => 'पुष्टी करा';

  @override
  String get classic => 'शास्त्रीय';

  @override
  String get time => 'वेळ';

  @override
  String get vintage => 'विंटेज';

  @override
  String get amber => 'एम्बर';

  @override
  String get forest => 'जंगल';

  @override
  String get cream => 'क्रीम';

  @override
  String get none => 'काहीही नाही';

  @override
  String checkOutGitHub(String url) {
    return 'आमचे GitHub रिपोजिटरी पहा: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'aossie लोगो';

  @override
  String get errorLoadPackageInfo => 'पॅकेज माहिती लोड करू शकत नाही';

  @override
  String get searchFailed => 'कक्ष शोधण्यात अयशस्वी. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध';

  @override
  String get newVersionAvailable => 'नवीन आवृत्ती उपलब्ध आहे!';

  @override
  String get upToDate => 'अद्यावधिक आहे';

  @override
  String get latestVersion => 'आपण नवीनतम आवृत्ती वापरत आहात';

  @override
  String get profileCreatedSuccessfully => 'प्रोफाइल यशस्वीरित्या तयार झाले';

  @override
  String get invalidScheduledDateTime => 'अवैध शेड्यूल केलेली तारीख वेळ';

  @override
  String get scheduledDateTimePast =>
      'शेड्यूल केलेली तारीख वेळ भूतकाळात असू शकत नाही';

  @override
  String get joinRoom => 'कक्षामध्ये सामील व्हा';

  @override
  String get unknownUser => 'अज्ञात';

  @override
  String get canceled => 'रद्द केले';

  @override
  String get english => 'en';

  @override
  String get emailVerificationRequired => 'ईमेल सत्यापन आवश्यक';

  @override
  String get verify => 'सत्यापित करा';

  @override
  String get audioRoom => 'ऑडियो कक्ष';

  @override
  String toRoomAction(String action) {
    return 'कक्ष $action करण्यासाठी';
  }

  @override
  String get mailSentMessage => 'ईमेल पाठवली गेली';

  @override
  String get disconnected => 'जोडलेले नाही';

  @override
  String get micOn => 'मायक्रोफोन';

  @override
  String get speakerOn => 'स्पीकर';

  @override
  String get endChat => 'चॅट समाप्त';

  @override
  String get monthJan => 'जान';

  @override
  String get monthFeb => 'फेब';

  @override
  String get monthMar => 'मार्च';

  @override
  String get monthApr => 'एप्रिल';

  @override
  String get monthMay => 'मे';

  @override
  String get monthJun => 'जून';

  @override
  String get monthJul => 'जुलै';

  @override
  String get monthAug => 'ऑग';

  @override
  String get monthSep => 'सप्ट';

  @override
  String get monthOct => 'ऑक्ट';

  @override
  String get monthNov => 'नोव';

  @override
  String get monthDec => 'डिस';

  @override
  String get register => 'नोंदणी करा';

  @override
  String get newToResonate => 'रेजोनेटमध्ये नवीन? ';

  @override
  String get alreadyHaveAccount => 'पहिल्यापासून खाता आहे? ';

  @override
  String get checking => 'तपास करत आहे...';

  @override
  String get forgotPasswordMessage =>
      'आपला पासवर्ड रीसेट करण्यासाठी नोंदणीकृत ईमेल पत्ता प्रविष्ट करा.';

  @override
  String get usernameUnavailable => 'वापरकर्तानाव उपलब्ध नाही!';

  @override
  String get usernameInvalidOrTaken =>
      'हे वापरकर्तानाव अवैध आहे किंवा आधीच घेतले आहे.';

  @override
  String get otpResentMessage => 'कृपया आपल्या मेलमध्ये नवीन ओटीपी तपासा.';

  @override
  String get connectionError =>
      'कनेक्शन त्रुटी आली आहे. कृपया आपले इंटरनेट तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get seconds => 'सेकंद.';

  @override
  String get unsavedChangesWarning =>
      'जर आपण सेव केल्याशिवाय पुढे जाल तर कोणतेही न-सेव केलेले बदल गमावले जातील.';

  @override
  String get deleteAccountPermanent =>
      'ही क्रिया आपल्या खात्याला कायमचा हटवेल. ही अपरिवर्तनीय प्रक्रिया आहे. आम्ही आपल्या वापरकर्तानाव, ईमेल पत्ता, आणि आपल्या खात्याशी संबंधित सर्व इतर डेटा हटवू. आपण ते पुनर्प्राप्त करू शकणार नाही.';

  @override
  String get giveGreatName => 'एक चांगले नाव द्या..';

  @override
  String get joinCommunityDescription =>
      'समुदायामध्ये जोडून आपण आपल्या संशय स्पष्ट करू शकता, नवीन वैशिष्ट्यांचा प्रस्ताव देऊ शकता, आपण सामोरे आलेल्या समस्यांची रिपोर्ट करू शकता आणि बरेच काही.';

  @override
  String get resonateDescription =>
      'रेजोनेट एक सामाजिक माध्यम मंच आहे, जेथे प्रत्येक आवाज मूल्यवान आहे. आपल्या विचार, कथा, आणि अनुभव दुसऱ्यांसह सामायिक करा. आपल्या ऑडियो यात्रा आता सुरू करा. विविध चर्चा आणि विषयांमध्ये सहभाग घ्या. आपल्याला रुचणारे रेजोनेट कक्ष शोधा आणि समुदायचा भाग बनून सहभाग घ्या. संभाषणामध्ये सामील व्हा! कक्ष अन्वेषण करा, मित्रांशी सामील व्हा, आणि आपल्या आवाज विश्वासह सामायिक करा.';

  @override
  String get resonateFullDescription =>
      'रेजोनेट एक क्रांतिकारी व्हॉयस-आधारित सामाजिक माध्यम मंच आहे जेथे प्रत्येक आवाज महत्वाचा आहे. \nरीअल-टाइम ऑडियो संभाषणामध्ये सामील व्हा, विविध चर्चायोजनांमध्ये भाग घ्या, आणि \nसमान विचारांसह व्यक्तींशी सामील व्हा. आमचे मंच देते:\n- विषय-आधारित चर्चेसह लाइव्ह ऑडियो कक्ष\n- व्हॉयसद्वारे सहज सामाजिक नेटवर्किंग\n- समुदाय-चालित सामग्री मॉडरेशन\n- क्रॉस-मंच सुसंगतता\n- एंड-टू-एंड एन्क्रिप्टेड खाजगी संभाषणे\n\nAOSSIE मुक्त स्रोत समुदायद्वारे विकसित, आम्ही वापरकर्ता गोपनीयता आणि \nसमुदाय-चालित विकासना प्राधान्य देतो. सामाजिक ऑडियोचे भविष्य आकार देण्यामध्ये आमच्यात सामील व्हा!';

  @override
  String get stable => 'स्थिर';

  @override
  String get usernameCharacterLimit =>
      'वापरकर्तानाव किमान ५ अक्षरे असणे आवश्यक आहे.';

  @override
  String get submit => 'सादर करा';

  @override
  String get anonymous => 'अनामिक';

  @override
  String get noSearchResults => 'कोणतेही शोध परिणाम नाहीत';

  @override
  String get searchRooms => 'कक्ष शोधा...';

  @override
  String get searchingRooms => 'कक्ष शोधले जात आहेत...';

  @override
  String get clearSearch => 'शोध साफ करा';

  @override
  String get searchError => 'शोध त्रुटी';

  @override
  String get searchRoomsError =>
      'कक्ष शोधण्यात अयशस्वी. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get searchUpcomingRoomsError =>
      'आगामी कक्ष शोधण्यात अयशस्वी. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get search => 'शोधा';

  @override
  String get clear => 'साफ करा';

  @override
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  ) {
    return '🚀 या अद्भुत कक्ष पहा: $roomName!\n\n📖 वर्णन: $description\n👥 आता $participants सहभागींशी सामील व्हा!';
  }

  @override
  String participantsCount(int count) {
    return '$count सहभागी';
  }

  @override
  String get join => 'सामील व्हा';

  @override
  String get invalidTags => 'अवैध टॅग:';

  @override
  String get cropImage => 'प्रतिमा कापा';

  @override
  String get profileSavedSuccessfully => 'प्रोफाइल अद्यतनित झाले';

  @override
  String get profileUpdatedSuccessfully => 'सर्व बदल यशस्वीरित्या सेव केले.';

  @override
  String get profileUpToDate => 'प्रोफाइल अद्यावधिक आहे';

  @override
  String get noChangesToSave =>
      'कोणतेही नवीन बदल केले नाहीत, सेव करण्यासाठी काहीही नाही.';

  @override
  String get connectionFailed => 'कनेक्शन अयशस्वी';

  @override
  String get unableToJoinRoom =>
      'कक्षामध्ये जोडणे अयशस्वी. कृपया आपल्या नेटवर्क तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get connectionLost => 'कनेक्शन हरवले';

  @override
  String get unableToReconnect =>
      'कक्षाशी पुन्हा कनेक्ट करणे अयशस्वी. कृपया पुन्हा जोडण्याचा प्रयत्न करा.';

  @override
  String get invalidFormat => 'अवैध स्वरूप!';

  @override
  String get usernameAlphanumeric =>
      'वापरकर्तानाव अल्फान्यूमेरिक असणे आवश्यक आहे आणि विशेष अक्षरे असू शकत नाहीत.';

  @override
  String get userProfileCreatedSuccessfully =>
      'आपल्या वापरकर्ता प्रोफाइल यशस्वीरित्या तयार केली.';

  @override
  String get emailVerificationMessage =>
      'पुढे जाण्यासाठी, आपले ईमेल पत्ता सत्यापित करा.';

  @override
  String addNewChaptersToStory(String storyName) {
    return '$storyName मध्ये नवीन अध्याय जोडा';
  }

  @override
  String get currentChapters => 'वर्तमान अध्याय';

  @override
  String get sourceCodeOnGitHub => 'GitHub वर स्रोत कोड';

  @override
  String get createAChapter => 'एक अध्याय तयार करा';

  @override
  String get chapterTitle => 'अध्याय शीर्षक *';

  @override
  String get aboutRequired => 'बद्दल *';

  @override
  String get changeCoverImage => 'कव्हर इमेज बदला';

  @override
  String get uploadAudioFile => 'ऑडियो फाईल अपलोड करा';

  @override
  String get uploadLyricsFile => 'गीत फाईल अपलोड करा';

  @override
  String get createChapter => 'अध्याय तयार करा';

  @override
  String audioFileSelected(String fileName) {
    return 'ऑडियो फाईल निवडली: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'गीत फाईल निवडली: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'कृपया सर्व आवश्यक फील्ड भरा आणि आपल्या ऑडियो फाईल आणि गीत फाईल अपलोड करा';

  @override
  String get scheduled => 'शेड्यूल केलेले';

  @override
  String get ok => 'ठीक आहे';

  @override
  String get roomDescriptionOptional => 'कक्ष वर्णन (वैकल्पिक)';

  @override
  String get deleteAccount => 'खाता हटवा';

  @override
  String get createYourStory => 'आपल्या कथा तयार करा';

  @override
  String get titleRequired => 'शीर्षक *';

  @override
  String get category => 'श्रेणी *';

  @override
  String get addChapter => 'अध्याय जोडा';

  @override
  String get createStory => 'कथा तयार करा';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'कृपया सर्व आवश्यक फील्ड भरा, किमान एक अध्याय जोडा, आणि कव्हर प्रतिमा निवडा.';

  @override
  String get toConfirmType => 'पुष्टी करण्यासाठी, टाइप करा';

  @override
  String get inTheBoxBelow => 'खाली बॉक्समध्ये';

  @override
  String get iUnderstandDeleteMyAccount => 'मी समजतो, माझे खाते हटवा';

  @override
  String get whatDoYouWantToListenTo => 'आपण काय ऐकू इच्छिता?';

  @override
  String get categories => 'श्रेण्या';

  @override
  String get stories => 'कथा';

  @override
  String get someSuggestions => 'काही सूचना';

  @override
  String get getStarted => 'सुरुवात करा';

  @override
  String get skip => 'वगळा';

  @override
  String get welcomeToResonate => 'रेजोनेटमध्ये स्वागतम';

  @override
  String get exploreDiverseConversations => 'विविध संभाषण अन्वेषण करा';

  @override
  String get yourVoiceMatters => 'आपल्या आवाजाला महत्त्व आहे';

  @override
  String get joinConversationExploreRooms =>
      'संभाषणामध्ये सामील व्हा! कक्ष अन्वेषण करा, मित्रांशी सामील व्हा, आणि आपल्या आवाज विश्वासह सामायिक करा.';

  @override
  String get diveIntoDiverseDiscussions =>
      'विविध चर्चा आणि विषयांमध्ये सहभाग घ्या. \nआपल्याला रुचणारे रेजोनेट कक्ष शोधा आणि समुदायचा भाग बनून सहभाग घ्या.';

  @override
  String get atResonateEveryVoiceValued =>
      'रेजोनेटमध्ये, प्रत्येक आवाज मूल्यवान आहे. आपल्या विचार, कथा, आणि अनुभव दुसऱ्यांसह सामायिक करा. आपल्या ऑडियो यात्रा आता सुरू करा.';

  @override
  String get notifications => 'सूचना';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username ने आपल्याला आगामी कक्षामध्ये टॅग केले: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username ने आपल्याला कक्षामध्ये टॅग केले: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username ने आपल्या कथा आवड केली: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username ने आपल्या कक्षसाठी सदस्यता घेतली: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username ने आपले अनुसरण सुरू केले';
  }

  @override
  String get youHaveNewNotification => 'आपल्याला नवीन सूचना आहे';

  @override
  String get hangOnGoodThingsTakeTime =>
      'थामा, चांगल्या गोष्टींसाठी वेळ लागतो 🔍';

  @override
  String get resonateOpenSourceProject =>
      'रेजोनेट AOSSIE द्वारे राखलेला मुक्त स्रोत प्रकल्प आहे. योगदान देण्यासाठी आमचा GitHub पहा.';

  @override
  String get mute => 'मौन करा';

  @override
  String get speakerLabel => 'स्पीकर';

  @override
  String get audioOptions => 'ऑडिओ पर्याय';

  @override
  String get end => 'समाप्त करा';

  @override
  String get saveChanges => 'बदल सेव करा';

  @override
  String get discard => 'रद्द करा';

  @override
  String get save => 'सेव करा';

  @override
  String get changeProfilePicture => 'प्रोफाइल चित्र बदला';

  @override
  String get camera => 'कॅमेरा';

  @override
  String get gallery => 'गॅलेरी';

  @override
  String get remove => 'काढून टाका';

  @override
  String created(String date) {
    return '$date ला तयार केले';
  }

  @override
  String get chapters => 'अध्याय';

  @override
  String get deleteStory => 'कथा हटवा';

  @override
  String createdBy(String creatorName) {
    return '$creatorName द्वारे निर्मित';
  }

  @override
  String get start => 'सुरू करा';

  @override
  String get unsubscribe => 'सदस्यता रद्द करा';

  @override
  String get subscribe => 'सदस्यता घ्या';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'नाटक',
      'comedy': 'हास्य',
      'horror': 'भयानक',
      'romance': 'प्रेम',
      'thriller': 'रोमांच',
      'spiritual': 'आध्यात्मिक',
      'other': 'इतर',
    });
    return '$_temp0';
  }

  @override
  String chooseTheme(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'classicTheme': 'शास्त्रीय',
      'timeTheme': 'वेळ',
      'vintageTheme': 'विंटेज',
      'amberTheme': 'एम्बर',
      'forestTheme': 'जंगल',
      'creamTheme': 'क्रीम',
      'other': 'इतर',
    });
    return '$_temp0';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिनिटे आधी',
      one: '१ मिनिट आधी',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count तास आधी',
      one: '१ तास आधी',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिवस आधी',
      one: '१ दिवस आधी',
    );
    return '$_temp0';
  }

  @override
  String get by => 'द्वारे';

  @override
  String get likes => 'आवडते';

  @override
  String get lengthMinutes => 'मिनिट';

  @override
  String get requiredField => 'आवश्यक फील्ड';

  @override
  String get onlineUsers => 'ऑनलाइन वापरकर्ते';

  @override
  String get noOnlineUsers => 'सध्या कोणतेही वापरकर्ते ऑनलाइन नाहीत';

  @override
  String get chooseUser => 'चॅट करण्यासाठी वापरकर्ता निवडा';

  @override
  String get quickMatch => 'द्रुत जुळणी';

  @override
  String get story => 'कथा';

  @override
  String get user => 'वापरकर्ता';

  @override
  String get following => 'अनुसरण करत आहे';

  @override
  String get followers => 'अनुयायी';

  @override
  String get friendRequests => 'मित्र विनंत्या';

  @override
  String get friendRequestSent => 'मित्र विनंती पाठविली';

  @override
  String friendRequestSentTo(String username) {
    return 'आपल्या मित्र विनंती $username ला पाठवली गेली आहे.';
  }

  @override
  String get friendRequestCancelled => 'मित्र विनंती रद्द';

  @override
  String friendRequestCancelledTo(String username) {
    return 'आपल्या मित्र विनंती $username ला रद्द केली गेली आहे.';
  }

  @override
  String get requested => 'विनंती केली';

  @override
  String get friends => 'मित्र';

  @override
  String get addFriend => 'मित्र जोडा';

  @override
  String get friendRequestAccepted => 'मित्र विनंती स्वीकारली';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'आपण आता $username सह मित्र आहात.';
  }

  @override
  String get friendRequestDeclined => 'मित्र विनंती नकारली';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'आपण $username कडून मित्र विनंती नकारली आहे.';
  }

  @override
  String get accept => 'स्वीकारा';

  @override
  String get callDeclined => 'कॉल नाकारला';

  @override
  String callDeclinedTo(String username) {
    return 'वापरकर्ता $username ने कॉल नाकारला.';
  }

  @override
  String get checkForUpdates => 'अपडेट तपासा';

  @override
  String get updateNow => 'आता अपडेट करा';

  @override
  String get updateLater => 'नंतर';

  @override
  String get updateSuccessful => 'अपडेट यशस्वी';

  @override
  String get updateSuccessfulMessage =>
      'रेजोनेट यशस्वीरित्या अपडेट केली गेली आहे!';

  @override
  String get updateCancelled => 'अपडेट रद्द';

  @override
  String get updateCancelledMessage => 'अपडेट वापरकर्त्याद्वारे रद्द केली गेली';

  @override
  String get updateFailed => 'अपडेट अयशस्वी';

  @override
  String get updateFailedMessage =>
      'अपडेट करणे अयशस्वी. कृपया Play Store मधून वापरकर्तामत्तेने अपडेट करा.';

  @override
  String get updateError => 'अपडेट त्रुटी';

  @override
  String get updateErrorMessage =>
      'अपडेट करताना त्रुटी उद्भवली. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get platformNotSupported => 'मंच समर्थित नाही';

  @override
  String get platformNotSupportedMessage =>
      'अपडेट तपास फक्त Android डिव्हाइसवर उपलब्ध आहे';

  @override
  String get updateCheckFailed => 'अपडेट तपास अयशस्वी';

  @override
  String get updateCheckFailedMessage =>
      'अपडेट तपास करू शकत नाही. कृपया नंतर पुन्हा प्रयत्न करा.';

  @override
  String get upToDateTitle => 'आपण अद्यावधिक आहात!';

  @override
  String get upToDateMessage => 'आपण रेजोनेटचे नवीनतम आवृत्ती वापरत आहात';

  @override
  String get updateAvailableTitle => 'अपडेट उपलब्ध!';

  @override
  String get updateAvailableMessage =>
      'रेजोनेटचे नवीन आवृत्ती Play Store वर उपलब्ध आहे';

  @override
  String get updateFeaturesImprovement => 'नवीन वैशिष्ट्य आणि सुधार मिळवा!';

  @override
  String get failedToRemoveRoom => 'कक्ष काढून टाकण्यात अयशस्वी';

  @override
  String get roomRemovedSuccessfully =>
      'कक्ष आपल्या यादीतून यशस्वीरित्या काढून टाकला';

  @override
  String get alert => 'सतर्क';

  @override
  String get removedFromRoom =>
      'आपल्यावर तक्रार नोंदवण्यात आली आहे किंवा आपल्याला कक्षातून काढून देण्यात आले आहे';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'उत्पीडन / द्वेष भाषण',
      'abuse': 'अपमानजनक सामग्री / हिंसा',
      'spam': 'स्पॅम / घोटाळे / धोखाधरी',
      'impersonation': 'खोटी ओळख / खोटे खाते',
      'illegal': 'अवैध क्रियाकलाप',
      'selfharm': 'आत्महानि / आत्महत्या / मानसिक स्वास्थ्य',
      'misuse': 'मंचचा दुरुपयोग',
      'other': 'इतर',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate =>
      'आपल्याविरुद्ध अनेक तक्रारी नोंदवण्यात आल्या आहेत आणि आपल्याला रेजोनेट वापरणे ब्लॉक करण्यात आले आहे. आपण यावर विश्वास करत नाही असल्यास कृपया AOSSIE शी संपर्क करा.';

  @override
  String get reportParticipant => 'सहभागी रिपोर्ट करा';

  @override
  String get selectReportType => 'कृपया रिपोर्ट प्रकार निवडा';

  @override
  String get reportSubmitted => 'तक्रार यशस्वीरित्या सादर करण्यात आली';

  @override
  String get reportFailed => 'तक्रार सादर करणे अयशस्वी झाले';

  @override
  String get additionalDetailsOptional => 'अतिरिक्त विवरण (वैकल्पिक)';

  @override
  String get submitReport => 'रिपोर्ट सबमिट करा';

  @override
  String get actionBlocked => 'क्रिया ब्लॉक केली';

  @override
  String get cannotStopRecording =>
      'आपण रेकॉर्डिंग स्वतःहून थांबवू शकत नाही, कक्ष बंद होताच रेकॉर्डिंग थांबवली जाईल.';

  @override
  String get liveChapter => 'लाइव्ह अध्याय';

  @override
  String get viewOrEditLyrics => 'गीत पाहा किंवा संपादित करा';

  @override
  String get close => 'बंद करा';

  @override
  String get verifyChapterDetails => 'अध्याय तपशील सत्यापित करा';

  @override
  String get author => 'लेखक';

  @override
  String get startLiveChapter => 'लाइव्ह अध्याय सुरू करा';

  @override
  String get fillAllFields => 'कृपया सर्व आवश्यक फील्ड भरा';

  @override
  String get noRecordingError =>
      'आपण अध्यायसाठी कोणतेही रेकॉर्डिंग केलेले नाही. कक्ष बंद करण्यापूर्वी कृपया अध्याय रेकॉर्ड करा';

  @override
  String get audioOutput => 'ऑडिओ आउटपुट';

  @override
  String get selectPreferredSpeaker => 'आपला पसंतीचा स्पीकर निवडा';

  @override
  String get noAudioOutputDevices => 'कोणतेही ऑडिओ आउटपुट उपकरण आढळले नाही';

  @override
  String get refresh => 'रीफ्रेश करा';

  @override
  String get done => 'पूर्ण झाले';

  @override
  String get deleteMessageTitle => 'संदेश हटवा';

  @override
  String get deleteMessageContent => 'आपण खरोखर हा संदेश हटवू इच्छिता का?';

  @override
  String get thisMessageWasDeleted => 'हा संदेश हटवण्यात आला';

  @override
  String get failedToDeleteMessage => 'संदेश हटवण्यात अयशस्वी';

  @override
  String get usernameInvalidFormat =>
      'कृपया वैध वापरकर्तानाव प्रविष्ट करा. फक्त अक्षरे, अंक, बिंदू, अंडरस्कोअर आणि हायफनला परवानगी आहे.';

  @override
  String get usernameAlreadyTaken =>
      'हे वापरकर्तानाव आधीच घेतले गेले आहे. वेगळे वापरकर्तानाव वापरून पहा.';
}
