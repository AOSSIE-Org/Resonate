// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get title => 'રેઝોનેટ';

  @override
  String get roomDescription =>
      'નમ્ર બનો અને અન્ય વ્યક્તિના અભિપ્રાયનો આદર કરો. અસભ્ય ટિપ્પણીઓ ટાળો.';

  @override
  String get hidePassword => 'પાસવર્ડ છુપાવો';

  @override
  String get showPassword => 'પાસવર્ડ બતાવો';

  @override
  String get passwordEmpty => 'પાસવર્ડ ખાલી હોઈ શકે નહીં';

  @override
  String get password => 'પાસવર્ડ';

  @override
  String get confirmPassword => 'પાસવર્ડની પુષ્ટિ કરો';

  @override
  String get passwordsNotMatch => 'પાસવર્ડ મેળ ખાતા નથી';

  @override
  String get userCreatedStories => 'યુઝર દ્વારા બનાવેલી વાર્તાઓ';

  @override
  String get yourStories => 'તમારી વાર્તાઓ';

  @override
  String get userNoStories => 'યુઝરે કોઈ વાર્તા બનાવી નથી';

  @override
  String get youNoStories => 'તમે કોઈ વાર્તા બનાવી નથી';

  @override
  String get follow => 'ફોલો કરો';

  @override
  String get editProfile => 'પ્રોફાઈલ એડિટ કરો';

  @override
  String get verifyEmail => 'ઈમેઈલ ચકાસો';

  @override
  String get verified => 'ચકાસાયેલ';

  @override
  String get profile => 'પ્રોફાઈલ';

  @override
  String get userLikedStories => 'યુઝરે પસંદ કરેલી વાર્તાઓ';

  @override
  String get yourLikedStories => 'તમારી પસંદ કરેલી વાર્તાઓ';

  @override
  String get userNoLikedStories => 'યુઝરે કોઈ વાર્તા પસંદ કરી નથી';

  @override
  String get youNoLikedStories => 'તમે કોઈ વાર્તા પસંદ કરી નથી';

  @override
  String get live => 'લાઈવ';

  @override
  String get upcoming => 'આગામી';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'કોઈ રૂમ ઉપલબ્ધ નથી',
      'false': 'કોઈ આગામી રૂમ ઉપલબ્ધ નથી',
      'other': 'કોઈ રૂમ માહિતી ઉપલબ્ધ નથી',
    });
    return '$_temp0\nનીચે એક ઉમેરીને શરૂઆત કરો!';
  }

  @override
  String get user1 => 'યુઝર 1';

  @override
  String get user2 => 'યુઝર 2';

  @override
  String get you => 'તમે';

  @override
  String get areYouSure => 'તમને ખાતરી છે?';

  @override
  String get loggingOut => 'તમે રેઝોનેટમાંથી લોગ આઉટ કરી રહ્યા છો.';

  @override
  String get yes => 'હા';

  @override
  String get no => 'ના';

  @override
  String get incorrectEmailOrPassword => 'ખોટું ઈમેઈલ અથવા પાસવર્ડ';

  @override
  String get passwordShort => 'પાસવર્ડ 8 અક્ષરથી ઓછો છે';

  @override
  String get tryAgain => 'ફરી પ્રયાસ કરો!';

  @override
  String get success => 'સફળતા';

  @override
  String get passwordResetSent => 'પાસવર્ડ રીસેટ ઈમેઈલ મોકલાયો!';

  @override
  String get error => 'ભૂલ';

  @override
  String get resetPassword => 'પાસવર્ડ રીસેટ કરો';

  @override
  String get enterNewPassword => 'તમારો નવો પાસવર્ડ દાખલ કરો';

  @override
  String get newPassword => 'નવો પાસવર્ડ';

  @override
  String get setNewPassword => 'નવો પાસવર્ડ સેટ કરો';

  @override
  String get emailChanged => 'ઈમેઈલ બદલાયો';

  @override
  String get emailChangeSuccess => 'ઈમેઈલ સફળતાપૂર્વક બદલાયો!';

  @override
  String get failed => 'અસફળ';

  @override
  String get emailChangeFailed => 'ઈમેઈલ બદલવામાં અસફળ';

  @override
  String get oops => 'અરે!';

  @override
  String get emailExists => 'ઈમેઈલ પહેલાથી અસ્તિત્વમાં છે';

  @override
  String get changeEmail => 'ઈમેઈલ બદલો';

  @override
  String get enterValidEmail => 'કૃપા કરીને માન્ય ઈમેઈલ એડ્રેસ દાખલ કરો';

  @override
  String get newEmail => 'નવો ઈમેઈલ';

  @override
  String get currentPassword => 'હાલનો પાસવર્ડ';

  @override
  String get emailChangeInfo =>
      'વધારાની સુરક્ષા માટે, તમારું ઈમેઈલ એડ્રેસ બદલતી વખતે તમારે તમારા એકાઉન્ટનો હાલનો પાસવર્ડ આપવો આવશ્યક છે. ઈમેઈલ બદલ્યા પછી, ભવિષ્યના લોગિન માટે અપડેટ થયેલ ઈમેઈલનો ઉપયોગ કરો.';

  @override
  String get oauthUsersMessage =>
      '(ફક્ત તે યુઝર્સ માટે જેઓ ગૂગલ અથવા ગિટહબ વાપરીને લોગ ઇન થયા છે)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'તમારો ઈમેઈલ બદલવા માટે, કૃપા કરીને \"હાલનો પાસવર્ડ\" ફીલ્ડમાં નવો પાસવર્ડ દાખલ કરો. આ પાસવર્ડ યાદ રાખવાનું સુનિશ્ચિત કરો, કારણ કે ભવિષ્યમાં ઈમેઈલ બદલવા માટે તમને તેની જરૂર પડશે. આગળ જતા, તમે ગૂગલ/ગિટહબ અથવા તમારા નવા ઈમેઈલ અને પાસવર્ડના સંયોજનનો ઉપયોગ કરીને લોગ ઇન કરી શકો છો.';

  @override
  String get resonateTagline => 'અમર્યાદિત વાર્તાલાપની\nદુનિયામાં પ્રવેશ કરો.';

  @override
  String get signInWithEmail => 'ઈમેઈલ સાથે સાઈન ઇન કરો';

  @override
  String get or => 'અથવા';

  @override
  String get continueWith => 'સાથે ચાલુ રાખો';

  @override
  String get continueWithGoogle => 'ગૂગલ સાથે ચાલુ રાખો';

  @override
  String get continueWithGitHub => 'ગિટહબ સાથે ચાલુ રાખો';

  @override
  String get resonateLogo => 'રેઝોનેટ લોગો';

  @override
  String get iAlreadyHaveAnAccount => 'મારી પાસે પહેલાથી એકાઉન્ટ છે';

  @override
  String get createNewAccount => 'નવો એકાઉન્ટ બનાવો';

  @override
  String get userProfile => 'યુઝર પ્રોફાઈલ';

  @override
  String get passwordIsStrong => 'પાસવર્ડ મજબૂત છે';

  @override
  String get admin => 'એડમિન';

  @override
  String get moderator => 'મોડરેટર';

  @override
  String get speaker => 'સ્પીકર';

  @override
  String get listener => 'સાંભળનાર';

  @override
  String get removeModerator => 'મોડરેટર દૂર કરો';

  @override
  String get kickOut => 'બહાર કાઢો';

  @override
  String get addModerator => 'મોડરેટર ઉમેરો';

  @override
  String get addSpeaker => 'સ્પીકર ઉમેરો';

  @override
  String get makeListener => 'સાંભળનાર બનાવો';

  @override
  String get pairChat => 'જોડી ચેટ';

  @override
  String get chooseIdentity => 'ઓળખ પસંદ કરો';

  @override
  String get selectLanguage => 'ભાષા પસંદ કરો';

  @override
  String get noConnection => 'કોઈ કનેક્શન નથી';

  @override
  String get loadingDialog => 'ડાયલોગ લોડ થઈ રહ્યો છે';

  @override
  String get createAccount => 'એકાઉન્ટ બનાવો';

  @override
  String get enterValidEmailAddress => 'માન્ય ઈમેઈલ એડ્રેસ દાખલ કરો';

  @override
  String get email => 'ઈમેઈલ';

  @override
  String get passwordRequirements => 'પાસવર્ડ ઓછામાં ઓછો 8 અક્ષરનો હોવો જોઈએ';

  @override
  String get includeNumericDigit => 'ઓછામાં ઓછો 1 સંખ્યાત્મક અંક શામેલ કરો';

  @override
  String get includeUppercase => 'ઓછામાં ઓછો 1 મોટો અક્ષર શામેલ કરો';

  @override
  String get includeLowercase => 'ઓછામાં ઓછો 1 નાનો અક્ષર શામેલ કરો';

  @override
  String get includeSymbol => 'ઓછામાં ઓછો 1 પ્રતીક શામેલ કરો';

  @override
  String get signedUpSuccessfully => 'સફળતાપૂર્વક સાઈન અપ થયું';

  @override
  String get newAccountCreated => 'તમે સફળતાપૂર્વક નવો એકાઉન્ટ બનાવ્યો છે';

  @override
  String get signUp => 'સાઈન અપ';

  @override
  String get login => 'લોગિન';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get accountSettings => 'એકાઉન્ટ સેટિંગ્સ';

  @override
  String get account => 'એકાઉન્ટ';

  @override
  String get appSettings => 'એપ સેટિંગ્સ';

  @override
  String get themes => 'થીમ';

  @override
  String get about => 'વિશે';

  @override
  String get other => 'અન્ય';

  @override
  String get contribute => 'યોગદાન આપો';

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
  String get logOut => 'લોગ આઉટ';

  @override
  String get participants => 'સહભાગીઓ';

  @override
  String get delete => 'ડિલીટ કરો';

  @override
  String get leave => 'છોડો';

  @override
  String get leaveButton => 'છોડો';

  @override
  String get findingRandomPartner => 'તમારા માટે રેન્ડમ પાર્ટનર શોધી રહ્યા છીએ';

  @override
  String get quickFact => 'ત્વરિત હકીકત';

  @override
  String get cancel => 'રદ કરો';

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
  String get completeYourProfile => 'તમારી પ્રોફાઈલ પૂર્ણ કરો';

  @override
  String get uploadProfilePicture => 'પ્રોફાઈલ પિક્ચર અપલોડ કરો';

  @override
  String get enterValidName => 'માન્ય નામ દાખલ કરો';

  @override
  String get name => 'નામ';

  @override
  String get username => 'યુઝરનેમ';

  @override
  String get enterValidDOB => 'માન્ય જન્મતારીખ દાખલ કરો';

  @override
  String get dateOfBirth => 'જન્મતારીખ';

  @override
  String get forgotPassword => 'પાસવર્ડ ભૂલી ગયા?';

  @override
  String get next => 'આગળ';

  @override
  String get noStoriesExist => 'રજૂ કરવા માટે કોઈ વાર્તાઓ અસ્તિત્વમાં નથી';

  @override
  String get enterVerificationCode => 'તમારો\nવેરિફિકેશન કોડ દાખલ કરો';

  @override
  String get verificationCodeSent => 'અમે 6-અંકનો વેરિફિકેશન કોડ મોકલ્યો છે\n';

  @override
  String get verificationComplete => 'વેરિફિકેશન પૂર્ણ';

  @override
  String get verificationCompleteMessage =>
      'અભિનંદન તમે તમારું ઈમેઈલ વેરિફાય કર્યું છે';

  @override
  String get verificationFailed => 'વેરિફિકેશન અસફળ';

  @override
  String get otpMismatch => 'OTP મેળ ખાતું નથી, કૃપા કરીને ફરી પ્રયાસ કરો';

  @override
  String get otpResent => 'OTP ફરી મોકલાયો';

  @override
  String get requestNewCode => 'નવો કોડ મંગાવો';

  @override
  String get requestNewCodeIn => 'આટલા સમયમાં નવો કોડ મંગાવો';

  @override
  String get clickPictureCamera => 'કૅમેરા વાપરીને ફોટો લો';

  @override
  String get pickImageGallery => 'ગૅલેરીમાંથી ઈમેજ પસંદ કરો';

  @override
  String get deleteMyAccount => 'મારો એકાઉન્ટ ડિલીટ કરો';

  @override
  String get createNewRoom => 'નવો રૂમ બનાવો';

  @override
  String get pleaseEnterScheduledDateTime =>
      'કૃપા કરીને નિર્ધારિત તારીખ-સમય દાખલ કરો';

  @override
  String get scheduleDateTimeLabel => 'તારીખ સમય શેડ્યૂલ કરો';

  @override
  String get enterTags => 'ટૅગ્સ દાખલ કરો';

  @override
  String get joinCommunity => 'કોમ્યુનિટીમાં જોડાવો';

  @override
  String get followUsOnX => 'X પર અમને ફોલો કરો';

  @override
  String get joinDiscordServer => 'ડિસ્કોર્ડ સર્વરમાં જોડાવો';

  @override
  String get noLyrics => 'કોઈ ગીત નથી';

  @override
  String noStoriesInCategory(String categoryName) {
    return '$categoryName કેટેગરીમાં હાલમાં રજૂ કરવા માટે કોઈ વાર્તાઓ અસ્તિત્વમાં નથી';
  }

  @override
  String get newChapters => 'નવા ચેપ્ટર્સ';

  @override
  String get helpToGrow => 'વધવામાં મદદ કરો';

  @override
  String get share => 'શેર કરો';

  @override
  String get rate => 'રેટિંગ આપો';

  @override
  String get aboutResonate => 'રેઝોનેટ વિશે';

  @override
  String get description => 'વર્ણન';

  @override
  String get confirm => 'પુષ્ટિ કરો';

  @override
  String get classic => 'ક્લાસિક';

  @override
  String get time => 'સમય';

  @override
  String get vintage => 'વિન્ટેજ';

  @override
  String get amber => 'એમ્બર';

  @override
  String get forest => 'ફોરેસ્ટ';

  @override
  String get cream => 'ક્રીમ';

  @override
  String get none => 'કંઈ નથી';

  @override
  String checkOutGitHub(String url) {
    return 'અમારી ગિટહબ રિપોઝિટરી જુઓ: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'aossie લોગો';

  @override
  String get errorLoadPackageInfo => 'પૅકેજ માહિતી લોડ કરી શકાઈ નથી';

  @override
  String get searchFailed => 'Failed to search rooms. Please try again.';

  @override
  String get updateAvailable => 'અપડેટ ઉપલબ્ધ છે';

  @override
  String get newVersionAvailable => 'નવું વર્ઝન ઉપલબ્ધ છે!';

  @override
  String get upToDate => 'અપ ટુ ડેટ';

  @override
  String get latestVersion => 'તમે લેટેસ્ટ વર્ઝન વાપરી રહ્યા છો';

  @override
  String get profileCreatedSuccessfully => 'પ્રોફાઈલ સફળતાપૂર્વક બન્યું';

  @override
  String get invalidScheduledDateTime => 'અમાન્ય શેડ્યૂલ્ડ તારીખ સમય';

  @override
  String get scheduledDateTimePast =>
      'શેડ્યૂલ્ડ તારીખ સમય ભૂતકાળમાં હોઈ શકે નહીં';

  @override
  String get joinRoom => 'રૂમમાં જોડાવો';

  @override
  String get unknownUser => 'અજાણ્યો';

  @override
  String get canceled => 'રદ કર્યું';

  @override
  String get english => 'gu';

  @override
  String get emailVerificationRequired => 'ઈમેઈલ વેરિફિકેશન જરૂરી';

  @override
  String get verify => 'વેરિફાય કરો';

  @override
  String get audioRoom => 'ઓડિયો રૂમ';

  @override
  String toRoomAction(String action) {
    return 'રૂમને $action કરવા માટે';
  }

  @override
  String get mailSentMessage => 'મેઈલ મોકલાયો';

  @override
  String get disconnected => 'ડિસ્કનેક્ટ થયું';

  @override
  String get micOn => 'માઈક';

  @override
  String get speakerOn => 'સ્પીકર';

  @override
  String get endChat => 'ચેટ સમાપ્ત કરો';

  @override
  String get monthJan => 'જાન્યુ';

  @override
  String get monthFeb => 'ફેબ્રુ';

  @override
  String get monthMar => 'માર્ચ';

  @override
  String get monthApr => 'એપ્રિલ';

  @override
  String get monthMay => 'મે';

  @override
  String get monthJun => 'જૂન';

  @override
  String get monthJul => 'જુલાઈ';

  @override
  String get monthAug => 'ઓગ';

  @override
  String get monthSep => 'સપ્ટે';

  @override
  String get monthOct => 'ઓક્ટો';

  @override
  String get monthNov => 'નવે';

  @override
  String get monthDec => 'ડિસે';

  @override
  String get register => 'રજિસ્ટર';

  @override
  String get newToResonate => 'રેઝોનેટ પર નવા છો? ';

  @override
  String get alreadyHaveAccount => 'પહેલાથી એકાઉન્ટ છે? ';

  @override
  String get checking => 'તપાસી રહ્યા છીએ...';

  @override
  String get forgotPasswordMessage =>
      'તમારો પાસવર્ડ રીસેટ કરવા માટે તમારો રજિસ્ટર્ડ ઈમેઈલ એડ્રેસ દાખલ કરો.';

  @override
  String get usernameUnavailable => 'યુઝરનેમ ઉપલબ્ધ નથી!';

  @override
  String get usernameInvalidOrTaken =>
      'આ યુઝરનેમ અમાન્ય છે અથવા પહેલાથી લેવાયેલ છે.';

  @override
  String get otpResentMessage => 'કૃપા કરીને નવો OTP માટે તમારો મેઈલ તપાસો.';

  @override
  String get connectionError =>
      'કનેક્શન એરર છે. કૃપા કરીને તમારું ઈન્ટરનેટ તપાસો અને ફરી પ્રયાસ કરો.';

  @override
  String get seconds => 'સેકંડ.';

  @override
  String get unsavedChangesWarning =>
      'જો તમે સેવ કર્યા વિના આગળ વધશો, તો કોઈપણ અનસેવ્ડ ફેરફારો ખોવાઈ જશે.';

  @override
  String get deleteAccountPermanent =>
      'આ ક્રિયા તમારો એકાઉન્ટ કાયમ માટે ડિલીટ કરશે. આ અપરિવર્તનીય પ્રક્રિયા છે. અમે તમારું યુઝરનેમ, ઈમેઈલ એડ્રેસ અને તમારા એકાઉન્ટ સાથે સંકળાયેલ બધો ડેટા ડિલીટ કરીશું. તમે તેને પુનઃપ્રાપ્ત કરી શકશો નહીં.';

  @override
  String get giveGreatName => 'એક સરસ નામ આપો..';

  @override
  String get joinCommunityDescription =>
      'કોમ્યુનિટીમાં જોડાઈને તમે તમારી શંકાઓ દૂર કરી શકો છો, નવી સુવિધાઓ માટે સૂચન આપી શકો છો, તમને આવેલી સમસ્યાઓની જાણ કરી શકો છો અને વધુ.';

  @override
  String get resonateDescription =>
      'રેઝોનેટ એક સોશિયલ મીડિયા પ્લેટફોર્મ છે, જ્યાં દરેક અવાજનું મૂલ્ય છે. અન્યો સાથે તમારા વિચારો, વાર્તાઓ અને અનુભવો શેર કરો. હવે જ તમારી ઓડિયો જર્ની શરૂ કરો. વિવિધ ચર્ચાઓ અને વિષયોમાં ડૂબકી મારો. તમારી સાથે રેઝોનેટ કરતા રૂમ્સ શોધો અને કોમ્યુનિટીનો ભાગ બનો. વાર્તાલાપમાં જોડાવો! રૂમ્સ એક્સપ્લોર કરો, મિત્રો સાથે જોડાવો અને દુનિયા સાથે તમારો અવાજ શેર કરો.';

  @override
  String get resonateFullDescription =>
      'રેઝોનેટ એક ક્રાંતિકારી અવાજ-આધારિત સોશિયલ મીડિયા પ્લેટફોર્મ છે જ્યાં દરેક અવાજ મહત્વપૂર્ણ છે. \nરિયલ-ટાઈમ ઓડિયો વાર્તાલાપમાં જોડાવો, વિવિધ ચર્ચાઓમાં ભાગ લો અને \nસમાન વિચારધારા ધરાવતા લોકો સાથે જોડાવો. અમારું પ્લેટફોર્મ આ ઓફર કરે છે:\n- વિષય-આધારિત ચર્ચાઓ સાથે લાઈવ ઓડિયો રૂમ્સ\n- અવાજ દ્વારા સરળ સોશિયલ નેટવર્કિંગ\n- કોમ્યુનિટી-સંચાલિત કન્ટેન્ટ મોડરેશન\n- ક્રોસ-પ્લેટફોર્મ કેમ્પેટિબિલિટી\n- એન્ડ-ટુ-એન્ડ એન્ક્રિપ્ટેડ પ્રાઈવેટ વાર્તાલાપ\n\nAOSSIE ઓપન સોર્સ કોમ્યુનિટી દ્વારા વિકસાવેલ, અમે યુઝર પ્રાઈવસી અને \nકોમ્યુનિટી-સંચાલિત વિકાસને પ્રાથમિકતા આપીએ છીએ. સોશિયલ ઓડિયોના ભવિષ્યને આકાર આપવામાં અમારી સાથે જોડાવો!';

  @override
  String get stable => 'સ્થિર';

  @override
  String get usernameCharacterLimit => 'યુઝરનેમમાં 5 થી વધુ અક્ષરો હોવા જોઈએ.';

  @override
  String get submit => 'સબમિટ કરો';

  @override
  String get anonymous => 'અજ્ઞાત';

  @override
  String get noSearchResults => 'કોઈ શોધ પરિણામો નથી';

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
    return '🚀 આ અદ્ભુત રૂમ જુઓ: $roomName!\n\n📖 વર્ણન: $description\n👥 હવે જ $participants સહભાગીઓ સાથે જોડાવો!';
  }

  @override
  String participantsCount(int count) {
    return '$count સહભાગીઓ';
  }

  @override
  String get join => 'જોડાવો';

  @override
  String get invalidTags => 'અમાન્ય ટૅગ:';

  @override
  String get cropImage => 'ઈમેજ ક્રોપ કરો';

  @override
  String get profileSavedSuccessfully => 'પ્રોફાઈલ અપડેટ થયું';

  @override
  String get profileUpdatedSuccessfully => 'બધા ફેરફારો સફળતાપૂર્વક સેવ થયા.';

  @override
  String get profileUpToDate => 'પ્રોફાઈલ અપ ટુ ડેટ';

  @override
  String get noChangesToSave =>
      'કોઈ નવા ફેરફારો થયા નથી, સેવ કરવા માટે કંઈ નથી.';

  @override
  String get connectionFailed => 'કનેક્શન નિષ્ફળ';

  @override
  String get unableToJoinRoom =>
      'રૂમમાં જોડાવા અસમર્થ. કૃપા કરીને તમારું નેટવર્ક તપાસો અને ફરી પ્રયાસ કરો.';

  @override
  String get connectionLost => 'કનેક્શન ગુમાવ્યું';

  @override
  String get unableToReconnect =>
      'રૂમ સાથે ફરીથી કનેક્ટ કરવા અસમર્થ. કૃપા કરીને ફરીથી જોડાવાનો પ્રયાસ કરો.';

  @override
  String get invalidFormat => 'અમાન્ય ફોર્મેટ!';

  @override
  String get usernameAlphanumeric =>
      'યુઝરનેમ આલ્ફાન્યુમેરિક હોવું જોઈએ અને તેમાં વિશેષ અક્ષરો હોવા જોઈએ નહીં.';

  @override
  String get userProfileCreatedSuccessfully =>
      'તમારી યુઝર પ્રોફાઈલ સફળતાપૂર્વક બનાવાઈ છે.';

  @override
  String get emailVerificationMessage =>
      'આગળ વધવા માટે, તમારું ઈમેઈલ એડ્રેસ વેરિફાય કરો.';

  @override
  String addNewChaptersToStory(String storyName) {
    return '$storyName માં નવા ચેપ્ટર્સ ઉમેરો';
  }

  @override
  String get currentChapters => 'હાલના ચેપ્ટર્સ';

  @override
  String get sourceCodeOnGitHub => 'ગિટહબ પર સોર્સ કોડ';

  @override
  String get createAChapter => 'એક ચેપ્ટર બનાવો';

  @override
  String get chapterTitle => 'ચેપ્ટર ટાઈટલ *';

  @override
  String get aboutRequired => 'વિશે *';

  @override
  String get changeCoverImage => 'કવર ઈમેજ બદલો';

  @override
  String get uploadAudioFile => 'ઓડિયો ફાઈલ અપલોડ કરો';

  @override
  String get uploadLyricsFile => 'ગીત ફાઈલ અપલોડ કરો';

  @override
  String get createChapter => 'ચેપ્ટર બનાવો';

  @override
  String audioFileSelected(String fileName) {
    return 'ઓડિયો ફાઈલ પસંદ થયેલ: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'ગીત ફાઈલ પસંદ થયેલ: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'કૃપા કરીને બધા જરૂરી ફીલ્ડ્સ ભરો અને તમારી ઓડિયો ફાઈલ અને ગીત ફાઈલ અપલોડ કરો';

  @override
  String get scheduled => 'શેડ્યૂલ્ડ';

  @override
  String get ok => 'ઠીક છે';

  @override
  String get roomDescriptionOptional => 'રૂમ વર્ણન (વૈકલ્પિક)';

  @override
  String get deleteAccount => 'એકાઉન્ટ ડિલીટ કરો';

  @override
  String get createYourStory => 'તમારી વાર્તા બનાવો';

  @override
  String get titleRequired => 'ટાઈટલ *';

  @override
  String get category => 'કેટેગરી *';

  @override
  String get addChapter => 'ચેપ્ટર ઉમેરો';

  @override
  String get createStory => 'વાર્તા બનાવો';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'કૃપા કરીને બધા જરૂરી ફીલ્ડ્સ ભરો, ઓછામાં ઓછો એક ચેપ્ટર ઉમેરો, અને કવર ઈમેજ પસંદ કરો.';

  @override
  String get toConfirmType => 'પુષ્ટિ કરવા માટે, ટાઈપ કરો';

  @override
  String get inTheBoxBelow => 'નીચેના બોક્સમાં';

  @override
  String get iUnderstandDeleteMyAccount =>
      'હું સમજું છું, મારો એકાઉન્ટ ડિલીટ કરો';

  @override
  String get whatDoYouWantToListenTo => 'તમે શું સાંભળવા માગો છો?';

  @override
  String get categories => 'કેટેગરીઝ';

  @override
  String get stories => 'વાર્તાઓ';

  @override
  String get someSuggestions => 'કેટલાક સૂચનો';

  @override
  String get getStarted => 'શરૂઆત કરો';

  @override
  String get skip => 'છોડો';

  @override
  String get welcomeToResonate => 'રેઝોનેટમાં આપનું સ્વાગત છે';

  @override
  String get exploreDiverseConversations => 'વિવિધ વાર્તાલાપ એક્સપ્લોર કરો';

  @override
  String get yourVoiceMatters => 'તમારો અવાજ મહત્વનો છે';

  @override
  String get joinConversationExploreRooms =>
      'વાર્તાલાપમાં જોડાવો! રૂમ્સ એક્સપ્લોર કરો, મિત્રો સાથે જોડાવો અને દુનિયા સાથે તમારો અવાજ શેર કરો.';

  @override
  String get diveIntoDiverseDiscussions =>
      'વિવિધ ચર્ચાઓ અને વિષયોમાં ડૂબકી મારો. \nતમારી સાથે રેઝોનેટ કરતા રૂમ્સ શોધો અને કોમ્યુનિટીનો ભાગ બનો.';

  @override
  String get atResonateEveryVoiceValued =>
      'રેઝોનેટમાં, દરેક અવાજનું મૂલ્ય છે. અન્યો સાથે તમારા વિચારો, વાર્તાઓ અને અનુભવો શેર કરો. હવે જ તમારી ઓડિયો જર્ની શરૂ કરો.';

  @override
  String get notifications => 'નોટિફિકેશન્સ';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username એ તમને આગામી રૂમમાં ટૅગ કર્યા છે: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username એ તમને રૂમમાં ટૅગ કર્યા છે: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username એ તમારી વાર્તા પસંદ કરી છે: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username એ તમારા રૂમને સબ્સ્ક્રાઈબ કર્યું છે: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username એ તમને ફોલો કરવાની શરૂઆત કરી છે';
  }

  @override
  String get youHaveNewNotification => 'તમારી પાસે નવું નોટિફિકેશન છે';

  @override
  String get hangOnGoodThingsTakeTime =>
      'રાહ જુઓ, સારી વસ્તુઓ માટે સમય લાગે છે 🔍';

  @override
  String get resonateOpenSourceProject =>
      'રેઝોનેટ એ AOSSIE દ્વારા જાળવવામાં આવતો ઓપન સોર્સ પ્રોજેક્ટ છે. યોગદાન આપવા માટે અમારો ગિટહબ જુઓ.';

  @override
  String get mute => 'મ્યૂટ કરો';

  @override
  String get speakerLabel => 'સ્પીકર';

  @override
  String get audioOptions => 'Audio Options';

  @override
  String get end => 'સમાપ્ત';

  @override
  String get saveChanges => 'ફેરફારો સેવ કરો';

  @override
  String get discard => 'રદ કરો';

  @override
  String get save => 'સેવ કરો';

  @override
  String get changeProfilePicture => 'પ્રોફાઈલ પિક્ચર બદલો';

  @override
  String get camera => 'કૅમેરા';

  @override
  String get gallery => 'ગૅલેરી';

  @override
  String get remove => 'દૂર કરો';

  @override
  String created(String date) {
    return 'બનાવ્યું $date';
  }

  @override
  String get chapters => 'ચેપ્ટર્સ';

  @override
  String get deleteStory => 'વાર્તા ડિલીટ કરો';

  @override
  String createdBy(String creatorName) {
    return '$creatorName દ્વારા બનાવેલ';
  }

  @override
  String get start => 'શરૂ કરો';

  @override
  String get unsubscribe => 'અનસબ્સ્ક્રાઈબ કરો';

  @override
  String get subscribe => 'સબ્સ્ક્રાઈબ કરો';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'ડ્રામા',
      'comedy': 'કોમેડી',
      'horror': 'હોરર',
      'romance': 'રોમાન્સ',
      'thriller': 'થ્રિલર',
      'spiritual': 'આધ્યાત્મિક',
      'other': 'અન્ય',
    });
    return '$_temp0';
  }

  @override
  String chooseTheme(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'classicTheme': 'ક્લાસિક',
      'timeTheme': 'સમય',
      'vintageTheme': 'વિન્ટેજ',
      'amberTheme': 'એમ્બર',
      'forestTheme': 'ફોરેસ્ટ',
      'creamTheme': 'ક્રીમ',
      'other': 'અન્ય',
    });
    return '$_temp0';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count મિનિટ પહેલા',
      one: '1 મિનિટ પહેલા',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count કલાક પહેલા',
      one: '1 કલાક પહેલા',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count દિવસ પહેલા',
      one: '1 દિવસ પહેલા',
    );
    return '$_temp0';
  }

  @override
  String get by => 'દ્વારા';

  @override
  String get likes => 'લાઈક્સ';

  @override
  String get lengthMinutes => 'મિનિટ';

  @override
  String get requiredField => 'જરૂરી ફીલ્ડ';

  @override
  String get onlineUsers => 'ઓનલાઈન યુઝર્સ';

  @override
  String get noOnlineUsers => 'કોઈ યુઝર્સ હાલમાં ઓનલાઈન નથી';

  @override
  String get chooseUser => 'ચેટ કરવા માટે યુઝર પસંદ કરો';

  @override
  String get quickMatch => 'ક્વિક મેચ';

  @override
  String get story => 'વાર્તા';

  @override
  String get user => 'યુઝર';

  @override
  String get following => 'ફોલોઈંગ';

  @override
  String get followers => 'ફોલોવર્સ';

  @override
  String get friendRequests => 'મિત્ર વિનંતીઓ';

  @override
  String get friendRequestSent => 'મિત્ર વિનંતી મોકલાઈ';

  @override
  String friendRequestSentTo(String username) {
    return '$username ને તમારી મિત્ર વિનંતી મોકલાઈ છે.';
  }

  @override
  String get friendRequestCancelled => 'મિત્ર વિનંતી રદ કરાઈ';

  @override
  String friendRequestCancelledTo(String username) {
    return '$username ને તમારી મિત્ર વિનંતી રદ કરાઈ છે.';
  }

  @override
  String get requested => 'વિનંતી કરેલ';

  @override
  String get friends => 'મિત્રો';

  @override
  String get addFriend => 'મિત્ર ઉમેરો';

  @override
  String get friendRequestAccepted => 'મિત્ર વિનંતી સ્વીકારી';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'તમે હવે \$$username સાથે મિત્ર છો.';
  }

  @override
  String get friendRequestDeclined => 'મિત્ર વિનંતી નકારી';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'તમે \$$username ની મિત્ર વિનંતી નકારી છે.';
  }

  @override
  String get accept => 'સ્વીકારો';

  @override
  String get callDeclined => 'કૉલ નકારી';

  @override
  String callDeclinedTo(String username) {
    return 'યુઝર \$$username એ કૉલ નકારી છે.';
  }

  @override
  String get checkForUpdates => 'અપડેટ્સ તપાસો';

  @override
  String get updateNow => 'હમણાં અપડેટ કરો';

  @override
  String get updateLater => 'પછી';

  @override
  String get updateSuccessful => 'અપડેટ સફળ થયું';

  @override
  String get updateSuccessfulMessage => 'Resonate સફળતાપૂર્વક અપડેટ થયું છે!';

  @override
  String get updateCancelled => 'અપડેટ રદ કર્યું';

  @override
  String get updateCancelledMessage => 'વપરાશકર્તાએ અપડેટ રદ કર્યું';

  @override
  String get updateFailed => 'અપડેટ નિષ્ફળ થયું';

  @override
  String get updateFailedMessage =>
      'અપડેટ કરવામાં નિષ્ફળતા. કૃપા કરીને Play Storeમાંથી મેન્યુઅલી અપડેટ કરવાનો પ્રયાસ કરો.';

  @override
  String get updateError => 'અપડેટ ભૂલ';

  @override
  String get updateErrorMessage =>
      'અપડેટ કરતી વખતે ભૂલ આવી. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get platformNotSupported => 'પ્લેટફોર્મ સપોર્ટેડ નથી';

  @override
  String get platformNotSupportedMessage =>
      'અપડેટ તપાસ ફક્ત Android ઉપકરણો પર જ ઉપલબ્ધ છે';

  @override
  String get updateCheckFailed => 'અપડેટ તપાસ નિષ્ફળ';

  @override
  String get updateCheckFailedMessage =>
      'અપડેટ તપાસી શક્યા નથી. કૃપા કરીને પછીથી પ્રયાસ કરો.';

  @override
  String get upToDateTitle => 'તમે અપ ટુ ડેટ છો!';

  @override
  String get upToDateMessage =>
      'તમે Resonate નું નવું વર્ઝન ઉપયોગ કરી રહ્યા છો';

  @override
  String get updateAvailableTitle => 'અપડેટ ઉપલબ્ધ છે!';

  @override
  String get updateAvailableMessage =>
      'Resonate નું નવું વર્ઝન Play Store પર ઉપલબ્ધ છે';

  @override
  String get updateFeaturesImprovement => 'નવા ફીચર્સ અને સુધારાઓ મેળવો!';

  @override
  String get failedToRemoveRoom => 'Failed to remove room';

  @override
  String get roomRemovedSuccessfully =>
      'Room removed from your list successfully';

  @override
  String get alert => 'ચેતવણી';

  @override
  String get removedFromRoom =>
      'તમને રૂમમાંથી દૂર કરવામાં આવ્યા છે અથવા રિપોર્ટ કરવામાં આવ્યા છે.';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'સતાવણી / દ્વેષપૂર્ણ ભાષણ',
      'abuse': 'અપમાનજનક સામગ્રી / હિંસા',
      'spam': 'સ્પામ / છેતરપિંડી / ફ્રોડ',
      'impersonation': 'ઢોંગ / નકલી એકાઉન્ટ્સ',
      'illegal': 'ગેરકાયદેસર પ્રવૃત્તિઓ',
      'selfharm': 'સ્વ-નુકસાન / આત્મહત્યા / માનસિક સ્વાસ્થ્ય',
      'misuse': 'પ્લેટફોર્મનો દુરુપયોગ',
      'other': 'અન્ય',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate =>
      'તમે અન્ય વપરાશકર્તાઓ પાસેથી અનેક રિપોર્ટ્સ પ્રાપ્ત કર્યા છે અને તમને Resonate નો ઉપયોગ કરવા માટે અવરોધિત કરવામાં આવ્યા છે. જો તમને લાગે કે આ ભૂલ છે તો કૃપા કરીને AOSSIE નો સંપર્ક કરો.';

  @override
  String get reportParticipant => 'ભાગીદારને રિપોર્ટ કરો';

  @override
  String get selectReportType => 'કૃપા કરીને રિપોર્ટ પ્રકાર પસંદ કરો';

  @override
  String get reportSubmitted => 'રિપોર્ટ સફળતાપૂર્વક સબમિટ થયો';

  @override
  String get reportFailed => 'રિપોર્ટ સબમિટ કરવામાં નિષ્ફળ ગયું';

  @override
  String get additionalDetailsOptional => 'વધારાની વિગતો (વૈકલ્પિક)';

  @override
  String get submitReport => 'રિપોર્ટ સબમિટ કરો';

  @override
  String get actionBlocked => 'ક્રિયા અવરોધિત';

  @override
  String get cannotStopRecording =>
      'તમે હસ્તચાલિત રીતે રેકોર્ડિંગ બંધ કરી શકતા નથી, રૂમ બંધ થશે ત્યારે રેકોર્ડિંગ આપમેળે બંધ થશે.';

  @override
  String get liveChapter => 'લાઈવ અધ્યાય';

  @override
  String get viewOrEditLyrics => 'ગીત જુઓ અથવા સંપાદિત કરો';

  @override
  String get close => 'બંધ કરો';

  @override
  String get verifyChapterDetails => 'અધ્યાયની વિગતો ચકાસો';

  @override
  String get author => 'લેખક';

  @override
  String get startLiveChapter => 'લાઈવ અધ્યાય શરૂ કરો';

  @override
  String get fillAllFields => 'કૃપા કરીને તમામ જરૂરી ક્ષેત્રો ભરો';

  @override
  String get noRecordingError =>
      'તમે અધ્યાય માટે કઈ પણ રેકોર્ડિંગ નથી કર્યું. રૂમમાંથી બહાર નીકળતા પહેલાં કૃપા કરીને અધ્યાય રેકોર્ડ કરો.';

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
  String get deleteMessageTitle => 'સંદેશ કાઢી નાખો';

  @override
  String get deleteMessageContent =>
      'શું તમે ખરેખર આ સંદેશ કાઢી નાખવા માંગો છો?';

  @override
  String get thisMessageWasDeleted => 'આ સંદેશ ડિલીટ કરવામાં આવ્યો છે';

  @override
  String get failedToDeleteMessage => 'સંદેશ ડિલીટ કરવામાં નિષ્ફળ';

  @override
  String get usernameInvalidFormat =>
      'યુઝરનેમમાં માત્ર અક્ષરો, નંબરો, બિંદુ, અન્ડરસ્કોર અને ડેશ હોવા જોઈએ';

  @override
  String get usernameAlreadyTaken => 'આ યુઝરનેમ પહેલેથી લેવામાં આવ્યું છે';

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
