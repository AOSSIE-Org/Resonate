// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get title => 'റെസൊണേറ്റ്';

  @override
  String get roomDescription =>
      'മര്യാദയുള്ളവരായിരിക്കുക, മറ്റൊരാളുടെ അഭിപ്രായത്തെ ബഹുമാനിക്കുക. പരുഷമായ അഭിപ്രായങ്ങൾ ഒഴിവാക്കുക.';

  @override
  String get hidePassword => 'പാസ്‌വേഡ് മറയ്ക്കുക';

  @override
  String get showPassword => 'പാസ്‌വേഡ് കാണിക്കുക';

  @override
  String get passwordEmpty => 'പാസ്‌വേഡ് ശൂന്യമായിരിക്കരുത്.';

  @override
  String get password => 'പാസ്‌വേഡ്';

  @override
  String get confirmPassword => 'പാസ്‌വേഡ് സ്ഥിരീകരിക്കുക';

  @override
  String get passwordsNotMatch => 'പാസ്‌വേഡുകൾ പൊരുത്തപ്പെടുന്നില്ല';

  @override
  String get userCreatedStories => 'ഉപയോക്താവ് സൃഷ്ടിച്ച കഥകൾ';

  @override
  String get yourStories => 'നിങ്ങളുടെ കഥകൾ';

  @override
  String get userNoStories => 'ഉപയോക്താവ് ഒരു കഥയും സൃഷ്ടിച്ചിട്ടില്ല.';

  @override
  String get youNoStories => 'നിങ്ങൾ ഒരു കഥയും സൃഷ്ടിച്ചിട്ടില്ല.';

  @override
  String get follow => 'പിന്തുടരുക';

  @override
  String get editProfile => 'പ്രൊഫൈൽ തിരുത്തുക';

  @override
  String get verifyEmail => 'ഇമെയിൽ സ്ഥിരീകരിക്കുക';

  @override
  String get verified => 'സ്ഥിരീകരിച്ചിരിക്കുന്നു';

  @override
  String get profile => 'പ്രൊഫൈൽ';

  @override
  String get userLikedStories => 'ഉപയോക്താവ് ഇഷ്ടപ്പെട്ട കഥകൾ';

  @override
  String get yourLikedStories => 'നിങ്ങളുടെ ഇഷ്ടപ്പെട്ട കഥകൾ';

  @override
  String get userNoLikedStories => 'ഉപയോക്താവ് ഒരു കഥയും ഇഷ്ടപ്പെട്ടിട്ടില്ല.';

  @override
  String get youNoLikedStories => 'നിങ്ങൾ ഒരു കഥയും ഇഷ്ടപ്പെട്ടിട്ടില്ല.';

  @override
  String get live => 'ലൈവ്';

  @override
  String get upcoming => 'വരാനിരിക്കുന്ന';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'മുറി ലഭ്യമല്ല.',
      'false': 'വരാനിരിക്കുന്ന മുറികളൊന്നും ലഭ്യമല്ല.',
      'other': 'മുറി വിവരങ്ങൾ ലഭ്യമല്ല',
    });
    return '$_temp0\nതാഴെ ഒരു മുറി ചേർത്ത് ആരംഭിക്കുക!';
  }

  @override
  String get user1 => 'യൂസർ 1';

  @override
  String get user2 => 'യൂസർ 2';

  @override
  String get you => 'നിങ്ങൾ';

  @override
  String get areYouSure => 'നിങ്ങൾക്ക് ഉറപ്പാണോ?';

  @override
  String get loggingOut => 'നിങ്ങൾ റെസൊണേറ്റിൽ നിന്ന് ലോഗ് ഔട്ട് ചെയ്യുകയാണ്.';

  @override
  String get yes => 'അതെ';

  @override
  String get no => 'ഇല്ല';

  @override
  String get incorrectEmailOrPassword => 'ഇമെയിൽ അല്ലെങ്കിൽ പാസ്‌വേഡ് തെറ്റാണ്';

  @override
  String get passwordShort => 'പാസ്‌വേഡ് 8 അക്ഷരങ്ങളിൽ കുറവാണ്';

  @override
  String get tryAgain => 'വീണ്ടും ശ്രമിക്കുക!';

  @override
  String get success => 'വിജയം';

  @override
  String get passwordResetSent => 'പാസ്‌വേഡ് റീസെറ്റ് ഇമെയിൽ അയച്ചു!';

  @override
  String get error => 'തെറ്റ്';

  @override
  String get resetPassword => 'പാസ്സ്‌വേർഡ് റീസെറ്റ് ചെയ്യുക';

  @override
  String get enterNewPassword => 'നിങ്ങളുടെ പുതിയ പാസ്‌വേഡ് നൽകുക';

  @override
  String get newPassword => 'പുതിയ പാസ്‌വേഡ്';

  @override
  String get setNewPassword => 'പുതിയ പാസ്സ്‌വേർഡ് സെറ്റ് ചെയ്യുക';

  @override
  String get emailChanged => 'ഇമെയിൽ മാറ്റി';

  @override
  String get emailChangeSuccess => 'ഇമെയിൽ വിജയകരമായി മാറ്റി!';

  @override
  String get failed => 'പരാജയപ്പെട്ടു';

  @override
  String get emailChangeFailed => 'ഇമെയിൽ മാറ്റാൻ പരാജയപ്പെട്ടു';

  @override
  String get oops => 'അയ്യോ!';

  @override
  String get emailExists => 'ഇമെയിൽ ഇതിനകം നിലവിലുണ്ട്';

  @override
  String get changeEmail => 'ഇമെയിൽ മാറ്റുക';

  @override
  String get enterValidEmail => 'ദയവായി സാധുവായ ഇമെയിൽ വിലാസം നൽകുക';

  @override
  String get newEmail => 'പുതിയ ഇമെയിൽ';

  @override
  String get currentPassword => 'നിലവിലെ പാസ്‌വേഡ്';

  @override
  String get emailChangeInfo =>
      'അധിക സുരക്ഷയ്ക്കായി, നിങ്ങളുടെ ഇമെയിൽ വിലാസം മാറ്റുമ്പോൾ നിങ്ങളുടെ അക്കൗണ്ടിന്റെ നിലവിലുള്ള പാസ്‌വേഡ് നൽകണം. നിങ്ങളുടെ ഇമെയിൽ വിലാസം മാറ്റിയ ശേഷം, ഭാവിയിലെ ലോഗിനുകൾക്കായി അപ്ഡേറ്റ് ചെയ്ത ഇമെയിൽ ഉപയോഗിക്കുക.';

  @override
  String get oauthUsersMessage =>
      'Google അല്ലെങ്കിൽ Github ഉപയോഗിച്ച് ലോഗിൻ ചെയ്ത ഉപയോക്താക്കൾക്ക് മാത്രം';

  @override
  String get oauthUsersEmailChangeInfo =>
      'ഇമെയിൽ മാറ്റാൻ, ദയവായി \"നിലവിലെ പാസ്‌വേഡ്\" ഫീൽഡിൽ പുതിയ പാസ്‌വേഡ് നൽകുക. ഈ പാസ്‌വേഡ് ഓർക്കുക, കാരണം ഭാവിയിൽ ഇമെയിൽ മാറ്റങ്ങൾക്കായി ഇത് ആവശ്യമായിരിക്കും. ഇനി മുതൽ, Google/GitHub അല്ലെങ്കിൽ നിങ്ങളുടെ പുതിയ ഇമെയിൽ-പാസ്‌വേഡ് സംയോജനത്തിലൂടെ ലോഗിൻ ചെയ്യാം.';

  @override
  String get resonateTagline =>
      'പരിധിയില്ലാത്ത സംഭാഷണങ്ങളുടെ ഒരു\nലോകത്തേക്ക് പ്രവേശിക്കൂ.';

  @override
  String get signInWithEmail => 'ഇമെയിൽ ഉപയോഗിച്ച് സൈൻ ഇൻ ചെയ്യുക';

  @override
  String get or => 'അഥവാ';

  @override
  String get continueWith => 'ഇതോടൊപ്പം തുടരുക';

  @override
  String get continueWithGoogle => 'ഗൂഗിൾ ഉപയോഗിച്ച് തുടരുക';

  @override
  String get continueWithGitHub => 'GitHub ഉപയോഗിച്ച് തുടരുക';

  @override
  String get resonateLogo => 'റെസൊണേറ്റിന്റെ ലോഗോ';

  @override
  String get iAlreadyHaveAnAccount => 'എനിക്ക് ഇതിനകം ഒരു അക്കൗണ്ട് ഉണ്ട്';

  @override
  String get createNewAccount => 'പുതിയ അക്കൗണ്ട് സൃഷ്ടിക്കുക';

  @override
  String get userProfile => 'ഉപയോക്‌താവിന്റെ പ്രൊഫൈൽ';

  @override
  String get passwordIsStrong => 'പാസ്‌വേഡ് ശക്തമാണ്';

  @override
  String get admin => 'അഡ്മിൻ';

  @override
  String get moderator => 'മോഡറേറ്റർ';

  @override
  String get speaker => 'സ്പീക്കർ';

  @override
  String get listener => 'ശ്രോതാവ്';

  @override
  String get removeModerator => 'മോഡറേറ്റർ നീക്കം ചെയ്യുക';

  @override
  String get kickOut => 'ഉപയോക്താവിനെ പുറത്താക്കുക';

  @override
  String get addModerator => 'മോഡരേറ്ററിനെ ചേർക്കുക';

  @override
  String get addSpeaker => 'സ്പീക്കറെ ചേർക്കുക';

  @override
  String get makeListener => 'ശ്രോതാവായി മാറ്റുക';

  @override
  String get pairChat => 'ചാറ്റ് ജോടിയാക്കുക';

  @override
  String get chooseIdentity => 'ഐഡന്റിറ്റി തിരഞ്ഞെടുക്കുക';

  @override
  String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get noConnection => 'ഇന്റർനെറ്റ് ബന്ധം ഇല്ല';

  @override
  String get loadingDialog => 'ലോഡിംഗ് ഡയലോഗ്';

  @override
  String get createAccount => 'അക്കൗണ്ട് സൃഷ്ടിക്കുക';

  @override
  String get enterValidEmailAddress => 'സാധുവായ ഇമെയിൽ വിലാസം നൽകുക';

  @override
  String get email => 'ഇമെയിൽ';

  @override
  String get passwordRequirements =>
      'പാസ്‌വേഡ് കുറഞ്ഞത് 8 അക്ഷരങ്ങൾ നീളമുള്ളതായിരിക്കണം';

  @override
  String get includeNumericDigit =>
      'കുറഞ്ഞത് ഒരു സംഖ്യാ അക്കമെങ്കിലും ഉൾപ്പെടുത്തുക';

  @override
  String get includeUppercase => 'കുറഞ്ഞത് ഒരു വലിയക്ഷരമെങ്കിലും ഉൾപ്പെടുത്തുക';

  @override
  String get includeLowercase =>
      'കുറഞ്ഞത് ഒരു ചെറിയക്ഷരമെങ്കിലും ഉൾപ്പെടുത്തുക';

  @override
  String get includeSymbol => 'കുറഞ്ഞത് ഒരു ചിഹ്നമെങ്കിലും ഉൾപ്പെടുത്തുക';

  @override
  String get signedUpSuccessfully => 'വിജയകരമായി സൈൻ അപ്പ് ചെയ്തു';

  @override
  String get newAccountCreated =>
      'നിങ്ങൾ വിജയകരമായി ഒരു പുതിയ അക്കൗണ്ട് സൃഷ്ടിച്ചു';

  @override
  String get signUp => 'സൈൻ അപ്പ് ചെയ്യുക';

  @override
  String get login => 'ലോഗിൻ';

  @override
  String get settings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get accountSettings => 'അക്കൗണ്ട് ക്രമീകരണങ്ങൾ';

  @override
  String get account => 'അക്കൗണ്ട്';

  @override
  String get appSettings => 'ആപ്പ് ക്രമീകരണങ്ങൾ';

  @override
  String get themes => 'തീമുകൾ';

  @override
  String get about => 'അബൗട്ട്';

  @override
  String get other => 'മറ്റുള്ളവ';

  @override
  String get contribute => 'സംഭാവന ചെയ്യുക';

  @override
  String get appPreferences => 'ആപ്പ് മുൻഗണനകൾ';

  @override
  String get transcriptionModel => 'ട്രാൻസ്ക്രിപ്ഷൻ മോഡൽ';

  @override
  String get transcriptionModelDescription =>
      'വോയ്‌സ് ട്രാൻസ്ക്രിപ്ഷനായി AI മോഡൽ തിരഞ്ഞെടുക്കുക. വലിയ മോഡലുകൾ കൂടുതൽ കൃത്യതയുള്ളവയാണ്, പക്ഷേ വേഗത കുറവാണ്, കൂടുതൽ സംഭരണം ആവശ്യമാണ്.';

  @override
  String get whisperModelTiny => 'ഏറ്റവും ചെറുത്';

  @override
  String get whisperModelTinyDescription =>
      'ഏറ്റവും വേഗതയേറിയത്, കൃത്യത കുറഞ്ഞത് (~39 MB)';

  @override
  String get whisperModelBase => 'ബേസ്';

  @override
  String get whisperModelBaseDescription =>
      'സന്തുലിത വേഗതയും കൃത്യതയും (~74 MB)';

  @override
  String get whisperModelSmall => 'ചെറുത്';

  @override
  String get whisperModelSmallDescription =>
      'നല്ല കൃത്യത, വേഗത കുറവ് (~244 MB)';

  @override
  String get whisperModelMedium => 'മധ്യം';

  @override
  String get whisperModelMediumDescription =>
      'ഉയർന്ന കൃത്യത, വേഗത കുറവ് (~769 MB)';

  @override
  String get whisperModelLargeV1 => 'വലുത് V1';

  @override
  String get whisperModelLargeV1Description =>
      'ഏറ്റവും കൃത്യം, ഏറ്റവും വേഗത കുറഞ്ഞത് (~1.55 GB)';

  @override
  String get whisperModelLargeV2 => 'വലുത് V2';

  @override
  String get whisperModelLargeV2Description =>
      'ഉയർന്ന കൃത്യതയോടെ മെച്ചപ്പെടുത്തിയ വലിയ മോഡൽ (~1.55 GB)';

  @override
  String get modelDownloadInfo =>
      'ആദ്യം ഉപയോഗിക്കുമ്പോൾ മോഡലുകൾ ഡൗൺലോഡ് ചെയ്യപ്പെടും. ബേസ്, സ്മോൾ, അല്ലെങ്കിൽ മീഡിയം എന്നിവ ഉപയോഗിക്കാൻ ഞങ്ങൾ ശുപാർശ ചെയ്യുന്നു. വലിയ മോഡലുകൾക്ക് വളരെ ഉയർന്ന നിലവാരമുള്ള ഉപകരണങ്ങൾ ആവശ്യമാണ്.';

  @override
  String get logOut => 'ലോഗ് ഔട്ട് ചെയ്യുക';

  @override
  String get participants => 'പങ്കാളികൾ';

  @override
  String get delete => 'ഇല്ലാതാക്കുക';

  @override
  String get leave => 'വിടുക';

  @override
  String get leaveButton => 'വിടുക';

  @override
  String get findingRandomPartner =>
      'നിങ്ങൾക്കായി ഒരു ക്രമരഹിത പങ്കാളിയെ കണ്ടെത്തുന്നു';

  @override
  String get quickFact => 'ചില വസ്തുതകൾ';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get hide => 'നീക്കം ചെയ്യുക';

  @override
  String get removeRoom => 'റൂം നീക്കം ചെയ്യുക';

  @override
  String get removeRoomFromList => 'പട്ടികയിൽ നിന്ന് നീക്കം ചെയ്യുക';

  @override
  String get removeRoomConfirmation =>
      'നിങ്ങളുടെ ലിസ്റ്റിൽ നിന്ന് വരാനിരിക്കുന്ന ഈ മുറി നീക്കം ചെയ്യണമെന്ന് ഉറപ്പാണോ?';

  @override
  String get completeYourProfile => 'നിങ്ങളുടെ പ്രൊഫൈൽ പൂർത്തിയാക്കുക';

  @override
  String get uploadProfilePicture => 'പ്രൊഫൈൽ ചിത്രം അപ്‌ലോഡ് ചെയ്യുക';

  @override
  String get enterValidName => 'സാധുവായ പേര് നൽകുക';

  @override
  String get name => 'പേര്';

  @override
  String get username => 'ഉപയോക്തൃനാമം';

  @override
  String get enterValidDOB => 'സാധുവായ ജനനത്തീയതി നൽകുക';

  @override
  String get dateOfBirth => 'ജനനത്തീയതി';

  @override
  String get forgotPassword => 'പാസ്‌വേഡ് മറന്നോ?';

  @override
  String get next => 'അടുത്തത്';

  @override
  String get noStoriesExist => 'അവതരിപ്പിക്കാൻ കഥകളൊന്നുമില്ല.';

  @override
  String get enterVerificationCode => 'നിങ്ങളുടെ പരിശോധന\nകോഡ് നൽകുക';

  @override
  String get verificationCodeSent => 'ഞങ്ങൾ 6-അക്കം പരിശോധന കോഡ് അയച്ചു\n';

  @override
  String get verificationComplete => 'പരിശോധിച്ചുറപ്പിക്കൽ പൂർത്തിയായി';

  @override
  String get verificationCompleteMessage => 'നിങ്ങളുടെ ഇമെയിൽ സ്ഥിരീകരിച്ചു';

  @override
  String get verificationFailed => 'പരിശോധന പരാജയപ്പെട്ടു';

  @override
  String get otpMismatch => 'OTP ഒറ്റപ് ശെരി അല്ല, ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get otpResent => 'OTP വീണ്ടും അയച്ചു';

  @override
  String get requestNewCode => 'പുതിയ കോഡ് അഭ്യർത്ഥിക്കുക';

  @override
  String get requestNewCodeIn => 'പുതിയ കോഡ് അഭ്യർത്ഥിക്കാൻ';

  @override
  String get clickPictureCamera => 'പുതിയ ചിത്രം എടുക്കുക';

  @override
  String get pickImageGallery => 'ഗാലറിയിൽ നിന്ന് ചിത്രം തിരഞ്ഞെടുക്കുക';

  @override
  String get deleteMyAccount => 'എന്റെ അക്കൗണ്ട് ഇല്ലാതാക്കുക';

  @override
  String get createNewRoom => 'പുതിയ റൂം സൃഷ്ടിക്കുക';

  @override
  String get pleaseEnterScheduledDateTime =>
      'ദയവായി ഷെഡ്യൂൾ ചെയ്ത തീയതി-സമയം നൽകുക.';

  @override
  String get scheduleDateTimeLabel => 'തീയതി സമയം ഷെഡ്യൂൾ ചെയ്യുക';

  @override
  String get enterTags => 'ടാഗുകൾ നൽകുക';

  @override
  String get joinCommunity => 'കമ്മ്യൂണിറ്റിയിൽ ചേരുക';

  @override
  String get followUsOnX => 'X-ൽ ഞങ്ങളെ പിന്തുടരുക';

  @override
  String get followUsOnYouTube => 'Follow us on YouTube';

  @override
  String get joinDiscordServer => 'ഡിസ്‌കോർഡ് സെർവറിൽ ചേരുക';

  @override
  String get noLyrics => 'ലിറിക്‌സ് ഇല്ല';

  @override
  String noStoriesInCategory(String categoryName) {
    return '$categoryName വിഭാഗത്തിൽ അവതരിപ്പിക്കാൻ നിലവിൽ കഥകളൊന്നുമില്ല.';
  }

  @override
  String get newChapters => 'പുതിയ അധ്യായങ്ങൾ';

  @override
  String get helpToGrow => 'വളരാൻ സഹായിക്കുക';

  @override
  String get share => 'പങ്കിടുക';

  @override
  String get rate => 'റേറ്റ് ചെയ്യുക';

  @override
  String get aboutResonate => 'റെസൊണേറ്റിനെ കുറിച്ച്';

  @override
  String get description => 'വിവരണം';

  @override
  String get confirm => 'സ്ഥിരീകരിക്കുക';

  @override
  String get classic => 'ക്ലാസിക്';

  @override
  String get time => 'സമയം';

  @override
  String get vintage => 'വിൻറ്റേജ്';

  @override
  String get amber => 'ആംബർ';

  @override
  String get forest => 'ഫോറസ്റ്റ്';

  @override
  String get cream => 'ക്രീം';

  @override
  String get none => 'ഒന്നുമില്ല';

  @override
  String checkOutGitHub(String url) {
    return 'ഞങ്ങളുടെ GitHub സംഭരണി പരിശോധിക്കുക: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'AOSSIE ലോഗോ';

  @override
  String get errorLoadPackageInfo =>
      'പാക്കേജ് വിവരങ്ങൾ ലോഡ് ചെയ്യാൻ കഴിഞ്ഞില്ല.';

  @override
  String get searchFailed => 'റൂമുകൾ തിരയാനായില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get updateAvailable => 'അപ്ഡേറ്റ് ലഭ്യമാണ്';

  @override
  String get newVersionAvailable => 'പുതിയ വേർഷൻ ലഭ്യമാണ്!';

  @override
  String get upToDate => 'അപ്ഡേറ്റ് ചെയ്തിരിക്കുന്നു';

  @override
  String get latestVersion => 'നിങ്ങൾ ഏറ്റവും പുതിയ വേർഷൻ ഉപയോഗിക്കുന്നു';

  @override
  String get profileCreatedSuccessfully => 'പ്രൊഫൈൽ വിജയകരമായി സൃഷ്ടിച്ചു';

  @override
  String get invalidScheduledDateTime => 'അസാധുവായ ഷെഡ്യൂൾ ചെയ്ത തീയതി സമയം';

  @override
  String get scheduledDateTimePast =>
      'ഷെഡ്യൂൾ ചെയ്ത തീയതി സമയം കഴിഞ്ഞുപോയതായിരിക്കരുത്.';

  @override
  String get joinRoom => 'റൂമിൽ ചേരുക';

  @override
  String get unknownUser => 'അജ്ഞാതം';

  @override
  String get canceled => 'റദ്ദാക്കി';

  @override
  String get english => 'en';

  @override
  String get emailVerificationRequired => 'ഇമെയിൽ പരിശോധന ആവശ്യമാണ്';

  @override
  String get verify => 'സ്ഥിരീകരിക്കുക';

  @override
  String get audioRoom => 'ഓഡിയോ റൂം';

  @override
  String toRoomAction(String action) {
    return 'മുറി $action ചെയ്യുക';
  }

  @override
  String get mailSentMessage => 'ഇമെയിൽ അയച്ചു';

  @override
  String get disconnected => 'ഡിസ്കണക്റ്റഡ്';

  @override
  String get micOn => 'മൈക്ക് ഓൺ';

  @override
  String get speakerOn => 'സ്പീക്കർ ഓൺ';

  @override
  String get endChat => 'ചാറ്റ്-അവസാനിപ്പിക്കുക';

  @override
  String get monthJan => 'ജനുവരി';

  @override
  String get monthFeb => 'ഫെബ്രുവരി';

  @override
  String get monthMar => 'മാർച്ച്';

  @override
  String get monthApr => 'ഏപ്രിൽ';

  @override
  String get monthMay => 'മേയ്';

  @override
  String get monthJun => 'ജൂൺ';

  @override
  String get monthJul => 'ജൂലൈ';

  @override
  String get monthAug => 'ഓഗസ്റ്റ്';

  @override
  String get monthSep => 'സെപ്റ്റംബർ';

  @override
  String get monthOct => 'ഒക്ടോബർ';

  @override
  String get monthNov => 'നവംബർ';

  @override
  String get monthDec => 'ഡിസംബർ';

  @override
  String get register => 'രജിസ്റ്റർ ചെയ്യുക';

  @override
  String get newToResonate => 'റെസൊണേറ്റിൽ പുതിയവരാണോ? ';

  @override
  String get alreadyHaveAccount => 'ഇതിനകം ഒരു അക്കൗണ്ട് ഉണ്ടോ? ';

  @override
  String get checking => 'പരിശോധിക്കുന്നു...';

  @override
  String get forgotPasswordMessage =>
      'പാസ്‌വേഡ് പുനഃസജ്ജമാക്കാൻ നിങ്ങളുടെ രജിസ്റ്റർ ചെയ്ത ഇമെയിൽ വിലാസം നൽകുക.';

  @override
  String get usernameUnavailable => 'ഉപയോക്തൃനാമം ലഭ്യമല്ല!';

  @override
  String get usernameInvalidOrTaken =>
      'ഈ ഉപയോക്തൃനാമം അസാധുവാണ് അല്ലെങ്കിൽ ഇതിനകം ഉപയോഗിച്ചതാണ്.';

  @override
  String get otpResentMessage =>
      'ദയവായി പുതിയ OTP ലഭിക്കാൻ നിങ്ങളുടെ മെയിൽ പരിശോധിക്കുക.';

  @override
  String get connectionError =>
      'ഇന്റർനെറ്റ് ബന്ധം ഇല്ല. ദയവായി നിങ്ങളുടെ ഇന്റർനെറ്റ് പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get seconds => 'സെക്കൻഡ്.';

  @override
  String get unsavedChangesWarning =>
      'സംരക്ഷിക്കാതെ മുന്നോട്ട് പോയാൽ, സംരക്ഷിക്കാത്ത മാറ്റങ്ങൾ നഷ്ടപ്പെടും.';

  @override
  String get deleteAccountPermanent =>
      'ഈ പ്രവർത്തനം നിങ്ങളുടെ അക്കൗണ്ട് സ്ഥിരമായി ഇല്ലാതാക്കും. ഇത് തിരികെ വരാനാകാത്ത പ്രക്രിയയാണ്. നിങ്ങളുടെ ഉപയോക്തൃനാമം, ഇമെയിൽ വിലാസം, നിങ്ങളുടെ അക്കൗണ്ടുമായി ബന്ധപ്പെട്ട എല്ലാ മറ്റ് ഡാറ്റയും ഞങ്ങൾ ഇല്ലാതാക്കും. നിങ്ങൾ അത് പുനരുദ്ധരിക്കാൻ കഴിയില്ല.';

  @override
  String get giveGreatName => 'നല്ലൊരു പേര് പറയൂ...';

  @override
  String get joinCommunityDescription =>
      'കമ്മ്യൂണിറ്റിയിൽ ചേരുന്നതിലൂടെ നിങ്ങളുടെ സംശയങ്ങൾ ദൂരീകരിക്കാനും, പുതിയ സവിശേഷതകൾക്കായി നിർദ്ദേശിക്കാനും, നിങ്ങൾ നേരിട്ട പ്രശ്നങ്ങൾ റിപ്പോർട്ട് ചെയ്യാനും മറ്റും കഴിയും.';

  @override
  String get resonateDescription =>
      'ഓരോ ശബ്ദത്തിനും വില കൽപ്പിക്കുന്ന ഒരു സോഷ്യൽ മീഡിയ പ്ലാറ്റ്‌ഫോമാണ് റെസൊണേറ്റ്. നിങ്ങളുടെ ചിന്തകളും കഥകളും അനുഭവങ്ങളും മറ്റുള്ളവരുമായി പങ്കിടുക. നിങ്ങളുടെ ഓഡിയോ യാത്ര ഇപ്പോൾ ആരംഭിക്കുക. വൈവിധ്യമാർന്ന ചർച്ചകളിലും വിഷയങ്ങളിലും മുഴുകുക. നിങ്ങളുമായി പ്രതിധ്വനിക്കുന്ന മുറികൾ കണ്ടെത്തി സമൂഹത്തിന്റെ ഭാഗമാകുക. സംഭാഷണത്തിൽ ചേരൂ! മുറികൾ പര്യവേക്ഷണം ചെയ്യുക, സുഹൃത്തുക്കളുമായി ബന്ധപ്പെടുക, ലോകവുമായി നിങ്ങളുടെ ശബ്ദം പങ്കിടുക.';

  @override
  String get resonateFullDescription =>
      'റെസൊണേറ്റ് എല്ലാ ശബ്ദത്തിനും വിലയുള്ള ഒരു വിപ്ലവാത്മക ശബ്ദാധിഷ്ടിത സോഷ്യൽ മീഡിയ പ്ലാറ്റ്‌ഫോമാണ്\nതത്സമയ ഓഡിയോ സംഭാഷണങ്ങളിൽ പങ്കെടുക്കാനും വൈവിധ്യമാർന്ന ചർച്ചകളിൽ പങ്കാളികളാകാനും സമാന ചിന്താഗതിയുള്ള ആളുകളുമായി ബന്ധപ്പെടാനും നിങ്ങളെ സഹായിക്കുന്നു\nഞങ്ങളുടെ പ്ലാറ്റ്‌ഫോം വിഷയാധിഷ്ടിത ചർച്ചകളോടെയുള്ള ലൈവ് ഓഡിയോ റൂമുകൾ\nശബ്ദത്തിലൂടെ തടസ്സമില്ലാത്ത സോഷ്യൽ നെറ്റ്‌വർക്കിംഗ്\nസമൂഹം നയിക്കുന്ന ഉള്ളടക്ക നിയന്ത്രണം\nക്രോസ് പ്ലാറ്റ്‌ഫോം അനുയോജ്യത\nഎൻഡ് ടു എൻഡ് എൻക്രിപ്റ്റ് ചെയ്ത സ്വകാര്യ സംഭാഷണങ്ങൾ എന്നിവ നൽകുന്നു\n\nAOSSIE ഓപ്പൺ സോഴ്‌സ് കമ്മ്യൂണിറ്റി വികസിപ്പിച്ച ഈ പ്ലാറ്റ്‌ഫോമിൽ ഉപയോക്തൃ സ്വകാര്യതക്കും സമൂഹം നയിക്കുന്ന വികസനത്തിനും മുൻഗണന നൽകുകയും സാമൂഹിക ഓഡിയോയുടെ ഭാവി രൂപപ്പെടുത്തുന്നതിൽ ഞങ്ങളോടൊപ്പം ചേരാൻ നിങ്ങളെ ക്ഷണിക്കുകയും ചെയ്യുന്നു';

  @override
  String get stable => 'സ്റ്റേബിൾ';

  @override
  String get usernameCharacterLimit =>
      'ഉപയോക്തൃനാമത്തിൽ 7 പ്രതീകങ്ങളിൽ കൂടുതൽ ഉണ്ടായിരിക്കണം.';

  @override
  String get submit => 'സമർപ്പിക്കുക';

  @override
  String get anonymous => 'അജ്ഞാത';

  @override
  String get noSearchResults => 'തിരയൽ ഫലങ്ങളൊന്നും നൽകുന്നില്ല.';

  @override
  String get searchRooms => 'മുറികൾ തിരയുക...';

  @override
  String get searchingRooms => 'മുറികൾ തിരയുന്നു...';

  @override
  String get clearSearch => 'തിരയൽ മായ്ക്കുക';

  @override
  String get searchError => 'തിരയൽ തെറ്റി';

  @override
  String get searchRoomsError =>
      'മുറികൾ തിരയുന്നതിൽ പരാജയപ്പെട്ടു. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get searchUpcomingRoomsError =>
      'ഭാവിയിലെ മുറികൾ തിരയുന്നതിൽ പരാജയപ്പെട്ടു. ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get search => 'തിരയുക';

  @override
  String get clear => 'മായ്ക്കുക';

  @override
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  ) {
    return '🚀 ഈ അത്ഭുതകരമായ മുറി പരിശോധിക്കൂ: $roomName!\n\n📖 വിവരണം: $description\n👥 ഇപ്പോൾ തന്നെ $participants പങ്കാളികളിൽ ചേരൂ!';
  }

  @override
  String participantsCount(int count) {
    return '$count പങ്കാളികൾ';
  }

  @override
  String get join => 'ചേരുക';

  @override
  String get invalidTags => 'അസാധുവായ ടാഗ്:';

  @override
  String get cropImage => 'ചിത്രം മുറിക്കുക';

  @override
  String get profileSavedSuccessfully => 'പ്രൊഫൈൽ അപ്ഡേറ്റ് ചെയ്തു';

  @override
  String get profileUpdatedSuccessfully =>
      'എല്ലാ മാറ്റങ്ങളും വിജയകരമായി സേവ് ചെയ്തു.';

  @override
  String get profileUpToDate => 'പ്രൊഫൈൽ കാലികമാണ്';

  @override
  String get noChangesToSave =>
      'പുതിയ മാറ്റങ്ങളൊന്നും വരുത്തിയിട്ടില്ല, സേവ് ചെയ്യാൻ ഒന്നുമില്ല.';

  @override
  String get connectionFailed => 'കണക്ഷൻ പരാജയപ്പെട്ടു';

  @override
  String get unableToJoinRoom =>
      'റൂമിൽ ചേരാൻ കഴിഞ്ഞില്ല. നിങ്ങളുടെ നെറ്റ്‌വർക്ക് പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get connectionLost => 'കണക്ഷൻ നഷ്ടപ്പെട്ടു';

  @override
  String get unableToReconnect =>
      'റൂമിലേക്ക് വീണ്ടും കണക്റ്റ് ചെയ്യാൻ കഴിഞ്ഞില്ല. വീണ്ടും ചേരാൻ ശ്രമിക്കുക.';

  @override
  String get invalidFormat => 'അസാധുവായ ഫോർമാറ്റ്!';

  @override
  String get usernameAlphanumeric =>
      'ഉപയോക്തൃനാമം അക്ഷരങ്ങളും അക്കങ്ങളും അടങ്ങിയതായിരിക്കണം കൂടാതെ പ്രത്യേക പ്രതീകങ്ങൾ അടങ്ങിയിരിക്കരുത്.';

  @override
  String get userProfileCreatedSuccessfully =>
      'നിങ്ങളുടെ യൂസർ പ്രൊഫൈൽ വിജയകരമായി സൃഷ്ടിച്ചു.';

  @override
  String get emailVerificationMessage =>
      'മുന്നോട്ട് പോകാൻ, നിങ്ങളുടെ ഇമെയിൽ വെരിഫൈ ചെയ്യണം.';

  @override
  String addNewChaptersToStory(String storyName) {
    return '$storyName ലേക്ക് പുതിയ അദ്ധ്യായങ്ങൾ ചേർക്കുക';
  }

  @override
  String get currentChapters => 'നിലവിലുള്ള അദ്ധ്യായങ്ങൾ';

  @override
  String get sourceCodeOnGitHub => 'GitHub-ൽ സോഴ്സ് കോഡ് കാണുക';

  @override
  String get createAChapter => 'ഒരു അദ്ധ്യായം സൃഷ്ടിക്കുക';

  @override
  String get chapterTitle => 'അധ്യായത്തിന്റെ പേര് *';

  @override
  String get aboutRequired => 'വിവരണം *';

  @override
  String get changeCoverImage => 'കവർ ചിത്രം മാറ്റുക';

  @override
  String get uploadAudioFile => 'ഓഡിയോ ഫയൽ അപ്‌ലോഡ് ചെയ്യുക';

  @override
  String get uploadLyricsFile => 'ലിറിക്‌സ് ഫയൽ അപ്‌ലോഡ് ചെയ്യുക';

  @override
  String get createChapter => 'ചാപ്റ്റർ സൃഷ്ടിക്കുക';

  @override
  String audioFileSelected(String fileName) {
    return 'തിരഞ്ഞെടുത്ത ഓഡിയോ ഫയൽ: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'തിരഞ്ഞെടുത്ത ലിറിക്‌സ് ഫയൽ: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'ദയവായി എല്ലാ ആവശ്യമായ ഫീൽഡുകളും ഓഡിയോ ഫയലും ലിറിക്‌സ് ഫയലും അപ്‌ലോഡ് ചെയ്യുക';

  @override
  String get scheduled => 'നിശ്ചിതമാക്കിയിരിക്കുന്നു';

  @override
  String get ok => 'ശരി';

  @override
  String get roomDescriptionOptional => 'മുറി വിവരണം (ഓപ്ഷണൽ)';

  @override
  String get deleteAccount => 'അക്കൗണ്ട് ഇല്ലാതാക്കുക';

  @override
  String get createYourStory => 'നിങ്ങളുടെ കഥ സൃഷ്ടിക്കുക';

  @override
  String get titleRequired => 'ശീർഷകം *';

  @override
  String get category => 'വിഭാഗം *';

  @override
  String get addChapter => 'അധ്യായം ചേർക്കുക';

  @override
  String get createStory => 'കഥ സൃഷ്ടിക്കുക';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'ദയവായി എല്ലാ ആവശ്യമായ ഫീൽഡുകളും, കുറഞ്ഞത് ഒരു അധ്യായം ചേർക്കുക, ഒരു കവറിന്റെ ചിത്രം തിരഞ്ഞെടുക്കുക.';

  @override
  String get toConfirmType => 'സ്ഥിരീകരിക്കാൻ, ടൈപ്പ് ചെയ്യുക';

  @override
  String get inTheBoxBelow => 'താഴെ കൊടുത്ത ബോക്സിൽ';

  @override
  String get iUnderstandDeleteMyAccount =>
      'എനിക്ക് മനസ്സിലായി, എന്റെ അക്കൗണ്ട് ഇല്ലാതാക്കുക';

  @override
  String get whatDoYouWantToListenTo => 'നിങ്ങൾ എന്ത് കേൾക്കാൻ ആഗ്രഹിക്കുന്നു?';

  @override
  String get categories => 'വിഭാഗങ്ങൾ';

  @override
  String get stories => 'കഥകൾ';

  @override
  String get someSuggestions => 'ചില നിർദ്ദേശങ്ങൾ';

  @override
  String get getStarted => 'ആരംഭിക്കുക';

  @override
  String get skip => 'ഒഴിവാക്കുക';

  @override
  String get welcomeToResonate => 'റെസൊണേറ്റിലേക് സ്വാഗതം';

  @override
  String get exploreDiverseConversations => 'വിവിധ സംഭാഷണങ്ങൾ അന്വേഷിക്കുക';

  @override
  String get yourVoiceMatters => 'നിങ്ങളുടെ ശബ്ദം പ്രധാനമാണ്';

  @override
  String get joinConversationExploreRooms =>
      'സംഭാഷണത്തിൽ ചേരുക! റൂമുകൾ അന്വേഷിക്കുക, സുഹൃത്തുക്കളുമായി ബന്ധപ്പെടുക, ലോകത്തോട് നിങ്ങളുടെ ശബ്ദം പങ്കിടുക.';

  @override
  String get diveIntoDiverseDiscussions =>
      'വിവിധ ചർച്ചകളും വിഷയങ്ങളും ആഴത്തിൽ അന്വേഷിക്കുക. \nനിങ്ങളെ അനുഗ്രഹിക്കുന്ന റൂമുകൾ കണ്ടെത്തി, സമൂഹത്തിന്റെ ഭാഗമാകൂ.';

  @override
  String get atResonateEveryVoiceValued =>
      'റെസണേറ്റിൽ, ഓരോ ശബ്ദത്തിനും വിലയുണ്ട്. നിങ്ങളുടെ ചിന്തകൾ, കഥകൾ, അനുഭവങ്ങൾ എന്നിവ മറ്റുള്ളവരുമായി പങ്കിടുക. നിങ്ങളുടെ ഓഡിയോ യാത്ര ഇപ്പോൾ ആരംഭിക്കൂ.';

  @override
  String get notifications => 'അറിയിപ്പുകൾ';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username നിങ്ങളെ വരാനിരിക്കുന്ന ഒരു റൂമിൽ ടാഗ് ചെയ്തു: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username നിങ്ങളെ ഒരു റൂമിൽ ടാഗ് ചെയ്തു: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username നിങ്ങളുടെ കഥയെ ഇഷ്ടപ്പെട്ടു: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username നിങ്ങളുടെ റൂമിൽ സബ്സ്ക്രൈബ് ചെയ്തു: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username നിങ്ങളെ ഫോളോ ചെയ്യാൻ തുടങ്ങി';
  }

  @override
  String get youHaveNewNotification => 'നിങ്ങൾക്ക് ഒരു പുതിയ അറിയിപ്പ് ഉണ്ട്';

  @override
  String get hangOnGoodThingsTakeTime =>
      'കാത്തിരിക്കുക, നല്ല കാര്യങ്ങൾക്ക് സമയം വേണം 🔍';

  @override
  String get resonateOpenSourceProject =>
      'AOSSIE പരിപാലിക്കുന്ന ഒരു ഓപ്പൺ സോഴ്‌സ് പ്രോജക്റ്റാണ് റെസൊണേറ്റ്. സംഭാവന ചെയ്യാൻ ഞങ്ങളുടെ ഗിത്തബ് പരിശോധിക്കുക.';

  @override
  String get mute => 'മ്യൂട്ട്';

  @override
  String get speakerLabel => 'സ്പീക്കർ';

  @override
  String get audioOptions => 'ഓഡിയോ ഓപ്ഷനുകൾ';

  @override
  String get end => 'അവസാനിപ്പിക്കുക';

  @override
  String get saveChanges => 'മാറ്റങ്ങൾ സംരക്ഷിക്കുക';

  @override
  String get discard => 'മാറ്റങ്ങൾ ഉപേക്ഷിക്കുക';

  @override
  String get save => 'സേവ്';

  @override
  String get changeProfilePicture => 'പ്രൊഫൈൽ ചിത്രം മാറ്റുക';

  @override
  String get camera => 'ക്യാമറ';

  @override
  String get gallery => 'ഗാലറി';

  @override
  String get remove => 'കളയുക';

  @override
  String created(String date) {
    return 'സൃഷ്ടിച്ചത് $date';
  }

  @override
  String get chapters => 'അധ്യായങ്ങൾ';

  @override
  String get deleteStory => 'കഥ ഇല്ലാതാക്കുക';

  @override
  String createdBy(String creatorName) {
    return 'സൃഷ്ടിച്ചത് $creatorName';
  }

  @override
  String get start => 'ആരംഭിക്കുക';

  @override
  String get unsubscribe => 'അൺസബ്‌സ്‌ക്രൈബ്';

  @override
  String get subscribe => 'സബ്‌സ്‌ക്രൈബ്';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'ഡ്രാമ',
      'comedy': 'കോമഡി',
      'horror': 'ഹൊറർ',
      'romance': 'റൊമാൻസ്',
      'thriller': 'ത്രില്ലർ',
      'spiritual': 'ആത്മീയ',
      'other': 'മറ്റുള്ളവ',
    });
    return '$_temp0';
  }

  @override
  String chooseTheme(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'classicTheme': 'ക്ലാസിക്',
      'timeTheme': 'ടൈം',
      'vintageTheme': 'വിന്റേജ്',
      'amberTheme': 'ആംബർ',
      'forestTheme': 'ഫോറസ്റ്റ്',
      'creamTheme': 'ക്രീം',
      'other': 'മറ്റുള്ളവ',
    });
    return '$_temp0';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count മിനിറ്റ് മുമ്പ്',
      one: '1 മിനിറ്റ് മുമ്പ്',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count മണിക്കൂർ മുമ്പ്',
      one: '1 മണിക്കൂർ മുമ്പ്',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ദിവസം മുമ്പ്',
      one: '1 ദിവസം മുമ്പ്',
    );
    return '$_temp0';
  }

  @override
  String get by => 'രചിച്ചത്:';

  @override
  String get likes => 'ലൈക്കുകൾ';

  @override
  String get lengthMinutes => 'മിനിറ്റ്';

  @override
  String get requiredField => 'ആവശ്യമായ ഫീൽഡ്';

  @override
  String get onlineUsers => 'ഓൺലൈൻ ഉപയോക്താക്കൾ';

  @override
  String get noOnlineUsers => 'നിലവിൽ ഓൺലൈനിൽ ഉപയോക്താക്കൾ ആരുമില്ല';

  @override
  String get chooseUser => 'ചാറ്റ് ചെയ്യാൻ ഉപയോക്താവിനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get quickMatch => 'പെട്ടെന്ന് മാച്ച് ചെയ്യുക';

  @override
  String get story => 'കഥ';

  @override
  String get user => 'ഉപയോക്താവ്';

  @override
  String get following => 'ഫോളോ ചെയ്യുന്നു';

  @override
  String get followers => 'ഫോളോവേഴ്സ്';

  @override
  String get friendRequests => 'സുഹൃത്ത് അഭ്യർത്ഥനകൾ';

  @override
  String get friendRequestSent => 'സുഹൃത്ത് അഭ്യർത്ഥന അയച്ചു';

  @override
  String friendRequestSentTo(String username) {
    return '$username ലേക്ക് നിങ്ങളുടെ സുഹൃത്ത് അഭ്യർത്ഥന അയച്ചു.';
  }

  @override
  String get friendRequestCancelled => 'സുഹൃത്ത് അഭ്യർത്ഥന റദ്ദാക്കി';

  @override
  String friendRequestCancelledTo(String username) {
    return '$username ലേക്കുള്ള നിങ്ങളുടെ സുഹൃത്ത് അഭ്യർത്ഥന റദ്ദാക്കി.';
  }

  @override
  String get requested => 'അഭ്യർത്ഥിച്ചു';

  @override
  String get friends => 'സുഹൃത്തുക്കൾ';

  @override
  String get addFriend => 'സുഹൃത്തിനെ ചേർക്കുക';

  @override
  String get friendRequestAccepted => 'സുഹൃത്ത് അഭ്യർത്ഥന സ്വീകരിച്ചു';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'നിങ്ങൾ $username ന്റെ സുഹൃത്ത് അഭ്യർത്ഥന സ്വീകരിച്ചു.';
  }

  @override
  String get friendRequestDeclined => 'സുഹൃത്ത് അഭ്യർത്ഥന നിരാകരിച്ചു';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'നിങ്ങൾ $username ന്റെ സുഹൃത്ത് അഭ്യർത്ഥന നിരാകരിച്ചു.';
  }

  @override
  String get accept => 'സ്വീകരിക്കുക';

  @override
  String get callDeclined => 'കോൾ നിരാകരിച്ചു';

  @override
  String callDeclinedTo(String username) {
    return '$username കോൾ നിരാകരിച്ചു.';
  }

  @override
  String get checkForUpdates => 'അപ്‌ഡേറ്റ് പരിശോധിക്കുക';

  @override
  String get updateNow => 'ഇപ്പോൾ അപ്‌ഡേറ്റ് ചെയ്യുക';

  @override
  String get updateLater => 'പിന്നീട്';

  @override
  String get updateSuccessful => 'അപ്‌ഡേറ്റ് വിജയിച്ചു';

  @override
  String get updateSuccessfulMessage =>
      'റെസൊണേറ്റ് വിജയകരമായി അപ്‌ഡേറ്റ് ചെയ്തു!';

  @override
  String get updateCancelled => 'അപ്‌ഡേറ്റ് റദ്ദാക്കി';

  @override
  String get updateCancelledMessage => 'ഉപയോക്താവ് അപ്‌ഡേറ്റ് റദ്ദാക്കി';

  @override
  String get updateFailed => 'അപ്‌ഡേറ്റ് പരാജയപ്പെട്ടു';

  @override
  String get updateFailedMessage =>
      'അപ്‌ഡേറ്റ് ചെയ്യാൻ പരാജയപ്പെട്ടു. Play Store-ൽ നിന്ന് സ്വമേധയാ അപ്‌ഡേറ്റ് ചെയ്യാൻ ശ്രമിക്കുക.';

  @override
  String get updateError => 'അപ്‌ഡേറ്റ് തെറ്റി';

  @override
  String get updateErrorMessage =>
      'അപ്‌ഡേറ്റ് ചെയ്യുമ്പോൾ ഒരു തെറ്റ് സംഭവിച്ചു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get platformNotSupported => 'പ്ലാറ്റ്‌ഫോം പിന്തുണയ്ക്കുന്നില്ല';

  @override
  String get platformNotSupportedMessage =>
      'അപ്‌ഡേറ്റ് പരിശോധിക്കൽ Android ഉപകരണങ്ങളിൽ മാത്രം ലഭ്യമാണ്';

  @override
  String get updateCheckFailed => 'അപ്‌ഡേറ്റ് പരിശോധന പരാജയപ്പെട്ടു';

  @override
  String get updateCheckFailedMessage =>
      'അപ്‌ഡേറ്റുകൾ പരിശോധിക്കാനായില്ല. പിന്നീട് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get upToDateTitle => 'നിങ്ങൾ അപ്-റ്റു-ഡേറ്റ് ആണ്!';

  @override
  String get upToDateMessage =>
      'നിങ്ങൾ റെസൊണേറ്റിന്റെ ഏറ്റവും പുതിയ പതിപ്പ് ഉപയോഗിക്കുന്നു';

  @override
  String get updateAvailableTitle => 'അപ്‌ഡേറ്റ് ലഭ്യമാണ്!';

  @override
  String get updateAvailableMessage =>
      'റെസൊണേറ്റിന്റെ പുതിയ പതിപ്പ് Play Store-ൽ ലഭ്യമാണ്';

  @override
  String get updateFeaturesImprovement =>
      'ഏറ്റവും പുതിയ സവിശേഷതകളും മെച്ചപ്പെടുത്തലുകളും നേടുക!';

  @override
  String get failedToRemoveRoom => 'മുറി നീക്കം ചെയ്യുന്നതിൽ പരാജയപ്പെട്ടു';

  @override
  String get roomRemovedSuccessfully =>
      'മുറി നിങ്ങളുടെ ലിസ്റ്റിൽ നിന്ന് വിജയകരമായി നീക്കം ചെയ്തു';

  @override
  String get alert => 'മുന്നറിയിപ്പ്';

  @override
  String get removedFromRoom =>
      'നിങ്ങളെ റിപ്പോർട്ട് ചെയ്തിരിക്കുന്നു അല്ലെങ്കിൽ മുറിയിൽ നിന്ന് നീക്കം ചെയ്തു';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'പീഡനം / വിദ്വേഷപൂർണ്ണമായ സംസാരം',
      'abuse': 'ദുരുപയോഗ ഉള്ളടക്കം / അക്രമം',
      'spam': 'സ്പാം / തട്ടിപ്പ്',
      'impersonation': 'വ്യാജ അക്കൗണ്ടുകൾ',
      'illegal': 'നിയമവിരുദ്ധ പ്രവർത്തനങ്ങൾ',
      'selfharm': 'സ്വയം-ഉപദ്രവം / ആത്മഹത്യ / മാനസികാരോഗ്യം',
      'misuse': 'പ്ലാറ്റ്‌ഫോമിന്റെ ദുരുപയോഗം',
      'other': 'മറ്റുള്ളവ',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate =>
      'നിങ്ങളെ ഒന്നിലധികം ഉപയോക്താക്കൾ റിപ്പോർട്ട് ചെയ്തിട്ടുണ്ട്, നിങ്ങളെ റെസൊണേറ്റ് ഉപയോഗിക്കുന്നതിൽ നിന്ന് തടഞ്ഞിരിക്കുന്നു. ഇത് തെറ്റാണെന്ന് നിങ്ങൾ വിശ്വസിക്കുന്നുവെങ്കിൽ ദയവായി AOSSIE-യെ ബന്ധപ്പെടുക.';

  @override
  String get reportParticipant => 'പങ്കാളിയെ റിപ്പോർട്ട് ചെയ്യുക';

  @override
  String get selectReportType => 'റിപ്പോർട്ടിന്റെ തരം തിരഞ്ഞെടുക്കുക';

  @override
  String get reportSubmitted => 'റിപ്പോർട്ട് വിജയകരമായി സമർപ്പിച്ചു';

  @override
  String get reportFailed => 'റിപ്പോർട്ട് സമർപ്പണം പരാജയപ്പെട്ടു';

  @override
  String get additionalDetailsOptional => 'അധിക വിശദാംശങ്ങൾ (ഓപ്ഷണൽ)';

  @override
  String get submitReport => 'റിപ്പോർട്ട് സമർപ്പിക്കുക';

  @override
  String get actionBlocked => 'പ്രവർത്തനം തടഞ്ഞു';

  @override
  String get cannotStopRecording =>
      'നിങ്ങൾക്ക് റെക്കോർഡിംഗ് സ്വമേധയാ നിർത്താൻ കഴിയില്ല, മുറി അടയ്ക്കുമ്പോൾ റെക്കോർഡിംഗ് നിർത്തപ്പെടും.';

  @override
  String get liveChapter => 'ലൈവ് അധ്യായം';

  @override
  String get viewOrEditLyrics => 'വരികൾ കാണുക അല്ലെങ്കിൽ എഡിറ്റ് ചെയ്യുക';

  @override
  String get close => 'അടയ്ക്കുക';

  @override
  String get verifyChapterDetails => 'അധ്യായ വിശദാംശങ്ങൾ സ്ഥിരീകരിക്കുക';

  @override
  String get author => 'രചയിതാവ്';

  @override
  String get startLiveChapter => 'ലൈവ് അധ്യായം ആരംഭിക്കുക';

  @override
  String get fillAllFields => 'ദയവായി എല്ലാ ആവശ്യമായ ഫീൽഡുകളും പൂരിപ്പിക്കുക';

  @override
  String get noRecordingError =>
      'നിങ്ങൾ അധ്യായത്തിന് ഒന്നും റെക്കോർഡ് ചെയ്തിട്ടില്ല. മുറി വിടുന്നതിന് മുമ്പ് ഒരു അധ്യായം റെക്കോർഡ് ചെയ്യുക';

  @override
  String get audioOutput => 'ഓഡിയോ ഔട്ട്‌പുട്ട്';

  @override
  String get selectPreferredSpeaker =>
      'നിങ്ങളുടെ ഇഷ്ടമുള്ള സ്പീക്കർ തിരഞ്ഞെടുക്കുക';

  @override
  String get noAudioOutputDevices =>
      'ഓഡിയോ ഔട്ട്‌പുട്ട് ഉപകരണങ്ങളൊന്നും കണ്ടെത്തിയില്ല';

  @override
  String get refresh => 'പുതുക്കുക';

  @override
  String get done => 'പൂർത്തിയായി';

  @override
  String get deleteMessageTitle => 'സന്ദേശം ഇല്ലാതാക്കുക';

  @override
  String get deleteMessageContent =>
      'നിങ്ങൾക്ക് ഈ സന്ദേശം ഇല്ലാതാക്കണമെന്ന് ഉറപ്പാണോ?';

  @override
  String get thisMessageWasDeleted => 'ഈ സന്ദേശം ഇല്ലാതാക്കി';

  @override
  String get failedToDeleteMessage => 'സന്ദേശം ഇല്ലാതാക്കുന്നതിൽ പരാജയപ്പെട്ടു';

  @override
  String get usernameInvalidFormat =>
      'ദയവായി സാധുവായ ഉപയോക്തൃനാമം നൽകുക. അക്ഷരങ്ങൾ, അക്കങ്ങൾ, ഡോട്ടുകൾ, അണ്ടർസ്കോറുകൾ, ഹൈഫനുകൾ എന്നിവ മാത്രമേ അനുവദിക്കൂ.';

  @override
  String get usernameAlreadyTaken =>
      'ഈ ഉപയോക്തൃനാമം ഇതിനകം എടുത്തിട്ടുണ്ട്. മറ്റൊന്ന് ശ്രമിക്കുക.';
}
