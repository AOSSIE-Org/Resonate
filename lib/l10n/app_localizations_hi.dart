// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get title => 'रेज़ोनेट';

  @override
  String get roomDescription =>
      'विनम्र रहें और दूसरे व्यक्ति की राय का सम्मान करें। अभद्र टिप्पणियों से बचें।';

  @override
  String get hidePassword => 'पासवर्ड छिपाएं';

  @override
  String get showPassword => 'पासवर्ड दिखाएं';

  @override
  String get passwordEmpty => 'पासवर्ड खाली नहीं हो सकता';

  @override
  String get password => 'पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get passwordsNotMatch => 'पासवर्ड मेल नहीं खा रहे हैं';

  @override
  String get userCreatedStories => 'यूज़र की बनाई कहानियाँ';

  @override
  String get yourStories => 'तुम्हारी कहानियाँ';

  @override
  String get userNoStories => 'यूज़र ने अभी तक कोई कहानी नहीं बनाई';

  @override
  String get youNoStories => 'तुमने अभी तक कोई कहानी नहीं बनाई';

  @override
  String get follow => 'फॉलो करो';

  @override
  String get editProfile => 'प्रोफाइल एडिट करो';

  @override
  String get verifyEmail => 'ईमेल वेरीफाई करो';

  @override
  String get verified => 'वेरीफाइड';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get userLikedStories => 'यूज़र को पसंद आई कहानियाँ';

  @override
  String get yourLikedStories => 'तुम्हें पसंद आई कहानियाँ';

  @override
  String get userNoLikedStories => 'यूज़र ने अभी तक कोई कहानी लाइक नहीं की';

  @override
  String get youNoLikedStories => 'तुमने अभी तक कोई कहानी लाइक नहीं की';

  @override
  String get live => 'लाइव';

  @override
  String get upcoming => 'आने वाला';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'कोई रूम उपलब्ध नहीं है',
      'false': 'कोई आने वाला रूम उपलब्ध नहीं है',
      'other': 'रूम की जानकारी उपलब्ध नहीं है',
    });
    return '$_temp0\nनीचे से एक रूम बनाकर शुरुआत करें!';
  }

  @override
  String get user1 => 'यूज़र 1';

  @override
  String get user2 => 'यूज़र 2';

  @override
  String get you => 'तुम';

  @override
  String get areYouSure => 'क्या आप पक्के हैं?';

  @override
  String get loggingOut => 'आप रेज़ोनेट से लॉग आउट हो रहे हैं।';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get incorrectEmailOrPassword => 'ईमेल या पासवर्ड गलत है';

  @override
  String get passwordShort => 'पासवर्ड 8 अक्षर से छोटा है';

  @override
  String get tryAgain => 'फिर कोशिश करो!';

  @override
  String get success => 'सफलता';

  @override
  String get passwordResetSent => 'पासवर्ड रीसेट ईमेल भेजा गया!';

  @override
  String get error => 'गलती';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करो';

  @override
  String get enterNewPassword => 'नया पासवर्ड डालो';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get setNewPassword => 'नया पासवर्ड सेट करो';

  @override
  String get emailChanged => 'ईमेल बदल दी गई';

  @override
  String get emailChangeSuccess => 'ईमेल सफलतापूर्वक बदल गई!';

  @override
  String get failed => 'नाकाम';

  @override
  String get emailChangeFailed => 'ईमेल बदलने में नाकाम';

  @override
  String get oops => 'उफ़!';

  @override
  String get emailExists => 'ईमेल पहले से मौजूद है';

  @override
  String get changeEmail => 'ईमेल बदलो';

  @override
  String get enterValidEmail => 'कृपया एक मान्य ईमेल डालो';

  @override
  String get newEmail => 'नया ईमेल';

  @override
  String get currentPassword => 'मौजूदा पासवर्ड';

  @override
  String get emailChangeInfo =>
      'सुरक्षा के लिए, ईमेल बदलने के लिए मौजूदा पासवर्ड डालें। बदलने के बाद, नए ईमेल से लॉगिन करें।';

  @override
  String get oauthUsersMessage =>
      '(केवल Google या Github से लॉगिन करने वाले यूज़र्स के लिए)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'ईमेल बदलने के लिए, \"मौजूदा पासवर्ड\" फील्ड में नया पासवर्ड डालें। इसे याद रखें—आगे केवल Google/GitHub या नए पासवर्ड से लॉगिन होगा।';

  @override
  String get resonateTagline => 'बातों की एक अनंत दुनिया में कदम रखें';

  @override
  String get signInWithEmail => 'ईमेल से साइन इन करो';

  @override
  String get or => 'या';

  @override
  String get continueWith => 'इनमें से किसी एक से लॉगिन करें';

  @override
  String get continueWithGoogle => 'Google से लॉगिन करें';

  @override
  String get continueWithGitHub => 'GitHub से लॉगिन करें';

  @override
  String get resonateLogo => 'रेज़ोनेट लोगो';

  @override
  String get iAlreadyHaveAnAccount => 'मेरे पास पहले से एक अकाउंट है';

  @override
  String get createNewAccount => 'नया अकाउंट बनाओ';

  @override
  String get userProfile => 'यूज़र प्रोफ़ाइल';

  @override
  String get passwordIsStrong => 'पासवर्ड मजबूत है';

  @override
  String get admin => 'एडमिन';

  @override
  String get moderator => 'मॉडरेटर';

  @override
  String get speaker => 'स्पीकर';

  @override
  String get listener => 'लिस्नर';

  @override
  String get removeModerator => 'मॉडरेटर हटाओ';

  @override
  String get kickOut => 'किक आउट करो';

  @override
  String get addModerator => 'मॉडरेटर जोड़ो';

  @override
  String get addSpeaker => 'स्पीकर जोड़ो';

  @override
  String get makeListener => 'लिस्नर बनाओ';

  @override
  String get pairChat => 'पेयर चैट';

  @override
  String get chooseIdentity => 'पहचान चुनें';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get noConnection => 'कोई कनेक्शन नहीं';

  @override
  String get loadingDialog => 'लोड हो रहा है...';

  @override
  String get createAccount => 'अकाउंट बनाओ';

  @override
  String get enterValidEmailAddress => 'मान्य ईमेल पता डालो';

  @override
  String get email => 'ईमेल';

  @override
  String get passwordRequirements => 'पासवर्ड कम से कम 8 अक्षर का होना चाहिए';

  @override
  String get includeNumericDigit => 'कम से कम 1 संख्या शामिल करें';

  @override
  String get includeUppercase => 'कम से कम 1 कैपिटल लेटर शामिल करें';

  @override
  String get includeLowercase => 'कम से कम 1 लोअरकेस लेटर शामिल करें';

  @override
  String get includeSymbol => 'कम से कम 1 सिम्बल शामिल करें';

  @override
  String get signedUpSuccessfully => 'सफलतापूर्वक साइन अप हो गया!';

  @override
  String get newAccountCreated => 'आपका नया अकाउंट सफलतापूर्वक बन गया है';

  @override
  String get signUp => 'साइन अप';

  @override
  String get login => 'लॉगिन';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get accountSettings => 'अकाउंट सेटिंग्स';

  @override
  String get account => 'अकाउंट';

  @override
  String get appSettings => 'ऐप की सेटिंग्स';

  @override
  String get themes => 'थीम्स';

  @override
  String get about => 'रेज़ोनेट के बारे में';

  @override
  String get other => 'अन्य';

  @override
  String get contribute => 'योगदान करें';

  @override
  String get appPreferences => 'ऐप प्राथमिकताएं';

  @override
  String get transcriptionModel => 'ट्रांसक्रिप्शन मॉडल';

  @override
  String get transcriptionModelDescription =>
      'वॉयस ट्रांसक्रिप्शन के लिए AI मॉडल चुनें। बड़े मॉडल अधिक सटीक हैं लेकिन धीमे हैं और अधिक स्टोरेज की आवश्यकता होती है।';

  @override
  String get whisperModelTiny => 'टाइनी';

  @override
  String get whisperModelTinyDescription => 'सबसे तेज़, कम सटीक (~39 MB)';

  @override
  String get whisperModelBase => 'बेस';

  @override
  String get whisperModelBaseDescription => 'संतुलित गति और सटीकता (~74 MB)';

  @override
  String get whisperModelSmall => 'स्मॉल';

  @override
  String get whisperModelSmallDescription => 'अच्छी सटीकता, धीमा (~244 MB)';

  @override
  String get whisperModelMedium => 'मीडियम';

  @override
  String get whisperModelMediumDescription => 'उच्च सटीकता, धीमा (~769 MB)';

  @override
  String get whisperModelLargeV1 => 'लार्ज V1';

  @override
  String get whisperModelLargeV1Description =>
      'सबसे अधिक सटीक, सबसे धीमा (~1.55 GB)';

  @override
  String get whisperModelLargeV2 => 'लार्ज V2';

  @override
  String get whisperModelLargeV2Description =>
      'उच्च सटीकता के साथ बेहतर बड़ा मॉडल (~1.55 GB)';

  @override
  String get modelDownloadInfo =>
      'मॉडल पहली बार उपयोग करने पर डाउनलोड हो जाते हैं। हम बेस, स्मॉल या मीडियम का उपयोग करने की सिफारिश करते हैं। बड़े मॉडल के लिए बहुत उच्च अंत उपकरणों की आवश्यकता होती है।';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get participants => 'पार्टिसिपेंट्स';

  @override
  String get delete => 'डिलीट';

  @override
  String get leave => 'छोड़ो';

  @override
  String get leaveButton => 'छोड़ो';

  @override
  String get findingRandomPartner => 'आपके लिए एक रैंडम पार्टनर ढूंढ रहे हैं';

  @override
  String get quickFact => 'त्वरित तथ्य';

  @override
  String get cancel => 'कैंसल';

  @override
  String get hide => 'छुपाएं';

  @override
  String get removeRoom => 'रूम छुपाएं';

  @override
  String get removeRoomFromList => 'सूची से छुपाएं';

  @override
  String get removeRoomConfirmation =>
      'क्या आप वाकई इस आने वाले रूम को अपनी सूची से छुपाना चाहते हैं?';

  @override
  String get completeYourProfile => 'अपनी प्रोफ़ाइल पूरी करो';

  @override
  String get uploadProfilePicture => 'प्रोफ़ाइल पिक्चर अपलोड करो';

  @override
  String get enterValidName => 'मान्य नाम डालो';

  @override
  String get name => 'नाम';

  @override
  String get username => 'यूज़रनेम';

  @override
  String get enterValidDOB => 'सही तारीख़ डालो';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get next => 'आगे';

  @override
  String get noStoriesExist => 'कोई कहानी अभी मौजूद नहीं है';

  @override
  String get enterVerificationCode => 'अपना\nवेरिफिकेशन कोड दर्ज करें';

  @override
  String get verificationCodeSent => 'हमने 6-अंकों का कोड भेजा है\n';

  @override
  String get verificationComplete => 'वेरिफिकेशन पूरा हो गया';

  @override
  String get verificationCompleteMessage =>
      'बधाई हो! आपका ईमेल वेरिफाई हो गया है';

  @override
  String get verificationFailed => 'वेरिफिकेशन फेल हो गया';

  @override
  String get otpMismatch => 'OTP मेल नहीं खा रहा, कृपया फिर से प्रयास करें';

  @override
  String get otpResent => 'OTP दोबारा भेजा गया';

  @override
  String get requestNewCode => 'नया कोड माँगें';

  @override
  String get requestNewCodeIn => 'नया कोड माँगने के लिए प्रतीक्षा करें';

  @override
  String get clickPictureCamera => 'कैमरा से फोटो लें';

  @override
  String get pickImageGallery => 'गैलरी से इमेज चुनें';

  @override
  String get deleteMyAccount => 'मेरा अकाउंट डिलीट करें';

  @override
  String get createNewRoom => 'नया रूम बनाएं';

  @override
  String get pleaseEnterScheduledDateTime =>
      'कृपया निर्धारित तारीख और समय डालें';

  @override
  String get scheduleDateTimeLabel => 'शेड्यूल तारीख व समय';

  @override
  String get enterTags => 'टैग डालें';

  @override
  String get joinCommunity => 'कम्युनिटी से जुड़ें';

  @override
  String get followUsOnX => 'X पर हमें फॉलो करें';

  @override
  String get joinDiscordServer => 'Discord सर्वर से जुड़ें';

  @override
  String get noLyrics => 'कोई लिरिक्स उपलब्ध नहीं';

  @override
  String noStoriesInCategory(String categoryName) {
    return '$categoryName श्रेणी में कोई कहानी नहीं है';
  }

  @override
  String get newChapters => 'नए चैप्टर्स जोड़ें';

  @override
  String get helpToGrow => 'साथ मिलकर बढ़ाएं';

  @override
  String get share => 'शेयर करें';

  @override
  String get rate => 'रेटिंग दें';

  @override
  String get aboutResonate => 'रेज़ोनेट के बारे में';

  @override
  String get description => 'विवरण';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get classic => 'क्लासिक';

  @override
  String get time => 'टाइम';

  @override
  String get vintage => 'विंटेज';

  @override
  String get amber => 'अंबर';

  @override
  String get forest => 'फॉरेस्ट';

  @override
  String get cream => 'क्रीम';

  @override
  String get none => 'कोई नहीं';

  @override
  String checkOutGitHub(String url) {
    return 'हमारा GitHub रेपो देखें: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'AOSSIE लोगो';

  @override
  String get errorLoadPackageInfo => 'पैकेज जानकारी लोड नहीं हो सकी';

  @override
  String get searchFailed => 'रूम खोजने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध है';

  @override
  String get newVersionAvailable => 'एक नया वर्शन उपलब्ध है!';

  @override
  String get upToDate => 'आपका ऐप लेटेस्ट है';

  @override
  String get latestVersion =>
      'आप रेज़ोनेट का लेटेस्ट वर्शन इस्तेमाल कर रहे हैं';

  @override
  String get profileCreatedSuccessfully => 'प्रोफ़ाइल सफलतापूर्वक बनाई गई';

  @override
  String get invalidScheduledDateTime => 'अमान्य तारीख और समय';

  @override
  String get scheduledDateTimePast =>
      'शेड्यूल तारीख व समय पहले का नहीं हो सकता';

  @override
  String get joinRoom => 'रूम में शामिल हों';

  @override
  String get unknownUser => 'अज्ञात यूज़र';

  @override
  String get canceled => 'रद्द किया गया';

  @override
  String get english => 'en';

  @override
  String get emailVerificationRequired => 'ईमेल वेरिफिकेशन ज़रूरी है';

  @override
  String get verify => 'वेरिफ़ाई करें';

  @override
  String get audioRoom => 'ऑडियो रूम';

  @override
  String toRoomAction(String action) {
    return 'रूम को $action करने के लिए';
  }

  @override
  String get mailSentMessage => 'मेल भेज दी गई है';

  @override
  String get disconnected => 'कनेक्शन टूट गया';

  @override
  String get micOn => 'माइक';

  @override
  String get speakerOn => 'स्पीकर';

  @override
  String get endChat => 'चैट समाप्त करें';

  @override
  String get monthJan => 'जनवरी';

  @override
  String get monthFeb => 'फरवरी';

  @override
  String get monthMar => 'मार्च';

  @override
  String get monthApr => 'अप्रैल';

  @override
  String get monthMay => 'मई';

  @override
  String get monthJun => 'जून';

  @override
  String get monthJul => 'जुलाई';

  @override
  String get monthAug => 'अगस्त';

  @override
  String get monthSep => 'सितंबर';

  @override
  String get monthOct => 'अक्टूबर';

  @override
  String get monthNov => 'नवंबर';

  @override
  String get monthDec => 'दिसंबर';

  @override
  String get register => 'रजिस्टर करें';

  @override
  String get newToResonate => 'रेज़ोनेट पर नए हैं? ';

  @override
  String get alreadyHaveAccount => 'पहले से अकाउंट है? ';

  @override
  String get checking => 'जाँच हो रही है...';

  @override
  String get forgotPasswordMessage =>
      'पासवर्ड रीसेट करने के लिए अपना रजिस्टर्ड ईमेल दर्ज करें।';

  @override
  String get usernameUnavailable => 'यूज़रनेम उपलब्ध नहीं है!';

  @override
  String get usernameInvalidOrTaken =>
      'यह यूज़रनेम अमान्य है या पहले से लिया जा चुका है।';

  @override
  String get otpResentMessage => 'कृपया अपनी ईमेल जांचें, नया OTP भेजा गया है।';

  @override
  String get connectionError =>
      'कनेक्शन में समस्या है। कृपया इंटरनेट चेक करें और दोबारा प्रयास करें।';

  @override
  String get seconds => 'सेकंड';

  @override
  String get unsavedChangesWarning =>
      'यदि आप बिना सेव किए आगे बढ़ते हैं, तो आपके सभी बदलाव खो जाएंगे।';

  @override
  String get deleteAccountPermanent =>
      'यह प्रक्रिया आपके अकाउंट को हमेशा के लिए डिलीट कर देगी। आपका यूज़रनेम, ईमेल और सारा डेटा हटा दिया जाएगा। यह वापस नहीं लिया जा सकता।';

  @override
  String get giveGreatName => 'एक अच्छा नाम सोचें...';

  @override
  String get joinCommunityDescription =>
      'कम्युनिटी से जुड़कर आप सवाल पूछ सकते हैं, नए फीचर्स का सुझाव दे सकते हैं, और अपने अनुभव साझा कर सकते हैं।';

  @override
  String get resonateDescription =>
      'रेज़ोनेट एक सोशल मीडिया प्लेटफॉर्म है जहाँ हर आवाज़ की कद्र की जाती है। अपने विचार, कहानियाँ और अनुभव साझा करें। ऑडियो जर्नी अभी शुरू करें और उन टॉपिक्स में हिस्सा लें जो आपसे जुड़ते हैं।';

  @override
  String get resonateFullDescription =>
      'रेज़ोनेट एक क्रांतिकारी वॉयस-बेस्ड सोशल मीडिया प्लेटफॉर्म है जहाँ हर आवाज़ मायने रखती है।\nरियल-टाइम ऑडियो बातचीत में भाग लें, और अपने जैसे विचारों वाले लोगों से जुड़ें। हमारा प्लेटफॉर्म आपको देता है:\n- लाइव ऑडियो रूम्स\n- वॉयस के ज़रिए सोशल नेटवर्किंग\n- कम्युनिटी-ड्रिवन कंटेंट मॉडरेशन\n- क्रॉस-प्लेटफॉर्म सपोर्ट\n- एन्ड-टू-एन्ड एन्क्रिप्टेड प्राइवेट चैट्स\n\nयह ऐप AOSSIE ओपन-सोर्स कम्युनिटी द्वारा बनाया गया है, जो आपकी प्राइवेसी और पारदर्शी विकास को प्राथमिकता देती है।';

  @override
  String get stable => 'स्थिर';

  @override
  String get usernameCharacterLimit =>
      'यूज़रनेम में कम से कम 6 अक्षर होने चाहिए।';

  @override
  String get submit => 'सबमिट करें';

  @override
  String get anonymous => 'गुमनाम';

  @override
  String get noSearchResults => 'कोई रिज़ल्ट नहीं मिला';

  @override
  String get searchRooms => 'रूम खोजें...';

  @override
  String get searchingRooms => 'रूम खोजे जा रहे हैं...';

  @override
  String get clearSearch => 'खोज साफ़ करें';

  @override
  String get searchError => 'खोज त्रुटि';

  @override
  String get searchRoomsError =>
      'कमरों की खोज असफल हुई। कृपया दोबारा कोशिश करें।';

  @override
  String get searchUpcomingRoomsError =>
      'आगामी कमरों की खोज असफल हुई। कृपया दोबारा कोशिश करें।';

  @override
  String get search => 'खोजें';

  @override
  String get clear => 'साफ़ करें';

  @override
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  ) {
    return '🚀 इस शानदार रूम को देखें: $roomName!\n\n📖 विवरण: $description\n👥 अभी $participants लोग जुड़ चुके हैं!';
  }

  @override
  String participantsCount(int count) {
    return '$count प्रतिभागी';
  }

  @override
  String get join => 'शामिल हों';

  @override
  String get invalidTags => 'अमान्य टैग:';

  @override
  String get cropImage => 'इमेज क्रॉप करें';

  @override
  String get profileSavedSuccessfully => 'प्रोफ़ाइल सेव हो गई';

  @override
  String get profileUpdatedSuccessfully =>
      'आपके सभी बदलाव सफलतापूर्वक सेव हो गए हैं।';

  @override
  String get profileUpToDate => 'आपकी प्रोफ़ाइल पूरी तरह अपडेट है';

  @override
  String get noChangesToSave =>
      'कोई नया बदलाव नहीं है, सेव करने की ज़रूरत नहीं।';

  @override
  String get connectionFailed => 'कनेक्शन फेल हो गया';

  @override
  String get unableToJoinRoom =>
      'रूम से कनेक्ट नहीं हो सका। कृपया नेटवर्क चेक करें और फिर से कोशिश करें।';

  @override
  String get connectionLost => 'कनेक्शन टूट गया';

  @override
  String get unableToReconnect =>
      'रूम से दोबारा कनेक्ट नहीं हो सका। कृपया फिर से जुड़ने का प्रयास करें।';

  @override
  String get invalidFormat => 'अमान्य फ़ॉर्मेट!';

  @override
  String get usernameAlphanumeric =>
      'यूज़रनेम केवल अक्षर और अंक होने चाहिए, कोई स्पेशल कैरेक्टर नहीं।';

  @override
  String get userProfileCreatedSuccessfully =>
      'आपकी यूज़र प्रोफ़ाइल सफलतापूर्वक बनाई गई है।';

  @override
  String get emailVerificationMessage =>
      'आगे बढ़ने के लिए कृपया अपना ईमेल वेरिफाई करें।';

  @override
  String addNewChaptersToStory(String storyName) {
    return '$storyName में नए चैप्टर्स जोड़ें';
  }

  @override
  String get currentChapters => 'मौजूदा चैप्टर्स';

  @override
  String get sourceCodeOnGitHub => 'GitHub पर सोर्स कोड';

  @override
  String get createAChapter => 'नया चैप्टर बनाएं';

  @override
  String get chapterTitle => 'चैप्टर का टाइटल *';

  @override
  String get aboutRequired => 'कहानी का परिचय *';

  @override
  String get changeCoverImage => 'कवर इमेज बदलें';

  @override
  String get uploadAudioFile => 'ऑडियो फाइल अपलोड करें';

  @override
  String get uploadLyricsFile => 'लिरिक्स फाइल अपलोड करें';

  @override
  String get createChapter => 'चैप्टर बनाएं';

  @override
  String audioFileSelected(String fileName) {
    return 'ऑडियो फाइल चुनी गई: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'लिरिक्स फाइल चुनी गई: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'कृपया सभी जरूरी फ़ील्ड भरें और अपनी ऑडियो व लिरिक्स फाइल अपलोड करें';

  @override
  String get scheduled => 'शेड्यूल्ड';

  @override
  String get ok => 'ठीक है';

  @override
  String get roomDescriptionOptional => 'रूम का विवरण (वैकल्पिक)';

  @override
  String get deleteAccount => 'अकाउंट हटाएं';

  @override
  String get createYourStory => 'अपनी कहानी बनाएं';

  @override
  String get titleRequired => 'टाइटल *';

  @override
  String get category => 'कैटेगरी *';

  @override
  String get addChapter => 'चैप्टर जोड़ें';

  @override
  String get createStory => 'कहानी बनाएं';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'कृपया सभी ज़रूरी फ़ील्ड भरें, कम से कम एक चैप्टर जोड़ें और कवर इमेज चुनें।';

  @override
  String get toConfirmType => 'पुष्टि करने के लिए टाइप करें';

  @override
  String get inTheBoxBelow => 'नीचे दिए गए बॉक्स में';

  @override
  String get iUnderstandDeleteMyAccount =>
      'मैं समझता/समझती हूँ, मेरा अकाउंट डिलीट करें';

  @override
  String get whatDoYouWantToListenTo => 'आप क्या सुनना चाहते हैं?';

  @override
  String get categories => 'श्रेणियाँ';

  @override
  String get stories => 'कहानियाँ';

  @override
  String get someSuggestions => 'कुछ सुझाव';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get skip => 'स्किप करें';

  @override
  String get welcomeToResonate => 'रेज़ोनेट में आपका स्वागत है';

  @override
  String get exploreDiverseConversations => 'विविध बातचीत का अनुभव लें';

  @override
  String get yourVoiceMatters => 'आपकी आवाज़ मायने रखती है';

  @override
  String get joinConversationExploreRooms =>
      'बातचीत में शामिल हों! रूम्स एक्सप्लोर करें, दोस्तों से जुड़ें और अपनी आवाज़ दुनिया तक पहुँचाएं।';

  @override
  String get diveIntoDiverseDiscussions =>
      'विभिन्न चर्चाओं में शामिल हों।\nऐसे रूम्स खोजें जो आपसे जुड़ते हों और कम्युनिटी का हिस्सा बनें।';

  @override
  String get atResonateEveryVoiceValued =>
      'रेज़ोनेट में हर आवाज़ की अहमियत है। अपने विचार, कहानियाँ और अनुभव साझा करें। अपनी ऑडियो जर्नी अभी शुरू करें।';

  @override
  String get notifications => 'नोटिफिकेशन';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username ने आपको एक अपकमिंग रूम में टैग किया: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username ने आपको एक रूम में टैग किया: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username ने आपकी कहानी को पसंद किया: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username ने आपके रूम को सब्सक्राइब किया: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username ने आपको फॉलो करना शुरू किया';
  }

  @override
  String get youHaveNewNotification => 'आपके लिए एक नया नोटिफिकेशन है';

  @override
  String get hangOnGoodThingsTakeTime =>
      'रुकिए — अच्छी चीज़ों में समय लगता है 🔍';

  @override
  String get resonateOpenSourceProject =>
      'रेज़ोनेट एक ओपन-सोर्स प्रोजेक्ट है जिसे AOSSIE बनाए रखता है। योगदान देने के लिए हमारा GitHub देखें।';

  @override
  String get mute => 'म्यूट करें';

  @override
  String get speakerLabel => 'स्पीकर';

  @override
  String get end => 'समाप्त करें';

  @override
  String get saveChanges => 'बदलाव सेव करें';

  @override
  String get discard => 'रद्द करें';

  @override
  String get save => 'सेव करें';

  @override
  String get changeProfilePicture => 'प्रोफ़ाइल पिक्चर बदलें';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get remove => 'हटाएं';

  @override
  String created(String date) {
    return 'बनाई गई: $date';
  }

  @override
  String get chapters => 'चैप्टर';

  @override
  String get deleteStory => 'कहानी हटाएं';

  @override
  String createdBy(String creatorName) {
    return '$creatorName द्वारा बनाई गई';
  }

  @override
  String get start => 'शुरू करें';

  @override
  String get unsubscribe => 'सब्सक्रिप्शन हटाएं';

  @override
  String get subscribe => 'सब्सक्राइब करें';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'नाटक',
      'comedy': 'हास्य',
      'horror': 'डरावनी',
      'romance': 'प्रेम कथा',
      'thriller': 'रोमांच',
      'spiritual': 'आध्यात्मिक',
      'other': 'अन्य',
    });
    return '$_temp0';
  }

  @override
  String chooseTheme(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'classicTheme': 'क्लासिक',
      'timeTheme': 'टाइम',
      'vintageTheme': 'विंटेज',
      'amberTheme': 'अंबर',
      'forestTheme': 'फॉरेस्ट',
      'creamTheme': 'क्रीम',
      'other': 'अन्य',
    });
    return '$_temp0';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिनट पहले',
      one: '1 मिनट पहले',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटे पहले',
      one: '1 घंटा पहले',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन पहले',
      one: '1 दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String get by => 'प्रस्तुतकर्ता:';

  @override
  String get likes => 'लाइक्स';

  @override
  String get lengthMinutes => 'मिनट';

  @override
  String get requiredField => 'आवश्यक फील्ड';

  @override
  String get onlineUsers => 'ऑनलाइन यूज़र्स';

  @override
  String get noOnlineUsers => 'कोई यूज़र अभी ऑनलाइन नहीं है';

  @override
  String get chooseUser => 'चैट करने के लिए यूज़र चुनें';

  @override
  String get quickMatch => 'झटपट मैच';

  @override
  String get story => 'कहानी';

  @override
  String get user => 'यूज़र';

  @override
  String get following => 'फॉलो कर रहे हैं';

  @override
  String get followers => 'फॉलोअर्स';

  @override
  String get friendRequests => 'फ्रेंड रिक्वेस्ट';

  @override
  String get friendRequestSent => 'मित्रता अनुरोध भेजा गया';

  @override
  String friendRequestSentTo(String username) {
    return 'आपका मित्रता अनुरोध $username को भेजा गया है।';
  }

  @override
  String get friendRequestCancelled => 'मित्रता अनुरोध रद्द कर दिया गया';

  @override
  String friendRequestCancelledTo(String username) {
    return '$username को आपका मित्रता अनुरोध रद्द कर दिया गया है।';
  }

  @override
  String get requested => 'अनुरोध किया है';

  @override
  String get friends => 'मित्र';

  @override
  String get addFriend => 'मित्र जोड़ें';

  @override
  String get friendRequestAccepted => 'मित्रता अनुरोध स्वीकार कर लिया गया';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'आपने $username के मित्रता अनुरोध को स्वीकार कर लिया है।';
  }

  @override
  String get friendRequestDeclined => 'मित्रता अनुरोध अस्वीकार कर दिया गया';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'आपने $username के मित्रता अनुरोध को अस्वीकार कर दिया है।';
  }

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get callDeclined => 'कॉल अस्वीकार कर दिया गया';

  @override
  String callDeclinedTo(String username) {
    return '$username ने आपकी कॉल को अस्वीकार कर दिया है।';
  }

  @override
  String get checkForUpdates => 'अपडेट चेक करें';

  @override
  String get updateNow => 'अभी अपडेट करें';

  @override
  String get updateLater => 'बाद में';

  @override
  String get updateSuccessful => 'अपडेट सफल';

  @override
  String get updateSuccessfulMessage => 'रेज़ोनेट सफलतापूर्वक अपडेट हो गया है!';

  @override
  String get updateCancelled => 'अपडेट रद्द किया गया';

  @override
  String get updateCancelledMessage => 'अपडेट यूज़र द्वारा रद्द किया गया';

  @override
  String get updateFailed => 'अपडेट फेल';

  @override
  String get updateFailedMessage =>
      'अपडेट फेल हो गया। कृपया Play Store से मैन्युअली अपडेट करने का प्रयास करें।';

  @override
  String get updateError => 'अपडेट एरर';

  @override
  String get updateErrorMessage =>
      'अपडेट करने में कोई समस्या आई। कृपया फिर से प्रयास करें।';

  @override
  String get platformNotSupported => 'प्लेटफॉर्म सपोर्टेड नहीं';

  @override
  String get platformNotSupportedMessage =>
      'अपडेट चेक करना केवल Android डिवाइस पर उपलब्ध है';

  @override
  String get updateCheckFailed => 'अपडेट चेक फेल';

  @override
  String get updateCheckFailedMessage =>
      'अपडेट चेक नहीं हो सका। कृपया बाद में प्रयास करें।';

  @override
  String get upToDateTitle => 'आप अप टू डेट हैं!';

  @override
  String get upToDateMessage =>
      'आप रेज़ोनेट का लेटेस्ट वर्शन इस्तेमाल कर रहे हैं';

  @override
  String get updateAvailableTitle => 'अपडेट उपलब्ध है!';

  @override
  String get updateAvailableMessage =>
      'रेज़ोनेट का नया वर्शन Play Store पर उपलब्ध है';

  @override
  String get updateFeaturesImprovement =>
      'नवीनतम सुविधाएं और सुधार प्राप्त करें!';

  @override
  String get failedToRemoveRoom => 'रूम हटाने में विफल';

  @override
  String get roomRemovedSuccessfully =>
      'रूम आपकी सूची से सफलतापूर्वक हटा दिया गया';

  @override
  String get alert => 'अलर्ट';

  @override
  String get removedFromRoom =>
      'आपको कमरे से रिपोर्ट किया गया है या हटा दिया गया है';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'हिंसा / नफरत भरा भाषण',
      'abuse': 'दुरुपयोग सामग्री / हिंसा',
      'spam': 'स्पैम / धोखाधड़ी',
      'impersonation': 'नकली खाते',
      'illegal': 'गैरकानूनी गतिविधियाँ',
      'selfharm': 'आत्म-हानि / आत्महत्या / मानसिक स्वास्थ्य',
      'misuse': 'प्लेटफ़ॉर्म का दुरुपयोग',
      'other': 'अन्य',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate =>
      'आपको कई उपयोगकर्ताओं द्वारा रिपोर्ट किया गया है और आपको रेज़ोनेट का उपयोग करने से ब्लॉक कर दिया गया है। यदि आपको लगता है कि यह गलती है, तो कृपया AOSSIE से संपर्क करें।';

  @override
  String get reportParticipant => 'प्रतिभागी की रिपोर्ट करें';

  @override
  String get selectReportType => 'रिपोर्ट का प्रकार चुनें';

  @override
  String get reportSubmitted => 'रिपोर्ट सफलतापूर्वक सबमिट की गई';

  @override
  String get reportFailed => 'रिपोर्ट सबमिशन फेल';

  @override
  String get additionalDetailsOptional => 'अतिरिक्त विवरण (वैकल्पिक)';

  @override
  String get submitReport => 'रिपोर्ट सबमिट करें';

  @override
  String get actionBlocked => 'कार्रवाई अवरुद्ध';

  @override
  String get cannotStopRecording =>
      'आप रिकॉर्डिंग को मैन्युअल रूप से रोक नहीं सकते, रिकॉर्डिंग तब रोकी जाएगी जब कमरा बंद होगा।';

  @override
  String get liveChapter => 'लाइव चैप्टर';

  @override
  String get viewOrEditLyrics => 'गीत देखें या संपादित करें';

  @override
  String get close => 'बंद करें';

  @override
  String get verifyChapterDetails => 'चैप्टर विवरण सत्यापित करें';

  @override
  String get author => 'लेखक';

  @override
  String get startLiveChapter => 'लाइव चैप्टर शुरू करें';

  @override
  String get fillAllFields => 'कृपया सभी आवश्यक फ़ील्ड भरें';

  @override
  String get noRecordingError =>
      'आपके पास कोई रिकॉर्डिंग नहीं है। लाइव चैप्टर रूम से बाहर निकलने के लिए, कृपया पहले रिकॉर्डिंग शुरू करें।';
}
