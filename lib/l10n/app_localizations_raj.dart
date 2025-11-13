// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Rajasthani (`raj`).
class AppLocalizationsRaj extends AppLocalizations {
  AppLocalizationsRaj([String locale = 'raj']) : super(locale);

  @override
  String get title => 'रेज़ोनेट';

  @override
  String get roomDescription =>
      'दूसरा बंदो री राय ने आदर देणो। गलत बात मत बोलो।';

  @override
  String get hidePassword => 'पासवर्ड छुपाओ';

  @override
  String get showPassword => 'पासवर्ड दिखाओ';

  @override
  String get passwordEmpty => 'पासवर्ड खाली नहीं रहणो चाहिए';

  @override
  String get password => 'पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड पक्का करो';

  @override
  String get passwordsNotMatch => 'पासवर्ड मेल नहीं खातां';

  @override
  String get userCreatedStories => 'यूजर बनायली कहाणीयां';

  @override
  String get yourStories => 'थारी कहाणीयां';

  @override
  String get userNoStories => 'यूजर कोनी कोई कहाणी बनाई';

  @override
  String get youNoStories => 'थाने कोई कहाणी बनाई नी है';

  @override
  String get follow => 'फॉलो करो';

  @override
  String get editProfile => 'प्रोफाइल बदलो';

  @override
  String get verifyEmail => 'ईमेल पक्की करो';

  @override
  String get verified => 'पक्की करी गई';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get userLikedStories => 'यूजर ने पसंद करी कहाणीयां';

  @override
  String get yourLikedStories => 'थारी पसंद करी कहाणीयां';

  @override
  String get userNoLikedStories => 'यूजर ने कोई कहाणी पसंद नी करी';

  @override
  String get youNoLikedStories => 'थाने कोई कहाणी पसंद नी करी';

  @override
  String get live => 'लाइव';

  @override
  String get upcoming => 'आवण वालो';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'कोई रूम उपलब्ध नी है',
      'false': 'कोई आवण वालो रूम नी है',
      'other': 'रूम री जानकारी नी है',
    });
    return '$_temp0\nनीचे एक जोड़ण सूं शुरू करो!';
  }

  @override
  String get user1 => 'यूजर 1';

  @override
  String get user2 => 'यूजर 2';

  @override
  String get you => 'थूं';

  @override
  String get areYouSure => 'पक्को है थूं?';

  @override
  String get loggingOut => 'थूं Resonate सूं लोग आउट थई रह्यो है।';

  @override
  String get yes => 'हां';

  @override
  String get no => 'ना';

  @override
  String get incorrectEmailOrPassword => 'ईमेल या पासवर्ड गलत है';

  @override
  String get passwordShort => 'पासवर्ड 8 अक्षरां सूं छोटो है';

  @override
  String get tryAgain => 'फेर कोसिस करो!';

  @override
  String get success => 'सफलता';

  @override
  String get passwordResetSent => 'पासवर्ड रीसेट ईमेल भेज दी गई!';

  @override
  String get error => 'गलती';

  @override
  String get resetPassword => 'पासवर्ड फेर सेट करो';

  @override
  String get enterNewPassword => 'नयो पासवर्ड भरो';

  @override
  String get newPassword => 'नयो पासवर्ड';

  @override
  String get setNewPassword => 'नयो पासवर्ड सेट करो';

  @override
  String get emailChanged => 'ईमेल बदली गई';

  @override
  String get emailChangeSuccess => 'ईमेल सफळतापूर्वक बदल दी गई!';

  @override
  String get failed => 'नाकाम';

  @override
  String get emailChangeFailed => 'ईमेल बदलवां में नाकामी आई';

  @override
  String get oops => 'अरे!';

  @override
  String get emailExists => 'ईमेल पहले सूं ही मौजूद है';

  @override
  String get changeEmail => 'ईमेल बदलो';

  @override
  String get enterValidEmail => 'एक सही ईमेल पता भरो';

  @override
  String get newEmail => 'नयो ईमेल';

  @override
  String get currentPassword => 'हाल को पासवर्ड';

  @override
  String get emailChangeInfo =>
      'सुरक्षा खातर थाने थारो हाल को पासवर्ड दालनो पड़ेगो जद थूं ईमेल बदलै। ईमेल बदल पच्छी थारे नये ईमेल सूं लॉगिन करजो।';

  @override
  String get oauthUsersMessage =>
      '(सिरफ ओ लोकां खातर जिक्यां Google या Github सूं लॉगिन कर्यो है)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'ईमेल बदलवा खातर, \"हाल को पासवर्ड\" फील्ड में नयो पासवर्ड भरो। याद राखजो, फेर थां Google/GitHub या नये ईमेल औ पासवर्ड सूं लॉगिन कर सको।';

  @override
  String get resonateTagline => 'बातचीत रो असीम संसार में पग भरो।';

  @override
  String get signInWithEmail => 'ईमेल सूं साइन इन करो';

  @override
  String get or => 'या';

  @override
  String get continueWith => 'सूं चालू राखो';

  @override
  String get continueWithGoogle => 'Google सूं चालू राखो';

  @override
  String get continueWithGitHub => 'GitHub सूं चालू राखो';

  @override
  String get resonateLogo => 'Resonate लोगो';

  @override
  String get iAlreadyHaveAnAccount => 'म्हारे पाछै सूं ही अकाउंट है';

  @override
  String get createNewAccount => 'नयो अकाउंट बनाओ';

  @override
  String get userProfile => 'यूजर प्रोफाइल';

  @override
  String get passwordIsStrong => 'पासवर्ड मजबूत है';

  @override
  String get admin => 'एडमिन';

  @override
  String get moderator => 'मॉडरेटर';

  @override
  String get speaker => 'बोलण वालो';

  @override
  String get listener => 'सुणण वालो';

  @override
  String get removeModerator => 'मॉडरेटर हटाओ';

  @override
  String get kickOut => 'निकालो';

  @override
  String get addModerator => 'मॉडरेटर बनाओ';

  @override
  String get addSpeaker => 'स्पीकर बनाओ';

  @override
  String get makeListener => 'लिस्नर बनाओ';

  @override
  String get pairChat => 'जोड़ी बात';

  @override
  String get chooseIdentity => 'अपणी पहचान चुनो';

  @override
  String get selectLanguage => 'भाषा चुनो';

  @override
  String get noConnection => 'कनेक्शन नी है';

  @override
  String get loadingDialog => 'लोडिंग चालू है';

  @override
  String get createAccount => 'अकाउंट बनाओ';

  @override
  String get enterValidEmailAddress => 'सही ईमेल पता भरो';

  @override
  String get email => 'ईमेल';

  @override
  String get passwordRequirements => 'पासवर्ड कम से कम 8 अक्षर रो होणो चाहिए';

  @override
  String get includeNumericDigit => 'कम से कम 1 नंबर शामिल करो';

  @override
  String get includeUppercase => 'कम से कम 1 बड़ा अक्षर शामिल करो';

  @override
  String get includeLowercase => 'कम से कम 1 छोटो अक्षर शामिल करो';

  @override
  String get includeSymbol => 'कम से कम 1 निशान शामिल करो';

  @override
  String get signedUpSuccessfully => 'खातो सफलतासूं बनग्यो';

  @override
  String get newAccountCreated => 'थारो नयो खातो सफलतासूं बनग्यो';

  @override
  String get signUp => 'खातो बनाओ';

  @override
  String get login => 'लॉगिन करो';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get accountSettings => 'खातां री सेटिंग्स';

  @override
  String get account => 'खातो';

  @override
  String get appSettings => 'ऐप री सेटिंग्स';

  @override
  String get themes => 'थीम्स';

  @override
  String get about => 'बारे में';

  @override
  String get other => 'अर';

  @override
  String get contribute => 'योगदान करो';

  @override
  String get logOut => 'लॉगआउट करो';

  @override
  String get participants => 'भाग लेणवारा';

  @override
  String get delete => 'डिलीट करो';

  @override
  String get leave => 'छोड़ो';

  @override
  String get leaveButton => 'बाहर आवो';

  @override
  String get findingRandomPartner => 'थारा खातर रैंडम पार्टनर खोजी रह्या आहै';

  @override
  String get quickFact => 'जल्दी बात';

  @override
  String get cancel => 'रद्द करो';

  @override
  String get completeYourProfile => 'थारो प्रोफाइल पूरा करो';

  @override
  String get uploadProfilePicture => 'प्रोफाइल फोटो अपलोड करो';

  @override
  String get enterValidName => 'सही नाम भरो';

  @override
  String get name => 'नाम';

  @override
  String get username => 'यूजरनाम';

  @override
  String get enterValidDOB => 'सही जन्मतिथि भरो';

  @override
  String get dateOfBirth => 'जन्मतिथि';

  @override
  String get forgotPassword => 'पासवर्ड भूल ग्या?';

  @override
  String get next => 'आगला';

  @override
  String get noStoriesExist => 'कोई कहानी उपलब्ध नां है';

  @override
  String get enterVerificationCode => 'थारो वेरिफिकेशन कोड भरो';

  @override
  String get verificationCodeSent => '6 अंक रो वेरिफिकेशन कोड भेज दियो गयो:\n';

  @override
  String get verificationComplete => 'वेरिफिकेशन पूरा थाय गयो';

  @override
  String get verificationCompleteMessage => 'बधाई! थारो ईमेल वेरिफाय थाय गयो';

  @override
  String get verificationFailed => 'वेरिफिकेशन फेल थाय गयो';

  @override
  String get otpMismatch => 'OTP मेल नां खायो, फेर कोशिश करो';

  @override
  String get otpResent => 'OTP फेर भेज दियो गयो';

  @override
  String get requestNewCode => 'नयो कोड मांगो';

  @override
  String get requestNewCodeIn => 'नयो कोड मांगी सकजो पाछो:';

  @override
  String get clickPictureCamera => 'कैमरा सूं फोटो खींचो';

  @override
  String get pickImageGallery => 'गैलरी सूं फोटो चुनो';

  @override
  String get deleteMyAccount => 'म्हारो खातो डिलीट करो';

  @override
  String get createNewRoom => 'नयो रूम बनाओ';

  @override
  String get pleaseEnterScheduledDateTime => 'शेड्यूल डेट-टाइम भरो';

  @override
  String get scheduleDateTimeLabel => 'शेड्यूल डेट टाइम';

  @override
  String get enterTags => 'टैग भरो';

  @override
  String get joinCommunity => 'कम्युनिटी में शामिल होवो';

  @override
  String get followUsOnX => 'X पर म्हारो पीछो करो';

  @override
  String get joinDiscordServer => 'डिस्कॉर्ड सर्वर में जोड़ो';

  @override
  String get noLyrics => 'कोई लिरिक्स नां मिल्या';

  @override
  String noStoriesInCategory(String categoryName) {
    return '$categoryName कैटेगरी में कोई स्टोरी मौजूद नां है';
  }

  @override
  String get newChapters => 'नया चैप्टर';

  @override
  String get helpToGrow => 'विकास में मदद करो';

  @override
  String get share => 'शेयर करो';

  @override
  String get rate => 'रेट करो';

  @override
  String get aboutResonate => 'Resonate बारे में';

  @override
  String get description => 'विवरण';

  @override
  String get confirm => 'पक्को करो';

  @override
  String get classic => 'क्लासिक';

  @override
  String get time => 'टाइम';

  @override
  String get vintage => 'विंटेज';

  @override
  String get amber => 'ऐंबर';

  @override
  String get forest => 'जंगल';

  @override
  String get cream => 'क्रीम';

  @override
  String get none => 'कोई नां';

  @override
  String checkOutGitHub(String url) {
    return 'म्हारो GitHub रिपॉजिटरी देखो: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'AOSSIE लोगो';

  @override
  String get errorLoadPackageInfo => 'पैकेज जानकारी लोड नां थाई सकी';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध है';

  @override
  String get newVersionAvailable => 'नयो वर्जन उपलब्ध है!';

  @override
  String get upToDate => 'ताजा वर्जन चालो है';

  @override
  String get latestVersion => 'थारो ऐप ताजा वर्जन पर चालो है';

  @override
  String get profileCreatedSuccessfully => 'प्रोफाइल सफलतासूं बनग्यो';

  @override
  String get invalidScheduledDateTime => 'गलत शेड्यूल डेट टाइम';

  @override
  String get scheduledDateTimePast => 'शेड्यूल डेट टाइम पुराणो नां हो सकै';

  @override
  String get joinRoom => 'रूम में जावो';

  @override
  String get unknownUser => 'अग्यांत';

  @override
  String get canceled => 'रद्द थाय गयो';

  @override
  String get english => 'en';

  @override
  String get emailVerificationRequired => 'ईमेल वेरिफिकेशन जरूरी है';

  @override
  String get verify => 'वेरिफाय करो';

  @override
  String get audioRoom => 'ऑडियो रूम';

  @override
  String toRoomAction(String action) {
    return 'रूम $action करजो';
  }

  @override
  String get mailSentMessage => 'मेल भेजी गी';

  @override
  String get disconnected => 'कनेक्शन टूट ग्यो';

  @override
  String get micOn => 'माइक चालू';

  @override
  String get speakerOn => 'स्पीकर चालू';

  @override
  String get endChat => 'चैट खत्म करजो';

  @override
  String get monthJan => 'जन';

  @override
  String get monthFeb => 'फर';

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
  String get monthAug => 'अग';

  @override
  String get monthSep => 'सित';

  @override
  String get monthOct => 'अक्ट';

  @override
  String get monthNov => 'नव';

  @override
  String get monthDec => 'दिस';

  @override
  String get register => 'रजिस्टर करजो';

  @override
  String get newToResonate => 'रेज़ोनेट में नवा हो? ';

  @override
  String get alreadyHaveAccount => 'पहले सूं अकाउंट है? ';

  @override
  String get checking => 'चैक कर रिया...';

  @override
  String get forgotPasswordMessage =>
      'पासवर्ड रीसेट करवा खातर आपरो रजिस्टरड ईमेल डालो।';

  @override
  String get usernameUnavailable => 'यूजरनेम उपलब्ध नाहीं!';

  @override
  String get usernameInvalidOrTaken =>
      'ई यूजरनेम अमान्य है या पहले सूं लीधो ग्यो है।';

  @override
  String get otpResentMessage => 'नवो OTP खातर आपरो मेल चैक करजो।';

  @override
  String get connectionError =>
      'कनेक्शन में गलती है। आपरो इंटरनेट चैक करजो और फेर कोशिश करजो।';

  @override
  String get seconds => 'सेकंड।';

  @override
  String get unsavedChangesWarning =>
      'जो सेव बिना आगे वयो तो किएला बदलाव गुम हो जासे।';

  @override
  String get deleteAccountPermanent =>
      'ई क्रिया आपरो अकाउंट हमेशा खातर डिलीट कर देसी। ई उलट नहीं सकै। हम आपरो यूजरनेम, ईमेल पता और बाकी डेटा सब डिलीट कर देसू। फेर ओ वापस नहीं मिल सकै।';

  @override
  String get giveGreatName => 'एक बढ़िया नाम डालो..';

  @override
  String get joinCommunityDescription =>
      'कम्युनिटी में जूड़के आप संदेह दूर कर सकै, नवीं फीचर सुझा सकै, समस्या बतासकै और घणो कुछ।';

  @override
  String get resonateDescription =>
      'रेज़ोनेट एक सोशल मीडिया प्लेटफॉर्म है, जिथे हर आवाज़ री कद्र है। आपरी बात, कहानी और अनुभव सांझा करजो। आपरो ऑडियो सफर शुरू करजो। अलग-अलग चर्चा और विषय में भाग ल्यो। ओ रूम खोजो ज्या आपरो मन रेजोनेट करै और कम्युनिटी को हिस्सा बनजो। बात में जूड़जो!';

  @override
  String get resonateFullDescription =>
      'रेज़ोनेट एक क्रांतिकारी आवाज़-आधारित सोशल मीडिया प्लेटफॉर्म है, जिथे हर आवाज़ मायने रखै। \nरीयल-टाइम ऑडियो बातचीत में जूड़जो, अलग-अलग चर्चा में भाग ल्यो, और मिलते-जुलते सोचवालां सूं जुड़जो।\nहमारो प्लेटफॉर्म ऑफर करै:\n- लाइव ऑडियो रूम विषय आधारित चर्चा खातर\n- आवाज़ सूं सहज सोशल नेटवर्किंग\n- कम्युनिटी द्वारा चलावेली कंटेंट मॉडरेशन\n- सभी प्लेटफॉर्म पर चलै\n- एंड-टू-एंड एन्क्रिप्टेड प्राइवेट बातचीत\n\nAOSSIE ओपन सोर्स कम्युनिटी द्वारा विकसित, हम यूजर प्राइवेसी और कम्युनिटी-ड्रिवन विकास ने प्राथमिकता देसू। आवाज़ री दुनिया को भविष्य आकार देण में सागी बनजो!';

  @override
  String get stable => 'स्थिर';

  @override
  String get usernameCharacterLimit =>
      'यूजरनेम में 5 सूं ज्यादा अक्षर होवा चाहिए।';

  @override
  String get submit => 'भेजो';

  @override
  String get anonymous => 'अनजान';

  @override
  String get noSearchResults => 'कोई खोज परिणाम नहीं';

  @override
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  ) {
    return '🚀 ई बढ़िया रूम देखो: $roomName!\n\n📖 विवरण: $description\n👥 हाले $participants भागीदारां सूं जूड़जो!';
  }

  @override
  String participantsCount(int count) {
    return '$count भागीदार';
  }

  @override
  String get join => 'जूड़जो';

  @override
  String get invalidTags => 'अमान्य टैग:';

  @override
  String get cropImage => 'छवि काटजो';

  @override
  String get profileSavedSuccessfully => 'प्रोफाइल अपडेट गी';

  @override
  String get profileUpdatedSuccessfully => 'सारा बदलाव सफलता सूं सेव गेला।';

  @override
  String get profileUpToDate => 'प्रोफाइल अपडेटेड है';

  @override
  String get noChangesToSave => 'नवा बदलाव नाहीं किए, सेव करवा खातर कुछ नाहीं।';

  @override
  String get connectionFailed => 'कनेक्शन फेल ग्यो';

  @override
  String get unableToJoinRoom =>
      'रूम में जूड़ नहीं सकै। नेटवर्क चैक करजो और फेर कोशिश करजो।';

  @override
  String get connectionLost => 'कनेक्शन टूट ग्यो';

  @override
  String get unableToReconnect =>
      'रूम सूं फेर कनेक्ट नहीं हो सकै। फेर कोशिश करजो।';

  @override
  String get invalidFormat => 'अमान्य फॉर्मेट!';

  @override
  String get usernameAlphanumeric =>
      'यूजरनेम में केवल अक्षर और नंबर होवा चाहिए, खास चिन्ह नहीं।';

  @override
  String get userProfileCreatedSuccessfully =>
      'आपरो यूजर प्रोफाइल सफलता सूं बन ग्यो।';

  @override
  String get emailVerificationMessage =>
      'आगै बढ़वा खातर आपरी ईमेल वेरिफाय करजो।';

  @override
  String addNewChaptersToStory(String storyName) {
    return 'कहाणी $storyName में नवा चैप्टर जोड़जो';
  }

  @override
  String get currentChapters => 'मौजूदा चैप्टर';

  @override
  String get sourceCodeOnGitHub => 'सोर्स कोड GitHub पर';

  @override
  String get createAChapter => 'नवो चैप्टर बनावो';

  @override
  String get chapterTitle => 'चैप्टर शीर्षक *';

  @override
  String get aboutRequired => 'विवरण *';

  @override
  String get changeCoverImage => 'कवर छवि बदलो';

  @override
  String get uploadAudioFile => 'ऑडियो फाइल अपलोड करजो';

  @override
  String get uploadLyricsFile => 'लिरिक्स फाइल अपलोड करजो';

  @override
  String get createChapter => 'चैप्टर बनावो';

  @override
  String audioFileSelected(String fileName) {
    return 'ऑडियो फाइल चुन ली: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'गीत रो फाइल चुन ली गई: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'कृपा करीन सब जरूरी फील्ड भरो अर ऑडियो फाइल अर गीत री फाइल अपलोड करो';

  @override
  String get scheduled => 'नियत कियो गयो';

  @override
  String get ok => 'ठीक';

  @override
  String get roomDescriptionOptional => 'रूम रो वर्णन (वैकल्पिक)';

  @override
  String get deleteAccount => 'अकाउंट डिलीट करो';

  @override
  String get createYourStory => 'आपणी कहानी बनाओ';

  @override
  String get titleRequired => 'शीर्षक *';

  @override
  String get category => 'श्रेणी *';

  @override
  String get addChapter => 'अध्याय जोड़ो';

  @override
  String get createStory => 'कहानी बनाओ';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'कृपा करीन सब जरूरी फील्ड भरो, कम से कम एक अध्याय जोड़ो अर कवर इमेज चुनो।';

  @override
  String get toConfirmType => 'पुष्टि करवा खातर लिखो';

  @override
  String get inTheBoxBelow => 'नीचे वाले बॉक्स में';

  @override
  String get iUnderstandDeleteMyAccount => 'मने समझ आ गी, मरो अकाउंट डिलीट करो';

  @override
  String get whatDoYouWantToListenTo => 'तमे का सुनवा चाहो हो?';

  @override
  String get categories => 'श्रेणियाँ';

  @override
  String get stories => 'कहानियाँ';

  @override
  String get someSuggestions => 'कुछ सुझाव';

  @override
  String get getStarted => 'शुरू करो';

  @override
  String get skip => 'छोडो';

  @override
  String get welcomeToResonate => 'Resonate में आपरौ स्वागत है';

  @override
  String get exploreDiverseConversations => 'विविध बातचीत खोजो';

  @override
  String get yourVoiceMatters => 'आपरी आवाज मायने रखै है';

  @override
  String get joinConversationExploreRooms =>
      'बातचीत में शामिल होवो! रूम खोजो, मित्रां सूं जुड़ो अर आपरी आवाज दुनियाने सुनावो।';

  @override
  String get diveIntoDiverseDiscussions =>
      'विभिन्न चर्चाओं अर विषयां में डुबकी लगाओ।\nज्या रूम तमने पसंद आवै, ओथ शामिल होवो अर समुदाय रो हिस्सा बनो।';

  @override
  String get atResonateEveryVoiceValued =>
      'Resonate पर हर आवाज रो सम्मान है। आपरा विचार, कहानी अर अनुभव बांटो। आजे आपरी ऑडियो यात्रा शुरू करो।';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username नै तमने आगळ आवणारे रूम में टैग कियो: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username नै तमने रूम में टैग कियो: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username नै तमारी कहानी पसंद आई: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username नै तमारा रूम ने सब्सक्राइब कियो: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username नै तमने फॉलो करणो चालू कियो';
  }

  @override
  String get youHaveNewNotification => 'तमने एक नई सूचना मिली है';

  @override
  String get hangOnGoodThingsTakeTime =>
      'थोड़ो थामो, बढ़िया चीज़ां ने समय लागै 🔍';

  @override
  String get resonateOpenSourceProject =>
      'Resonate एक ओपन सोर्स प्रोजेक्ट है जे AOSSIE नै बनाए राख्यो है। योगदान करवा खातर अमारो GitHub देखो।';

  @override
  String get mute => 'म्यूट करो';

  @override
  String get speakerLabel => 'स्पीकर';

  @override
  String get end => 'समाप्त करो';

  @override
  String get saveChanges => 'बदलाव सहेजो';

  @override
  String get discard => 'रद्द करो';

  @override
  String get save => 'सहेजो';

  @override
  String get changeProfilePicture => 'प्रोफाइल तस्वीर बदलो';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get remove => 'हटाओ';

  @override
  String created(String date) {
    return '$date नै बनायो गयो';
  }

  @override
  String get chapters => 'अध्याय';

  @override
  String get deleteStory => 'कहानी डिलीट करो';

  @override
  String createdBy(String creatorName) {
    return '$creatorName नै बनायो';
  }

  @override
  String get start => 'शुरू करो';

  @override
  String get unsubscribe => 'सब्सक्रिप्शन हटाओ';

  @override
  String get subscribe => 'सब्सक्राइब करो';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'ड्रामा',
      'comedy': 'कॉमेडी',
      'horror': 'हॉरर',
      'romance': 'रोमांस',
      'thriller': 'थ्रिलर',
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
      'amberTheme': 'ऐम्बर',
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
      other: '$count मिनट पहलां',
      one: '1 मिनट पहलां',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटा पहलां',
      one: '1 घंटो पहलां',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन पेला',
      one: '1 दिन पेला',
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
  String get onlineUsers => 'ऑनलाइन यूजर';

  @override
  String get noOnlineUsers => 'कोई यूजर हाले में ऑनलाइन ना है';

  @override
  String get chooseUser => 'चैट करणी हो तो यूजर चुनो';

  @override
  String get quickMatch => 'फटाफट मेल';

  @override
  String get story => 'कहाणी';

  @override
  String get user => 'यूजर';

  @override
  String get following => 'फॉलो करेला';

  @override
  String get followers => 'फॉलोअर';

  @override
  String get friendRequests => 'दोस्ती अरजियां';

  @override
  String get friendRequestSent => 'दोस्ती अरजी भेजी गी';

  @override
  String friendRequestSentTo(String username) {
    return 'थारी दोस्ती अरजी $username नै भेजी गी.';
  }

  @override
  String get friendRequestCancelled => 'दोस्ती अरजी रद्द करी गी';

  @override
  String friendRequestCancelledTo(String username) {
    return 'थारी दोस्ती अरजी $username नै रद्द करी गी.';
  }

  @override
  String get requested => 'अरजी भेजी';

  @override
  String get friends => 'दोस्त';

  @override
  String get addFriend => 'दोस्त जोड़ो';

  @override
  String get friendRequestAccepted => 'दोस्ती अरजी स्वीकारी गी';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'थूं अब $username स्यूं दोस्त बन ग्या.';
  }

  @override
  String get friendRequestDeclined => 'दोस्ती अरजी ठुकराई गी';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'थूं $username री दोस्ती अरजी ठुकराई दी.';
  }

  @override
  String get accept => 'स्वीकारो';

  @override
  String get callDeclined => 'कॉल ठुकराई गी';

  @override
  String callDeclinedTo(String username) {
    return 'यूजर $username नै कॉल ठुकराई दी.';
  }

  @override
  String get checkForUpdates => 'अपडेट जांचो';

  @override
  String get updateNow => 'हाले अपडेट करो';

  @override
  String get updateLater => 'पाछो';

  @override
  String get updateSuccessful => 'अपडेट सफल';

  @override
  String get updateSuccessfulMessage => 'Resonate सफलतापूर्वक अपडेट थ्यो!';

  @override
  String get updateCancelled => 'अपडेट रद्द थ्यो';

  @override
  String get updateCancelledMessage => 'यूजर नै अपडेट रद्द करी दी';

  @override
  String get updateFailed => 'अपडेट फेल थ्यो';

  @override
  String get updateFailedMessage =>
      'अपडेट ना थ्यो. कृपा करके Play Store स्यूं मैन्युअली अपडेट करो.';

  @override
  String get updateError => 'अपडेट गलती';

  @override
  String get updateErrorMessage => 'अपडेट करतां कोई गलती आ गी. फेर कोसिस करो.';

  @override
  String get platformNotSupported => 'प्लेटफॉर्म सपोर्टेड ना है';

  @override
  String get platformNotSupportedMessage =>
      'अपडेट जांच केवल Android डिवाइसां पै उपलब्ध है';

  @override
  String get updateCheckFailed => 'अपडेट जांच फेल थई';

  @override
  String get updateCheckFailedMessage =>
      'अपडेट जांच ना थई सकी. पाछो कोसिस करो.';

  @override
  String get upToDateTitle => 'थूं ताजा संस्करण चालाओ!';

  @override
  String get upToDateMessage => 'थूं Resonate को नया संस्करण चलाय रह्या हो';

  @override
  String get updateAvailableTitle => 'नवो अपडेट उपलब्ध!';

  @override
  String get updateAvailableMessage =>
      'Resonate को नवो संस्करण Play Store पै उपलब्ध है';

  @override
  String get updateFeaturesImprovement => 'नवीन फीचर अने सुधार मिलवो!';

  @override
  String get alert => 'चेतावणी';

  @override
  String get removedFromRoom => 'थूं रिपोर्ट या रूम स्यूं हटायो ग्यो';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'उत्पीड़न / घृणा भाषण',
      'abuse': 'अपमानजनक सामग्री / हिंसा',
      'spam': 'स्पैम / धोखाधड़ी / ठगी',
      'impersonation': 'नकली अकाउंट / भेस बदलो',
      'illegal': 'गैरकानूनी गतिविधियां',
      'selfharm': 'स्वयं-हानि / आत्महत्या / मानसिक स्थिति',
      'misuse': 'प्लेटफॉर्म नो गलत उपयोग',
      'other': 'बाकी',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate =>
      'थूं यूजरां स्यूं कई रिपोर्ट पाई है अने थूं Resonate उपयोग करणी रोको ग्यो है. जो गलती लागे तो AOSSIE स्यूं संपर्क करो.';

  @override
  String get reportParticipant => 'प्रतिभागी रिपोर्ट करो';

  @override
  String get selectReportType => 'कृपा करके रिपोर्ट प्रकार चुनो';

  @override
  String get reportSubmitted => 'रिपोर्ट सफलतापूर्वक जमा करी गी';

  @override
  String get reportFailed => 'रिपोर्ट जमा फेल थई';

  @override
  String get additionalDetailsOptional => 'वधू विवरण (वैकल्पिक)';

  @override
  String get submitReport => 'रिपोर्ट जमा करो';

  @override
  String get actionBlocked => 'क्रिया रोकी गी';

  @override
  String get cannotStopRecording =>
      'थूं रिकॉर्डिंग नै अपने हाथ स्यूं रोक ना सकै, रिकॉर्डिंग तो कमरो बंद होवे जण रुक जासी.';

  @override
  String get liveChapter => 'लाइव अध्याय';

  @override
  String get viewOrEditLyrics => 'गीत देखो या सुधारो';

  @override
  String get close => 'बंद करो';

  @override
  String get verifyChapterDetails => 'अध्याय ब्योरा जांचो';

  @override
  String get author => 'लेखक';

  @override
  String get startLiveChapter => 'लाइव अध्याय सुरू करो';

  @override
  String get fillAllFields => 'कृपा करी सगळा जरूरी फील्ड भरो';

  @override
  String get noRecordingError =>
      'थूं अध्याय खातिर काई रिकॉर्डिंग ना करी. कृपा करी कमरो छोड़णी पेला अध्याय रिकॉर्ड करो';
}
