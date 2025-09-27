// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get title => 'रेझोनेट';

  @override
  String get roomDescription =>
      'सभ्य रहा आणि दुसऱ्याच्या मताचा आदर करा. उद्धट टिप्पण्या टाळा.';

  @override
  String get hidePassword => 'पासवर्ड लपवा';

  @override
  String get showPassword => 'पासवर्ड दाखवा';

  @override
  String get passwordEmpty => 'पासवर्ड रिकामा असू शकत नाही';

  @override
  String get password => 'पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्डची पुष्टी करा';

  @override
  String get passwordsNotMatch => 'पासवर्ड जुळत नाहीत';

  @override
  String get userCreatedStories => 'वापरकर्त्याने तयार केलेल्या कथा';

  @override
  String get yourStories => 'तुमच्या कथा';

  @override
  String get userNoStories => 'वापरकर्त्याने कोणतीही कथा तयार केलेली नाही';

  @override
  String get youNoStories => 'तुम्ही कोणतीही कथा तयार केलेली नाही';

  @override
  String get follow => 'अनुसरण करा';

  @override
  String get editProfile => 'प्रोफाइल संपादित करा';

  @override
  String get verifyEmail => 'ईमेल सत्यापित करा';

  @override
  String get verified => 'सत्यापित';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get userLikedStories => 'वापरकर्त्याला आवडलेल्या कथा';

  @override
  String get yourLikedStories => 'तुम्हाला आवडलेल्या कथा';

  @override
  String get userNoLikedStories => 'वापरकर्त्याने कोणतीही कथा पसंत केलेली नाही';

  @override
  String get youNoLikedStories => 'तुम्ही कोणतीही कथा पसंत केलेली नाही';

  @override
  String get live => 'थेट';

  @override
  String get upcoming => 'आगामी';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'कोणतीही खोली उपलब्ध नाही',
      'false': 'कोणतीही आगामी खोली उपलब्ध नाही',
      'other': 'खोलीची माहिती उपलब्ध नाही',
    });
    return '$_temp0\nखाली एक जोडून सुरुवात करा!';
  }

  @override
  String get user1 => 'वापरकर्ता 1';

  @override
  String get user2 => 'वापरकर्ता 2';

  @override
  String get you => 'तुम्ही';

  @override
  String get areYouSure => 'तुम्हाला खात्री आहे का?';

  @override
  String get loggingOut => 'तुम्ही Resonate मधून लॉगआउट करत आहात.';

  @override
  String get yes => 'होय';

  @override
  String get no => 'नाही';

  @override
  String get incorrectEmailOrPassword => 'ईमेल किंवा पासवर्ड चुकीचा आहे';

  @override
  String get passwordShort => 'पासवर्ड ८ अक्षरांपेक्षा कमी आहे';

  @override
  String get tryAgain => 'पुन्हा प्रयत्न करा!';

  @override
  String get success => 'यशस्वी';

  @override
  String get passwordResetSent => 'पासवर्ड रीसेटसाठी ईमेल पाठवण्यात आला!';

  @override
  String get error => 'त्रुटी';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करा';

  @override
  String get enterNewPassword => 'तुमचा नवीन पासवर्ड टाका';

  @override
  String get newPassword => 'नवीन पासवर्ड';

  @override
  String get setNewPassword => 'नवीन पासवर्ड सेट करा';

  @override
  String get emailChanged => 'ईमेल बदलला';

  @override
  String get emailChangeSuccess => 'ईमेल यशस्वीरित्या बदलला!';

  @override
  String get failed => 'अयशस्वी';

  @override
  String get emailChangeFailed => 'ईमेल बदलण्यात अयशस्वी';

  @override
  String get oops => 'अरे!';

  @override
  String get emailExists => 'ईमेल आधीच अस्तित्वात आहे';

  @override
  String get changeEmail => 'ईमेल बदला';

  @override
  String get enterValidEmail => 'कृपया वैध ईमेल पत्ता प्रविष्ट करा';

  @override
  String get newEmail => 'नवीन ईमेल';

  @override
  String get currentPassword => 'सध्याचा पासवर्ड';

  @override
  String get emailChangeInfo =>
      'अधिक सुरक्षिततेसाठी, ईमेल बदलताना तुमच्या खात्याचा सध्याचा पासवर्ड प्रविष्ट करणे आवश्यक आहे. ईमेल बदलल्यानंतर, भविष्यात लॉगिनसाठी अद्ययावत ईमेल वापरा.';

  @override
  String get oauthUsersMessage =>
      '(फक्त Google किंवा Github वापरून लॉगिन केलेल्या वापरकर्त्यांसाठी)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'तुमचा ईमेल बदलण्यासाठी, कृपया \"सध्याचा पासवर्ड\" फील्डमध्ये नवीन पासवर्ड प्रविष्ट करा. हा पासवर्ड लक्षात ठेवा, कारण भविष्यातील ईमेल बदलांसाठी तो आवश्यक असेल. पुढे तुम्ही Google/GitHub किंवा तुमच्या नवीन ईमेल आणि पासवर्ड संयोजनाने लॉगिन करू शकता.';

  @override
  String get resonateTagline => 'अमर्याद संवादांच्या जगात प्रवेश करा.';

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
  String get resonateLogo => 'Resonate लोगो';

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
  String get moderator => 'मध्यस्थ';

  @override
  String get speaker => 'वक्ते';

  @override
  String get listener => 'श्रोता';

  @override
  String get removeModerator => 'मध्यस्थ हटवा';

  @override
  String get kickOut => 'बाहेर टाका';

  @override
  String get addModerator => 'मध्यस्थ जोडा';

  @override
  String get addSpeaker => 'वक्ते जोडा';

  @override
  String get makeListener => 'श्रोता बनवा';

  @override
  String get pairChat => 'जोडी गप्पा';

  @override
  String get chooseIdentity => 'ओळख निवडा';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get noConnection => 'कनेक्शन नाही';

  @override
  String get loadingDialog => 'लोडिंग संवाद';

  @override
  String get createAccount => 'खाते तयार करा';

  @override
  String get enterValidEmailAddress => 'वैध ईमेल पत्ता प्रविष्ट करा';

  @override
  String get email => 'ईमेल';

  @override
  String get passwordRequirements => 'पासवर्ड किमान ८ अक्षरांचा असावा';

  @override
  String get includeNumericDigit => 'किमान १ अंक असावा';

  @override
  String get includeUppercase => 'किमान १ मोठ्या अक्षराचा समावेश असावा';

  @override
  String get includeLowercase => 'किमान १ लहान अक्षराचा समावेश असावा';

  @override
  String get includeSymbol => 'किमान १ चिन्ह असावे';

  @override
  String get signedUpSuccessfully => 'यशस्वीरित्या साइन अप केले';

  @override
  String get newAccountCreated => 'तुमचे नवीन खाते यशस्वीरित्या तयार झाले आहे';

  @override
  String get signUp => 'नोंदणी करा';

  @override
  String get login => 'लॉगिन';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get accountSettings => 'खात्याच्या सेटिंग्ज';

  @override
  String get account => 'खाते';

  @override
  String get appSettings => 'अ‍ॅप सेटिंग्ज';

  @override
  String get themes => 'थीम्स';

  @override
  String get about => 'विषयी';

  @override
  String get other => 'इतर';

  @override
  String get contribute => 'योगदान द्या';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get participants => 'सहभागी';

  @override
  String get delete => 'हटवा';

  @override
  String get leave => 'सोडा';

  @override
  String get leaveButton => 'बाहेर पडा';

  @override
  String get findingRandomPartner =>
      'तुमच्यासाठी एखादा अनोळखी जोडीदार शोधत आहे';

  @override
  String get quickFact => 'लघु माहिती';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get completeYourProfile => 'तुमचे प्रोफाइल पूर्ण करा';

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
  String get next => 'पुढे';

  @override
  String get noStoriesExist => 'प्रस्तुत करण्यासाठी कोणत्याही कथा उपलब्ध नाहीत';

  @override
  String get enterVerificationCode => 'तुमचा\nसत्यापन कोड प्रविष्ट करा';

  @override
  String get verificationCodeSent => 'आम्ही ६-अंकी सत्यापन कोड पाठवला आहे\n';

  @override
  String get verificationComplete => 'सत्यापन पूर्ण झाले';

  @override
  String get verificationCompleteMessage =>
      'अभिनंदन! तुम्ही तुमचा ईमेल सत्यापित केला आहे';

  @override
  String get verificationFailed => 'सत्यापन अयशस्वी';

  @override
  String get otpMismatch => 'OTP जुळत नाही, कृपया पुन्हा प्रयत्न करा';

  @override
  String get otpResent => 'OTP पुन्हा पाठवला';

  @override
  String get requestNewCode => 'नवीन कोडची विनंती करा';

  @override
  String get requestNewCodeIn => 'नवीन कोडची विनंती करा';

  @override
  String get clickPictureCamera => 'कॅमेऱ्याचा वापर करून फोटो काढा';

  @override
  String get pickImageGallery => 'गॅलरीमधून प्रतिमा निवडा';

  @override
  String get deleteMyAccount => 'माझे खाते हटवा';

  @override
  String get createNewRoom => 'नवीन खोली तयार करा';

  @override
  String get pleaseEnterScheduledDateTime =>
      'कृपया नियोजित दिनांक-वेळ प्रविष्ट करा';

  @override
  String get scheduleDateTimeLabel => 'नियोजित दिनांक वेळ';

  @override
  String get enterTags => 'टॅग्स प्रविष्ट करा';

  @override
  String get joinCommunity => 'समुदायात सामील व्हा';

  @override
  String get followUsOnX => 'X वर आम्हाला फॉलो करा';

  @override
  String get joinDiscordServer => 'Discord सर्व्हरमध्ये सामील व्हा';

  @override
  String get noLyrics => 'गीत उपलब्ध नाहीत';

  @override
  String get aboutSection => 'विषयी विभाग';

  @override
  String noStoriesInCategory(String categoryName) {
    return '$categoryName श्रेणीत सध्या कोणत्याही कथा उपलब्ध नाहीत';
  }

  @override
  String get pushNewChapters => 'नवीन अध्याय जोडा';

  @override
  String get helpToGrow => 'वाढीस मदत करा';

  @override
  String get share => 'शेअर करा';

  @override
  String get rate => 'रेट करा';

  @override
  String get aboutResonate => 'Resonate विषयी';

  @override
  String get description => 'वर्णन';

  @override
  String get confirm => 'पुष्टी करा';

  @override
  String get classic => 'क्लासिक';

  @override
  String get time => 'वेळ';

  @override
  String get vintage => 'विंटेज';

  @override
  String get amber => 'अंबर';

  @override
  String get forest => 'वन';

  @override
  String get cream => 'क्रीम';

  @override
  String get none => 'काही नाही';

  @override
  String checkOutGitHub(String url) {
    return 'आमच्या GitHub रेपॉझिटरीला भेट द्या: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'AOSSIE लोगो';

  @override
  String get errorLoadPackageInfo => 'पॅकेज माहिती लोड करता आली नाही';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध आहे';

  @override
  String get newVersionAvailable => 'नवीन आवृत्ती उपलब्ध आहे!';

  @override
  String get upToDate => 'सर्वात अद्ययावत';

  @override
  String get latestVersion => 'तुम्ही नवीनतम आवृत्ती वापरत आहात';

  @override
  String get profileCreatedSuccessfully => 'प्रोफाइल यशस्वीरित्या तयार झाले';

  @override
  String get invalidScheduledDateTime => 'अवैध नियोजित दिनांक वेळ';

  @override
  String get scheduledDateTimePast =>
      'नियोजित दिनांक वेळ भूतकाळात असू शकत नाही';

  @override
  String get joinRoom => 'खोलीत सामील व्हा';

  @override
  String get loadingDialogName => 'लोडिंग संवाद';

  @override
  String get unknownUser => 'अज्ञात';

  @override
  String get canceled => 'रद्द केले';

  @override
  String get english => 'en';

  @override
  String get emailVerificationRequired => 'ईमेल सत्यापन आवश्यक आहे';

  @override
  String get verify => 'सत्यापित करा';

  @override
  String get audioRoom => 'ऑडिओ खोली';

  @override
  String toRoomAction(String action) {
    return 'खोली $action करण्यासाठी';
  }

  @override
  String get mailSentMessage => 'मेल पाठवला गेला';

  @override
  String get disconnected => 'कनेक्शन तुटले';

  @override
  String get micOn => 'माइक';

  @override
  String get speakerOn => 'स्पीकर';

  @override
  String get endChat => 'गप्पा समाप्त करा';

  @override
  String get monthJan => 'जानेवारी';

  @override
  String get monthFeb => 'फेब्रुवारी';

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
  String get monthAug => 'ऑगस्ट';

  @override
  String get monthSep => 'सप्टेंबर';

  @override
  String get monthOct => 'ऑक्टोबर';

  @override
  String get monthNov => 'नोव्हेंबर';

  @override
  String get monthDec => 'डिसेंबर';

  @override
  String get register => 'नोंदणी करा';

  @override
  String get newToResonate => 'Resonate मध्ये नवीन आहात?';

  @override
  String get alreadyHaveAccount => 'आधीच खाते आहे?';

  @override
  String get checking => 'तपासत आहे...';

  @override
  String get forgotPasswordMessage =>
      'तुमचा नोंदणीकृत ईमेल पत्ता प्रविष्ट करा जेणेकरून पासवर्ड रीसेट करता येईल.';

  @override
  String get usernameUnavailable => 'वापरकर्तानाव उपलब्ध नाही!';

  @override
  String get usernameInvalidOrTaken =>
      'हे वापरकर्तानाव अवैध आहे किंवा आधीच घेतले गेले आहे.';

  @override
  String get otpResentMessage => 'कृपया नवीन OTP साठी तुमचा मेल तपासा.';

  @override
  String get connectionError =>
      'कनेक्शनमध्ये त्रुटी आहे. कृपया तुमचे इंटरनेट तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get seconds => 'सेकंद.';

  @override
  String get unsavedChangesWarning =>
      'जर तुम्ही सेव न करता पुढे गेलात, तर न सहेवलेले बदल गमावले जातील.';

  @override
  String get deleteAccountPermanent =>
      'ही कृती तुमचे खाते कायमचे हटवेल. ही प्रक्रिया अपरिवर्तनीय आहे. आम्ही तुमचे वापरकर्तानाव, ईमेल पत्ता आणि खात्याशी संबंधित सर्व डेटा हटवू. तुम्ही ते पुनर्प्राप्त करू शकणार नाही.';

  @override
  String get giveGreatName => 'एक उत्तम नाव द्या..';

  @override
  String get joinCommunityDescription =>
      'समुदायात सामील होऊन तुम्ही तुमचे शंका दूर करू शकता, नवीन वैशिष्ट्यांसाठी सूचना देऊ शकता, तुम्हाला आलेल्या अडचणी नोंदवू शकता आणि बरेच काही.';

  @override
  String get resonateDescription =>
      'Resonate हे एक सामाजिक मीडिया प्लॅटफॉर्म आहे जिथे प्रत्येक आवाजाला महत्त्व दिले जाते. तुमचे विचार, कथा आणि अनुभव इतरांसोबत शेअर करा. तुमचा ऑडिओ प्रवास सुरू करा. विविध चर्चांमध्ये सहभागी व्हा. तुमच्याशी जुळणाऱ्या खोल्या शोधा आणि समुदायाचा भाग बना. संवादात सामील व्हा!';

  @override
  String get resonateFullDescription =>
      'Resonate हे एक क्रांतिकारी आवाज-आधारित सामाजिक मीडिया प्लॅटफॉर्म आहे जिथे प्रत्येक आवाज महत्त्वाचा आहे.\nरिअल-टाइम ऑडिओ संवादात सहभागी व्हा, विविध चर्चांमध्ये भाग घ्या आणि\nसमान विचार असलेल्या लोकांशी संपर्क साधा. आमचा प्लॅटफॉर्म प्रदान करतो:\n- विषय-आधारित चर्चांसाठी थेट ऑडिओ खोल्या\n- आवाजाद्वारे सहज सामाजिक नेटवर्किंग\n- समुदाय-आधारित सामग्री नियंत्रण\n- क्रॉस-प्लॅटफॉर्म सुसंगतता\n- एंड-टू-एंड एन्क्रिप्टेड खाजगी संवाद\n\nAOSSIE ओपन सोर्स समुदायाद्वारे विकसित, आम्ही वापरकर्त्याच्या गोपनीयतेला आणि\nसमुदाय-आधारित विकासाला प्राधान्य देतो. सामाजिक ऑडिओचे भविष्य घडवण्यासाठी आमच्यात सामील व्हा!';

  @override
  String get stable => 'स्थिर';

  @override
  String get congratulationsEmailVerified =>
      'अभिनंदन! तुम्ही तुमचा ईमेल सत्यापित केला आहे';

  @override
  String get otpMismatchError => 'OTP जुळत नाही, कृपया पुन्हा प्रयत्न करा';

  @override
  String get usernameCharacterLimit =>
      'वापरकर्तानावात किमान ५ पेक्षा जास्त अक्षरे असावीत.';

  @override
  String get submit => 'सबमिट करा';

  @override
  String get anonymous => 'अनामिक';

  @override
  String get resonate => 'Resonate';

  @override
  String get noSearchResults => 'शोध परिणाम नाहीत';

  @override
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  ) {
    return '🚀 या अद्भुत खोलीला एकदा नक्की भेट द्या: $roomName!\n\n📖 वर्णन: $description\n👥 आत्ता $participants सहभागी व्हा!';
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
  String get cropImage => 'प्रतिमा क्रॉप करा';

  @override
  String get profileSavedSuccessfully => 'प्रोफाइल अद्ययावत झाले';

  @override
  String get profileUpdatedSuccessfully =>
      'सर्व बदल यशस्वीरित्या सेव्ह झाले आहेत.';

  @override
  String get profileUpToDate => 'प्रोफाइल अद्ययावत आहे';

  @override
  String get noChangesToSave =>
      'कोणतेही नवीन बदल केले नाहीत, सेव्ह करण्यास काही नाही.';

  @override
  String get connectionFailed => 'कनेक्शन अयशस्वी';

  @override
  String get unableToJoinRoom =>
      'खोलीत सामील होऊ शकत नाही. कृपया तुमचे नेटवर्क तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get connectionLost => 'कनेक्शन तुटले';

  @override
  String get unableToReconnect =>
      'खोलीशी पुन्हा कनेक्ट होऊ शकत नाही. कृपया पुन्हा सामील होण्याचा प्रयत्न करा.';

  @override
  String get invalidFormat => 'अवैध स्वरूप!';

  @override
  String get usernameAlphanumeric =>
      'वापरकर्तानाव अल्फान्यूमेरिक असावे आणि विशेष चिन्हे नसावीत.';

  @override
  String get userProfileCreatedSuccessfully =>
      'तुमचे वापरकर्ता प्रोफाइल यशस्वीरित्या तयार झाले आहे.';

  @override
  String get emailVerificationMessage =>
      'पुढे जाण्यासाठी, तुमचा ईमेल पत्ता सत्यापित करा.';

  @override
  String addNewChaptersToStory(String storyName) {
    return '$storyName मध्ये नवीन अध्याय जोडा';
  }

  @override
  String get currentChapters => 'सध्याचे अध्याय';

  @override
  String get newChapters => 'नवीन अध्याय';

  @override
  String get sourceCodeOnGitHub => 'GitHub वरील स्रोत कोड';

  @override
  String get createAChapter => 'अध्याय तयार करा';

  @override
  String get chapterTitle => 'अध्यायाचे शीर्षक *';

  @override
  String get aboutRequired => 'वर्णन *';

  @override
  String get changeCoverImage => 'कव्हर प्रतिमा बदला';

  @override
  String get uploadAudioFile => 'ऑडिओ फाइल अपलोड करा';

  @override
  String get uploadLyricsFile => 'गीत फाइल अपलोड करा';

  @override
  String get createChapter => 'अध्याय तयार करा';

  @override
  String audioFileSelected(String fileName) {
    return 'निवडलेली ऑडिओ फाइल: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'निवडलेली गीत फाइल: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'कृपया सर्व आवश्यक फील्ड भरा आणि तुमची ऑडिओ व गीत फाइल अपलोड करा';

  @override
  String get scheduled => 'नियोजित';

  @override
  String get ok => 'ठीक आहे';

  @override
  String get roomDescriptionOptional => 'खोलीचे वर्णन (ऐच्छिक)';

  @override
  String get deleteAccount => 'खाते हटवा';

  @override
  String get createYourStory => 'तुमची कथा तयार करा';

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
      'कृपया सर्व आवश्यक फील्ड भरा, किमान एक अध्याय जोडा आणि कव्हर प्रतिमा निवडा.';

  @override
  String get toConfirmType => 'पुष्टी करण्यासाठी टाइप करा';

  @override
  String get inTheBoxBelow => 'खालील बॉक्समध्ये';

  @override
  String get iUnderstandDeleteMyAccount =>
      'माझे खाते हटवले जाईल हे मला समजले आहे';

  @override
  String get whatDoYouWantToListenTo => 'तुम्हाला काय ऐकायचे आहे?';

  @override
  String get categories => 'श्रेण्या';

  @override
  String get stories => 'कथा';

  @override
  String get someSuggestions => 'काही सूचना';

  @override
  String get getStarted => 'सुरू करा';

  @override
  String get skip => 'वगळा';

  @override
  String get welcomeToResonate => 'Resonate मध्ये स्वागत आहे';

  @override
  String get exploreDiverseConversations => 'विविध संवादांचा शोध घ्या';

  @override
  String get yourVoiceMatters => 'तुमचा आवाज महत्त्वाचा आहे';

  @override
  String get joinConversationExploreRooms =>
      'संवादात सामील व्हा! खोल्यांचा शोध घ्या, मित्रांशी संपर्क साधा आणि तुमचा आवाज जगासोबत शेअर करा.';

  @override
  String get diveIntoDiverseDiscussions =>
      'विविध चर्चांमध्ये सहभागी व्हा.\nतुमच्याशी जुळणाऱ्या खोल्या शोधा आणि समुदायाचा भाग बना.';

  @override
  String get atResonateEveryVoiceValued =>
      'Resonate मध्ये प्रत्येक आवाजाला महत्त्व दिले जाते. तुमचे विचार, कथा आणि अनुभव शेअर करा. तुमचा ऑडिओ प्रवास सुरू करा.';

  @override
  String get notifications => 'सूचना';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username ने तुम्हाला आगामी खोलीत टॅग केले: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username ने तुम्हाला खोलीत टॅग केले: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username ला तुमची कथा आवडली: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username ने तुमच्या खोलीची सदस्यता घेतली: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username ने तुम्हाला फॉलो करायला सुरुवात केली';
  }

  @override
  String get youHaveNewNotification => 'तुमच्याकडे नवीन सूचना आहे';

  @override
  String get hangOnGoodThingsTakeTime =>
      'थोडं थांबा, चांगल्या गोष्टी वेळ घेतात 🔍';

  @override
  String get resonateOpenSourceProject =>
      'Resonate हे AOSSIE द्वारे देखरेख केलेले एक ओपन सोर्स प्रोजेक्ट आहे. योगदान देण्यासाठी आमच्या GitHub ला भेट द्या.';

  @override
  String get mute => 'म्यूट करा';

  @override
  String get speakerLabel => 'वक्ते';

  @override
  String get end => 'समाप्त करा';

  @override
  String get saveChanges => 'बदल सेव्ह करा';

  @override
  String get discard => 'रद्द करा';

  @override
  String get save => 'सेव्ह करा';

  @override
  String get changeProfilePicture => 'प्रोफाइल चित्र बदला';

  @override
  String get camera => 'कॅमेरा';

  @override
  String get gallery => 'गॅलरी';

  @override
  String get remove => 'हटवा';

  @override
  String created(String date) {
    return '$date रोजी तयार केले';
  }

  @override
  String get aboutStory => 'कथेविषयी';

  @override
  String get chapters => 'अध्याय';

  @override
  String get deleteStory => 'कथा हटवा';

  @override
  String createdBy(String creatorName) {
    return '$creatorName ने तयार केले';
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
      'comedy': 'कॉमेडी',
      'horror': 'भीती',
      'romance': 'रोमांस',
      'thriller': 'थ्रिलर',
      'spiritual': 'आध्यात्मिक',
      'other': 'इतर',
    });
    return '$_temp0';
  }

  @override
  String chooseTheme(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'classicTheme': 'क्लासिक',
      'timeTheme': 'वेळ',
      'vintageTheme': 'विंटेज',
      'amberTheme': 'अंबर',
      'forestTheme': 'वन',
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
      other: '$count मिनिटांपूर्वी',
      one: '१ मिनिटापूर्वी',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count तासांपूर्वी',
      one: '१ तासापूर्वी',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिवसांपूर्वी',
      one: '१ दिवसापूर्वी',
    );
    return '$_temp0';
  }

  @override
  String get by => 'द्वारे';

  @override
  String get likes => 'पसंती';

  @override
  String get lengthMinutes => 'मिनिटे';

  @override
  String get requiredField => 'आवश्यक फील्ड';

  @override
  String get clickPictureUsingCamera => 'कॅमेरा वापरून फोटो काढा';

  @override
  String get pickImageFromGallery => 'गॅलरीमधून प्रतिमा निवडा';

  @override
  String get onlineUsers => 'ऑनलाइन वापरकर्ते';

  @override
  String get noOnlineUsers => 'सध्या कोणतेही वापरकर्ते ऑनलाइन नाहीत';

  @override
  String get chooseUser => 'गप्पा मारण्यासाठी वापरकर्ता निवडा';

  @override
  String get quickMatch => 'त्वरित जुळवणी';

  @override
  String get story => 'कथा';

  @override
  String get user => 'वापरकर्ता';

  @override
  String get following => 'अनुसरण करत आहे';

  @override
  String get followers => 'अनुसरण करणारे';

  @override
  String get checkForUpdates => 'अपडेट तपासा';

  @override
  String get updateNow => 'आता अपडेट करा';

  @override
  String get updateLater => 'नंतर';

  @override
  String get updateSuccessful => 'अपडेट यशस्वी';

  @override
  String get updateSuccessfulMessage => 'Resonate यशस्वीरित्या अपडेट झाले आहे!';

  @override
  String get updateCancelled => 'अपडेट रद्द केले';

  @override
  String get updateCancelledMessage => 'वापरकर्त्याने अपडेट रद्द केले';

  @override
  String get updateFailed => 'अपडेट अयशस्वी';

  @override
  String get updateFailedMessage =>
      'अपडेट करण्यात अयशस्वी. कृपया Play Store वरून हाताने अपडेट करा.';

  @override
  String get updateError => 'अपडेट त्रुटी';

  @override
  String get updateErrorMessage =>
      'अपडेट करताना त्रुटी आली. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get platformNotSupported => 'प्लॅटफॉर्म समर्थित नाही';

  @override
  String get platformNotSupportedMessage =>
      'अपडेट तपासणी फक्त Android डिव्हाइसेसवर उपलब्ध आहे';

  @override
  String get updateCheckFailed => 'अपडेट तपासणी अयशस्वी';

  @override
  String get updateCheckFailedMessage =>
      'अपडेट तपासता आले नाही. कृपया नंतर प्रयत्न करा.';

  @override
  String get upToDateTitle => 'तुमचे अ‍ॅप अद्ययावत आहे!';

  @override
  String get upToDateMessage => 'तुम्ही Resonate ची नवीनतम आवृत्ती वापरत आहात';

  @override
  String get updateAvailableTitle => 'नवीन अपडेट उपलब्ध!';

  @override
  String get updateAvailableMessage =>
      'Resonate ची नवीन आवृत्ती Play Store वर उपलब्ध आहे';

  @override
  String get updateFeaturesImprovement => 'नवीन वैशिष्ट्ये आणि सुधारणा मिळवा!';

  @override
  String get friendRequests => 'मित्र विनंत्या';

  @override
  String get friendRequestSent => 'मित्र विनंती पाठवली';

  @override
  String friendRequestSentTo(String username) {
    return '$username ला तुमची मित्र विनंती पाठवली गेली आहे.';
  }

  @override
  String get friendRequestCancelled => 'मित्र विनंती रद्द केली';

  @override
  String friendRequestCancelledTo(String username) {
    return 'तुमची $username ला पाठवलेली मित्र विनंती रद्द केली गेली आहे.';
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
    return 'तुम्ही आता \$$username चे मित्र आहात.';
  }

  @override
  String get friendRequestDeclined => 'मित्र विनंती नाकारली';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'तुम्ही \$$username कडून आलेली मित्र विनंती नाकारली आहे.';
  }

  @override
  String get accept => 'स्वीकारा';

  @override
  String get callDeclined => 'कॉल नाकारला';

  @override
  String callDeclinedTo(String username) {
    return 'वापरकर्ता \$$username ने कॉल नाकारला.';
  }
}
