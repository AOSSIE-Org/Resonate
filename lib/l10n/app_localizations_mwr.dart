// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marwari (`mwr`).
class AppLocalizationsMwr extends AppLocalizations {
  AppLocalizationsMwr([String locale = 'mwr']) : super(locale);

  @override
  String get title => 'रेज़ोनेट';

  @override
  String get roomDescription =>
      'सभ्य रहो अर बीजां आदमी री सोच रो मान राखो। बदतमीजी वाली बातां सूं बचो।';

  @override
  String get hidePassword => 'पासवर्ड छुपाओ';

  @override
  String get showPassword => 'पासवर्ड दिखाओ';

  @override
  String get passwordEmpty => 'पासवर्ड खाली ना हो सके';

  @override
  String get password => 'पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड पक्का करो';

  @override
  String get passwordsNotMatch => 'पासवर्ड मेल ना खावै';

  @override
  String get userCreatedStories => 'यूज़र री बनायी कहानी';

  @override
  String get yourStories => 'थारी कहानी';

  @override
  String get userNoStories => 'ई यूज़रां कोई कहानी ना बनायी';

  @override
  String get youNoStories => 'थां कोई कहानी ना बनायी';

  @override
  String get follow => 'फॉलो करो';

  @override
  String get editProfile => 'प्रोफाइल बदलो';

  @override
  String get verifyEmail => 'ईमेल जांचो';

  @override
  String get verified => 'जांच हो गई';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get userLikedStories => 'यूज़र री पसंदीदा कहानी';

  @override
  String get yourLikedStories => 'थारी पसंदीदा कहानी';

  @override
  String get userNoLikedStories => 'ई यूज़रां कोई कहानी पसंद ना करी';

  @override
  String get youNoLikedStories => 'थां कोई कहानी पसंद ना करी';

  @override
  String get live => 'सीधा';

  @override
  String get upcoming => 'आवण वाली';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'कोई रूम उपलब्ध कोनी',
      'false': 'कोई आवण वाली रूम उपलब्ध कोनी',
      'other': 'कोई जानकारी उपलब्ध कोनी',
    });
    return '$_temp0\nनीचे जोड़ के शुरू करो!';
  }

  @override
  String get user1 => 'यूज़र १';

  @override
  String get user2 => 'यूज़र २';

  @override
  String get you => 'थां';

  @override
  String get areYouSure => 'थां पक्को हो?';

  @override
  String get loggingOut => 'थां रेज़ोनेट सूं लॉगआउट कर रहा हो.';

  @override
  String get yes => 'हां';

  @override
  String get no => 'ना';

  @override
  String get incorrectEmailOrPassword => 'गलत ईमेल या पासवर्ड';

  @override
  String get passwordShort => 'पासवर्ड ८ अक्षरां सूं छोटो है';

  @override
  String get tryAgain => 'फेर सूं कोशिश करो!';

  @override
  String get success => 'सफल';

  @override
  String get passwordResetSent => 'पासवर्ड रीसेट ईमेल भेज दी गई!';

  @override
  String get error => 'गलती';

  @override
  String get resetPassword => 'पासवर्ड फेर सूं सेट करो';

  @override
  String get enterNewPassword => 'थारो नयो पासवर्ड भरो';

  @override
  String get newPassword => 'नयो पासवर्ड';

  @override
  String get setNewPassword => 'नयो पासवर्ड सेट करो';

  @override
  String get emailChanged => 'ईमेल बदल गयो';

  @override
  String get emailChangeSuccess => 'ईमेल सफलतापूर्वक बदल गयो!';

  @override
  String get failed => 'असफल';

  @override
  String get emailChangeFailed => 'ईमेल बदलणो असफल रहयो';

  @override
  String get oops => 'अरे रे!';

  @override
  String get emailExists => 'ईमेल पहिले सूं मौजूद है';

  @override
  String get changeEmail => 'ईमेल बदलो';

  @override
  String get enterValidEmail => 'कृपया सही ईमेल पता भरो';

  @override
  String get newEmail => 'नयो ईमेल';

  @override
  String get currentPassword => 'हालो पासवर्ड';

  @override
  String get emailChangeInfo =>
      'ज्यादा सुरक्षा खातर, थारो ईमेल बदलता वखत थां ने खातां रो हालो पासवर्ड देवो जरूरी है। ईमेल बदल्या पछां, आगे लॉगिन खातर अपडेट ईमेल वापरो.';

  @override
  String get oauthUsersMessage =>
      '(सिर्फ Google या GitHub सूं लॉगिन करनाऱ्या यूज़रां खातर)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'ईमेल बदलां खातर, कृपया \"हालो पासवर्ड\" फील्ड में नयो पासवर्ड भरो। ई पासवर्ड याद राखजो, कारण आगे ईमेल बदलां में काम आवै। फेर थां Google/GitHub या नवा ईमेल अर पासवर्ड सूं लॉगिन कर सको.';

  @override
  String get resonateTagline => 'असीम बातचीतां री दुनिया में प्रवेश करो।';

  @override
  String get signInWithEmail => 'ईमेल सूं साइन इन करो';

  @override
  String get or => 'या';

  @override
  String get continueWith => 'एंठां सूं चालू राखो';

  @override
  String get continueWithGoogle => 'Google सूं चालू राखो';

  @override
  String get continueWithGitHub => 'GitHub सूं चालू राखो';

  @override
  String get resonateLogo => 'रेज़ोनेट लोगो';

  @override
  String get iAlreadyHaveAnAccount => 'म्हां पासे पहले सूं खातो है';

  @override
  String get createNewAccount => 'नयो खातो बनाओ';

  @override
  String get userProfile => 'यूज़र प्रोफाइल';

  @override
  String get passwordIsStrong => 'पासवर्ड मजबूत है';

  @override
  String get admin => 'प्रशासक';

  @override
  String get moderator => 'मॉडरेटर';

  @override
  String get speaker => 'स्पीकर';

  @override
  String get listener => 'सुणनारो';

  @override
  String get removeModerator => 'मॉडरेटर हटाओ';

  @override
  String get kickOut => 'बाहेर काढो';

  @override
  String get addModerator => 'मॉडरेटर जोड़ो';

  @override
  String get addSpeaker => 'स्पीकर जोड़ो';

  @override
  String get makeListener => 'सुणनारो बनाओ';

  @override
  String get pairChat => 'जोड़ो चॅट';

  @override
  String get chooseIdentity => 'ओळख चुनो';

  @override
  String get selectLanguage => 'भाषा चुनो';

  @override
  String get noConnection => 'कोई कनेक्शन कोनी';

  @override
  String get loadingDialog => 'लोड हो रहयो है';

  @override
  String get createAccount => 'खातो बनाओ';

  @override
  String get enterValidEmailAddress => 'सही ईमेल पतो भरो';

  @override
  String get email => 'ईमेल';

  @override
  String get passwordRequirements =>
      'पासवर्ड कम से कम ८ अक्षरां रो होणो जरूरी है';

  @override
  String get includeNumericDigit => 'कम से कम १ अंक शामिल करो';

  @override
  String get includeUppercase => 'कम से कम १ मोठो अक्षर शामिल करो';

  @override
  String get includeLowercase => 'कम से कम १ नानो अक्षर शामिल करो';

  @override
  String get includeSymbol => 'कम से कम १ चिन्ह शामिल करो';

  @override
  String get signedUpSuccessfully => 'सफलतापूर्वक साइन अप हो गयो';

  @override
  String get newAccountCreated => 'थां सफलतापूर्वक नयो खातो बनायो है';

  @override
  String get signUp => 'साइन अप करो';

  @override
  String get login => 'लॉगिन';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get accountSettings => 'खाता सेटिंग्स';

  @override
  String get account => 'खातो';

  @override
  String get appSettings => 'ऐप सेटिंग्स';

  @override
  String get themes => 'थीमां';

  @override
  String get about => 'बारे में';

  @override
  String get other => 'बीजा';

  @override
  String get contribute => 'योगदान दो';

  @override
  String get appPreferences => 'ऐप पसंद';

  @override
  String get transcriptionModel => 'प्रतिलेखन मॉडल';

  @override
  String get transcriptionModelDescription =>
      'आवाज़ प्रतिलेखन खातर एआई मॉडल चुनो। मोटा मॉडल ज्यादा सही होवै, पण धीमा होवै अर ज्यादा स्टोरेज लेवै।';

  @override
  String get whisperModelTiny => 'सूक्ष्म';

  @override
  String get whisperModelTinyDescription => 'सब सूं तेज, कम सही (~३९ एमबी)';

  @override
  String get whisperModelBase => 'बेस';

  @override
  String get whisperModelBaseDescription => 'संतुलित गति अर सहीपन (~७४ एमबी)';

  @override
  String get whisperModelSmall => 'नानो';

  @override
  String get whisperModelSmallDescription => 'ठीक-ठाक सहीपन, धीमो (~२४४ एमबी)';

  @override
  String get whisperModelMedium => 'मध्यम';

  @override
  String get whisperModelMediumDescription => 'ज्यादा सहीपन, धीमो (~७६९ एमबी)';

  @override
  String get whisperModelLargeV1 => 'मोटो वी१';

  @override
  String get whisperModelLargeV1Description =>
      'सब सूं ज्यादा सही, सब सूं धीमो (~१.५५ जीबी)';

  @override
  String get whisperModelLargeV2 => 'मोटो वी२';

  @override
  String get whisperModelLargeV2Description =>
      'उन्नत मोटो मॉडल ज्यादा सहीपन साथ (~१.५५ जीबी)';

  @override
  String get modelDownloadInfo =>
      'मॉडल पहली बार वापर करता वखत डाउनलोड होवै। म्हां बेस, नानो या मध्यम वापरां री सिफारिश करां। मोटा मॉडल खातर बहुत हाई-एंड डिवाइस जरूरी है।';

  @override
  String get logOut => 'लॉगआउट करो';

  @override
  String get participants => 'भाग लेनारा';

  @override
  String get delete => 'मिटाओ';

  @override
  String get leave => 'छोड़ो';

  @override
  String get leaveButton => 'छोड़ो';

  @override
  String get findingRandomPartner => 'थां खातर यादृच्छिक साथी खोजा जा रहयो है';

  @override
  String get quickFact => 'फटाफट जानकारी';

  @override
  String get cancel => 'रद्द करो';

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
  String get completeYourProfile => 'थारो प्रोफाइल पूरो करो';

  @override
  String get uploadProfilePicture => 'प्रोफाइल फोटो अपलोड करो';

  @override
  String get enterValidName => 'सही नाम भरो';

  @override
  String get name => 'नाम';

  @override
  String get username => 'यूज़रनेम';

  @override
  String get enterValidDOB => 'सही जन्म तारीख भरो';

  @override
  String get dateOfBirth => 'जन्म तारीख';

  @override
  String get forgotPassword => 'पासवर्ड भूल गया?';

  @override
  String get next => 'आगां';

  @override
  String get noStoriesExist => 'पेश करां खातर कोई कहानी कोनी';

  @override
  String get enterVerificationCode => 'थारो\nसत्यापन कोड भरो';

  @override
  String get verificationCodeSent => 'म्हां ६-अंकी सत्यापन कोड भेज्यो है\n';

  @override
  String get verificationComplete => 'सत्यापन पूरो';

  @override
  String get verificationCompleteMessage =>
      'बधाई हो, थां थारो ईमेल सत्यापित कर लियो है';

  @override
  String get verificationFailed => 'सत्यापन असफल';

  @override
  String get otpMismatch => 'ओटीपी मेल ना खाय, फेर सूं कोशिश करो';

  @override
  String get otpResent => 'ओटीपी फेर सूं भेज दी';

  @override
  String get requestNewCode => 'नयो कोड मांगो';

  @override
  String get requestNewCodeIn => 'नयो कोड मांगो';

  @override
  String get clickPictureCamera => 'कैमरा सूं फोटो खींचो';

  @override
  String get pickImageGallery => 'गैलरी सूं फोटो चुनो';

  @override
  String get deleteMyAccount => 'म्हारो खातो हटाओ';

  @override
  String get createNewRoom => 'नवो कोठो बनाओ';

  @override
  String get pleaseEnterScheduledDateTime =>
      'कृपया तय करेली तारीख अणे समय दाखिल करो';

  @override
  String get scheduleDateTimeLabel => 'तय करेलो तारीख अणे समय';

  @override
  String get enterTags => 'टैग दाखिल करो';

  @override
  String get joinCommunity => 'समुदाय में जोड़ो';

  @override
  String get followUsOnX => 'X पर म्हाने फॉलो करो';

  @override
  String get joinDiscordServer => 'डिस्कॉर्ड सर्वर में जोड़ो';

  @override
  String get noLyrics => 'कोई गीत कोनी';

  @override
  String noStoriesInCategory(String categoryName) {
    return '$categoryName श्रेणी में पेश करावण खातर कोई कथा कोनी';
  }

  @override
  String get newChapters => 'नवा अध्याय';

  @override
  String get helpToGrow => 'वधावण में मदद करो';

  @override
  String get share => 'शेयर करो';

  @override
  String get rate => 'रेट करो';

  @override
  String get aboutResonate => 'रेज़ोनेट रो बारे में';

  @override
  String get description => 'विवरण';

  @override
  String get confirm => 'पक्को करो';

  @override
  String get classic => 'शास्त्रीय';

  @override
  String get time => 'समय';

  @override
  String get vintage => 'विंटेज';

  @override
  String get amber => 'एम्बर';

  @override
  String get forest => 'जंगल';

  @override
  String get cream => 'क्रीम';

  @override
  String get none => 'काई भी कोनी';

  @override
  String checkOutGitHub(String url) {
    return 'म्हारो GitHub रिपोजिटरी देखो: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'AOSSIE लोगो';

  @override
  String get errorLoadPackageInfo => 'पैकेज जानकारी लोड कोनी हो सकी';

  @override
  String get searchFailed => 'Failed to search rooms. Please try again.';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध है';

  @override
  String get newVersionAvailable => 'नवो संस्करण उपलब्ध है!';

  @override
  String get upToDate => 'पूरो अपडेट है';

  @override
  String get latestVersion => 'आप नवीनतम संस्करण उपयोग कर रह्या हो';

  @override
  String get profileCreatedSuccessfully => 'प्रोफाइल सफलतापूर्वक बन गई';

  @override
  String get invalidScheduledDateTime => 'अमान्य तय करेलो तारीख अणे समय';

  @override
  String get scheduledDateTimePast =>
      'तय करेलो तारीख अणे समय भूतकाल में कोनी हो सके';

  @override
  String get joinRoom => 'कोठा में जोड़ो';

  @override
  String get unknownUser => 'अनजाणो';

  @override
  String get canceled => 'रद्द';

  @override
  String get english => 'en';

  @override
  String get emailVerificationRequired => 'ईमेल सत्यापन जरूरी है';

  @override
  String get verify => 'सत्यापित करो';

  @override
  String get audioRoom => 'ऑडियो कोठो';

  @override
  String toRoomAction(String action) {
    return 'कोठा ने $action करावण खातर';
  }

  @override
  String get mailSentMessage => 'ईमेल भेज दी गई';

  @override
  String get disconnected => 'जुड़ो कोनी है';

  @override
  String get micOn => 'माइक';

  @override
  String get speakerOn => 'स्पीकर';

  @override
  String get endChat => 'चैट खतम';

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
  String get register => 'रजिस्टर करो';

  @override
  String get newToResonate => 'रेज़ोनेट में नवां?';

  @override
  String get alreadyHaveAccount => 'पहले सूं खातो है?';

  @override
  String get checking => 'जांच हो रही है...';

  @override
  String get forgotPasswordMessage =>
      'आपरो रजिस्टर करेलो ईमेल पता दाखिल करो पासवर्ड रीसेट करावण खातर.';

  @override
  String get usernameUnavailable => 'यूजरनेम उपलब्ध कोनी है!';

  @override
  String get usernameInvalidOrTaken =>
      'आ यूजरनेम अमान्य है या पहले सूं लिया गयो है.';

  @override
  String get otpResentMessage => 'कृपया आपरी मेल में नवो ओटीपी चेक करो.';

  @override
  String get connectionError =>
      'कनेक्शन में दिक्कत है. कृपया आपरो इंटरनेट जांचो अणे फेर सूं कोशिश करो.';

  @override
  String get seconds => 'सेकंड';

  @override
  String get unsavedChangesWarning =>
      'अगर आप सेव कर्या बिना आगे जाओगा तो सारा बिना-सेव बदलाव खो जावेंगे.';

  @override
  String get deleteAccountPermanent =>
      'आ क्रिया आपरो खातो हमेशा खातर हटाई देसी. आ वापस ना हो सके. म्हे आपरो यूजरनेम, ईमेल पता अणे खातो सूं जुड़ो सग्लो डेटा हटाई देसू. आप फेर सूं वापस ना पावो.';

  @override
  String get giveGreatName => 'एक बढ़िया नाम दो..';

  @override
  String get joinCommunityDescription =>
      'समुदाय में जुड़ो अणे आपरा सवाल साफ करो, नवा फीचर सुझाओ, समस्या रिपोर्ट करो अणे घणो किछु.';

  @override
  String get resonateDescription =>
      'रेज़ोनेट एक सामाजिक मीडिया मंच है, जठे हर आवाज की कीमत है. आपरा विचार, कथा अणे अनुभव दूसरां सूं बांटो. आपरी ऑडियो यात्रा अब शुरू करो. अलग-अलग चर्चा अणे विषयां में शामिल होवो. रेज़ोनेट करावण वाले कोठा खोजो अणे समुदाय रो हिस्सा बनो. बातचीत में जुड़ो!';

  @override
  String get resonateFullDescription =>
      'रेज़ोनेट एक क्रांतिकारी आवाज-आधारित सामाजिक मीडिया मंच है, जठे हर आवाज मायने राखे.\nरीयल-टाइम ऑडियो बातचीत में जुड़ो, अलग-अलग चर्चा में भाग लो,\nअणे समान सोच वाला लोकां सूं जुड़ो. म्हारो मंच दे:\n- विषय-आधारित चर्चा साथे लाइव ऑडियो कोठा\n- आवाज जरिए आसान सोशल नेटवर्किंग\n- समुदाय-चालित सामग्री मॉडरेशन\n- क्रॉस-प्लेटफॉर्म सपोर्ट\n- एंड-टू-एंड एन्क्रिप्टेड निजी बातचीत\n\nAOSSIE मुक्त स्रोत समुदाय द्वारा विकसित, म्हे यूजर गोपनीयता अणे समुदाय-चालित विकास ने प्राथमिकता दीजे.\nसामाजिक ऑडियो रो भविष्य बनावण में म्हारे साथ जुड़ो!';

  @override
  String get stable => 'स्थिर';

  @override
  String get usernameCharacterLimit =>
      'यूजरनेम कम से कम 5 अक्षर रो होवण जरूरी है.';

  @override
  String get submit => 'सबमिट करो';

  @override
  String get anonymous => 'अनजान';

  @override
  String get noSearchResults => 'कोई खोज परिणाम कोनी मिला';

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
    return '🚀 आ गजब रो कोठो देखो: $roomName!\n\n📖 वर्णन: $description\n👥 हां $participants सहभाग्यां सूं जोड़ो!';
  }

  @override
  String participantsCount(int count) {
    return '$count सहभाग्या';
  }

  @override
  String get join => 'जुड़ो';

  @override
  String get invalidTags => 'अवैध टैग:';

  @override
  String get cropImage => 'छवि काटो';

  @override
  String get profileSavedSuccessfully => 'प्रोफाइल सफलतापूर्वक सेव हो गई';

  @override
  String get profileUpdatedSuccessfully => 'सगला बदलाव सफलतापूर्वक सेव हो गया.';

  @override
  String get profileUpToDate => 'प्रोफाइल अपडेट है';

  @override
  String get noChangesToSave =>
      'काई नवा बदलाव ना करा, सेव करां खातर कुछ भी नहीं.';

  @override
  String get connectionFailed => 'कनेक्शन फेल हो गयो';

  @override
  String get unableToJoinRoom =>
      'कोठा में जुड़ां में असमर्थ. कृपया आपरो नेटवर्क जांचो और फेरूं प्रयास करो.';

  @override
  String get connectionLost => 'कनेक्शन कट गयो';

  @override
  String get unableToReconnect =>
      'कोठा सूं फेरूं कनेक्ट करां में असमर्थ. कृपया फेरूं जुड़ां रो प्रयास करो.';

  @override
  String get invalidFormat => 'अवैध फॉर्मेट!';

  @override
  String get usernameAlphanumeric =>
      'उपयोगकर्ता नाम अल्फान्यूमेरिक होणो जरूरी है और विशेष अक्षर ना हो सके.';

  @override
  String get userProfileCreatedSuccessfully =>
      'आपरो उपयोगकर्ता प्रोफाइल सफलतापूर्वक तयार हो गयो.';

  @override
  String get emailVerificationMessage =>
      'आगे बढ़ां खातर, आपरो ईमेल पता सत्यापित करो.';

  @override
  String addNewChaptersToStory(String storyName) {
    return '$storyName में नवा अध्याय जोड़ो';
  }

  @override
  String get currentChapters => 'वर्तमान अध्याय';

  @override
  String get sourceCodeOnGitHub => 'GitHub पर स्रोत कोड';

  @override
  String get createAChapter => 'एक अध्याय बनाओ';

  @override
  String get chapterTitle => 'अध्याय शीर्षक *';

  @override
  String get aboutRequired => 'बाबत *';

  @override
  String get changeCoverImage => 'कवर छवि बदलो';

  @override
  String get uploadAudioFile => 'ऑडियो फाइल अपलोड करो';

  @override
  String get uploadLyricsFile => 'गीत फाइल अपलोड करो';

  @override
  String get createChapter => 'अध्याय बनाओ';

  @override
  String audioFileSelected(String fileName) {
    return 'ऑडियो फाइल चुनी गई: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'गीत फाइल चुनी गई: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'कृपया सगला जरूरी फील्ड भरो और आपरी ऑडियो फाइल अर गीत फाइल अपलोड करो';

  @override
  String get scheduled => 'शेड्यूल कर्यो गयो';

  @override
  String get ok => 'ठीक है';

  @override
  String get roomDescriptionOptional => 'कोठा रो वर्णन (वैकल्पिक)';

  @override
  String get deleteAccount => 'खातो हटावो';

  @override
  String get createYourStory => 'आपरी कहानी बनावो';

  @override
  String get titleRequired => 'शीर्षक *';

  @override
  String get category => 'श्रेणी *';

  @override
  String get addChapter => 'अध्याय जोड़ो';

  @override
  String get createStory => 'कहानी बनावो';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'कृपया सगला जरूरी फील्ड भरो, कम से कम एक अध्याय जोड़ो, और कवर छवि चुनो.';

  @override
  String get toConfirmType => 'पुष्टी करां खातर, टाइप करो';

  @override
  String get inTheBoxBelow => 'नीचे बॉक्स में';

  @override
  String get iUnderstandDeleteMyAccount => 'मैं समझ्यो, आपरो खातो हटावो';

  @override
  String get whatDoYouWantToListenTo => 'आप क्या सुनणो चाहो?';

  @override
  String get categories => 'श्रेणियाँ';

  @override
  String get stories => 'कहानियाँ';

  @override
  String get someSuggestions => 'कुच्छ सुझाव';

  @override
  String get getStarted => 'शुरू करो';

  @override
  String get skip => 'छोड़ो';

  @override
  String get welcomeToResonate => 'रेजोनेट में स्वागत है';

  @override
  String get exploreDiverseConversations => 'विभिन्न बातचीत एक्सप्लोर करो';

  @override
  String get yourVoiceMatters => 'आपरो आवाज़ महत्व राखे है';

  @override
  String get joinConversationExploreRooms =>
      'बातचीत में जुड़ो! कोठा एक्सप्लोर करो, मित्रां सूं जोड़ो, और आपरो आवाज भरोसा सहित शेयर करो.';

  @override
  String get diveIntoDiverseDiscussions =>
      'विभिन्न चर्चा और विषय में सामिल होवो. \nरेजोनेट पर कोठा खोजो और समुदाय रो भाग बनके सहभाग करो.';

  @override
  String get atResonateEveryVoiceValued =>
      'रेजोनेट में, हर आवाज़ की कदर है. आपरे विचार, कहानी, और अनुभव दूसरां सूं शेयर करो. आपरी ऑडियो यात्रा अब शुरू करो.';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username ने आपकू आगामी कोठा में टैग कर्यो: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username ने आपकू कोठा में टैग कर्यो: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username ने आपरी कहानी पसंद करी: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username ने आपरी कोठा खातर सब्सक्राइब करयो: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username ने आपकू फॉलो करणा शुरू करयो';
  }

  @override
  String get youHaveNewNotification => 'आपकू नई नोटिफिकेशन आयो है';

  @override
  String get hangOnGoodThingsTakeTime =>
      'रुको, अच्छी चीज़ां खातर समय लागे है 🔍';

  @override
  String get resonateOpenSourceProject =>
      'रेजोनेट AOSSIE द्वारा मेंटेन करलो मुक्त स्रोत प्रोजेक्ट है. योगदान देवा खातर हमारो GitHub देखो.';

  @override
  String get mute => 'मौन करो';

  @override
  String get speakerLabel => 'स्पीकर';

  @override
  String get end => 'खतम करो';

  @override
  String get saveChanges => 'बदल सेव करो';

  @override
  String get discard => 'त्याग दो';

  @override
  String get save => 'सेव करो';

  @override
  String get changeProfilePicture => 'प्रोफाइल फोटो बदलो';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get remove => 'हटाओ';

  @override
  String created(String date) {
    return '$date ने बनायो';
  }

  @override
  String get chapters => 'अध्याय';

  @override
  String get deleteStory => 'कहानी हटावो';

  @override
  String createdBy(String creatorName) {
    return '$creatorName द्वारा बनायो';
  }

  @override
  String get start => 'शुरू करो';

  @override
  String get unsubscribe => 'सब्सक्रिप्शन रद्द करो';

  @override
  String get subscribe => 'सब्सक्रिप्शन लो';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'नाटक',
      'comedy': 'हास्य',
      'horror': 'डरावनी',
      'romance': 'प्रेम',
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
      'amberTheme': 'एम्बर',
      'forestTheme': 'जंगल',
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
      one: '१ मिनट पहले',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटे पहले',
      one: '१ घंटा पहले',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन पहले',
      one: '१ दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String get by => 'द्वारा';

  @override
  String get likes => 'पसंद';

  @override
  String get lengthMinutes => 'मिनट';

  @override
  String get requiredField => 'जरूरी फील्ड';

  @override
  String get onlineUsers => 'ऑनलाइन उपयोगकर्ता';

  @override
  String get noOnlineUsers => 'अभी कोई उपयोगकर्ता ऑनलाइन नहीं है';

  @override
  String get chooseUser => 'चैट करां खातर उपयोगकर्ता चुनो';

  @override
  String get quickMatch => 'फास्ट मैच';

  @override
  String get story => 'कहानी';

  @override
  String get user => 'उपयोगकर्ता';

  @override
  String get following => 'अनुसरण कर रयो';

  @override
  String get followers => 'अनुयायी';

  @override
  String get friendRequests => 'मित्र विनंतियाँ';

  @override
  String get friendRequestSent => 'मित्र विनंती भेजी';

  @override
  String friendRequestSentTo(String username) {
    return 'आपरी मित्र विनंती $username ने भेजी गई है.';
  }

  @override
  String get friendRequestCancelled => 'मित्र विनंती रद्द';

  @override
  String friendRequestCancelledTo(String username) {
    return 'आपरी मित्र विनंती $username ने रद्द करी गई है.';
  }

  @override
  String get requested => 'विनंती करी';

  @override
  String get friends => 'मित्र';

  @override
  String get addFriend => 'मित्र जोड़ो';

  @override
  String get friendRequestAccepted => 'मित्र विनंती स्वीकार करी';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'आप अब $username स्यूं मित्र हो.';
  }

  @override
  String get friendRequestDeclined => 'मित्र विनंती नकार दी';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'आपने $username कडून मित्र विनंती नकार दी है.';
  }

  @override
  String get accept => 'स्वीकारो';

  @override
  String get callDeclined => 'कॉल नकार दी';

  @override
  String callDeclinedTo(String username) {
    return 'उपयोगकर्ता $username ने कॉल नकार दी.';
  }

  @override
  String get checkForUpdates => 'अपडेट जांचो';

  @override
  String get updateNow => 'अभी अपडेट करो';

  @override
  String get updateLater => 'पाछे';

  @override
  String get updateSuccessful => 'अपडेट सफल';

  @override
  String get updateSuccessfulMessage => 'रेजोनेट सफलतापूर्वक अपडेट करी गई है!';

  @override
  String get updateCancelled => 'अपडेट रद्द';

  @override
  String get updateCancelledMessage => 'अपडेट उपयोगकर्ता द्वारा रद्द करी गई';

  @override
  String get updateFailed => 'अपडेट अयोग्य';

  @override
  String get updateFailedMessage =>
      'अपडेट अयोग्य. कृपया Play Store सूं अपडेट करो.';

  @override
  String get updateError => 'अपडेट त्रुटि';

  @override
  String get updateErrorMessage =>
      'अपडेट करताना त्रुटि हुई. कृपया पुनः प्रयास करो.';

  @override
  String get platformNotSupported => 'प्लेटफॉर्म समर्थित नहीं';

  @override
  String get platformNotSupportedMessage =>
      'अपडेट जांच केवल Android डिवाइस पर उपलब्ध है';

  @override
  String get updateCheckFailed => 'अपडेट जांच अयोग्य';

  @override
  String get updateCheckFailedMessage =>
      'अपडेट जांच नहीं कर सकत. कृपया बाद में प्रयास करो.';

  @override
  String get upToDateTitle => 'आप अद्यावधिक हो!';

  @override
  String get upToDateMessage => 'आप रेजोनेट रो नवीनतम संस्करण उपयोग कर रयो हो';

  @override
  String get updateAvailableTitle => 'अपडेट उपलब्ध!';

  @override
  String get updateAvailableMessage =>
      'रेजोनेट रो नवीनतम संस्करण Play Store पर उपलब्ध है';

  @override
  String get updateFeaturesImprovement => 'नवीन फीचर्स और सुधार पावो!';

  @override
  String get failedToRemoveRoom => 'Failed to remove room';

  @override
  String get roomRemovedSuccessfully =>
      'Room removed from your list successfully';

  @override
  String get alert => 'सतर्क';

  @override
  String get removedFromRoom => 'आपने रिपोर्ट की गई या कमरे सूं हटायो गयो';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'उत्पीडन / द्वेष भाषण',
      'abuse': 'अपमानजनक सामग्री / हिंसा',
      'spam': 'स्पॅम / घोटाळा / धोखाधड़ी',
      'impersonation': 'झूठी पहचान / खोटा खाता',
      'illegal': 'अवैध गतिविधि',
      'selfharm': 'आत्महानि / मानसिक स्वास्थ्य',
      'misuse': 'मंच का दुरुपयोग',
      'other': 'अन्य',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate =>
      'आपको कई रिपोर्ट मिली हैं और आपको रेजोनेट उपयोग करने से ब्लॉक कर दी गई है. अगर आप विश्वास नहीं करते, तो AOSSIE सूं संपर्क करो.';

  @override
  String get reportParticipant => 'सहभागी रिपोर्ट करो';

  @override
  String get selectReportType => 'कृपया रिपोर्ट प्रकार चुनो';

  @override
  String get reportSubmitted => 'रिपोर्ट सफलतापूर्वक सबमिट की गई';

  @override
  String get reportFailed => 'रिपोर्ट सबमिशन अयोग्य';

  @override
  String get additionalDetailsOptional => 'अतिरिक्त विवरण (वैकल्पिक)';

  @override
  String get submitReport => 'रिपोर्ट सबमिट करो';

  @override
  String get actionBlocked => 'क्रिया ब्लॉक की गई';

  @override
  String get cannotStopRecording =>
      'आप रिकॉर्डिंग रोक नहीं सकते, कमरे बंद होते ही रिकॉर्डिंग बंद हो जाएगी.';

  @override
  String get liveChapter => 'लाइव अध्याय';

  @override
  String get viewOrEditLyrics => 'गीत देखो या संपादित करो';

  @override
  String get close => 'बंद करो';

  @override
  String get verifyChapterDetails => 'अध्याय विवरण सत्यापित करो';

  @override
  String get author => 'लेखक';

  @override
  String get startLiveChapter => 'लाइव अध्याय शुरू करो';

  @override
  String get fillAllFields => 'कृपया सभी आवश्यक फील्ड भरो';

  @override
  String get noRecordingError =>
      'आपने अध्याय के लिए कोई रिकॉर्डिंग नहीं की है. कमरे बंद होने से पहले कृपया रिकॉर्डिंग करो';
}