// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get title => 'রেজনেট';

  @override
  String get roomDescription =>
      'ভদ্রতা বজায় রাখুন এবং অন্য ব্যক্তির মতামতকে সম্মান করুন। অভদ্র মন্তব্য এড়িয়ে চলুন।';

  @override
  String get hidePassword => 'পাসওয়ার্ড লুকান';

  @override
  String get showPassword => 'পাসওয়ার্ড দেখান';

  @override
  String get passwordEmpty => 'পাসওয়ার্ড খালি হতে পারে না';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get confirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get passwordsNotMatch => 'পাসওয়ার্ড মিলছে না';

  @override
  String get userCreatedStories => 'ইউজার দ্বারা তৈরি গল্প';

  @override
  String get yourStories => 'আপনার গল্প';

  @override
  String get userNoStories => 'ইউজার কোনও গল্প তৈরি করেনি';

  @override
  String get youNoStories => 'আপনি কোনও গল্প তৈরি করেননি';

  @override
  String get follow => 'ফলো করুন';

  @override
  String get editProfile => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String get verifyEmail => 'ইমেইল যাচাই করুন';

  @override
  String get verified => 'ইমেইল যাচাই করা হয়েছে';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get userLikedStories => 'ইউজারের পছন্দের গল্পগুলো';

  @override
  String get yourLikedStories => 'আপনার পছন্দের গল্পগুলো';

  @override
  String get userNoLikedStories => 'ইউজার কোনও গল্প পছন্দ করেনি';

  @override
  String get youNoLikedStories => 'আপনি কোনও গল্প পছন্দ করেননি';

  @override
  String get live => 'লাইভ';

  @override
  String get upcoming => 'আসন্ন';

  @override
  String noAvailableRoom(String isRoom) {
    String _temp0 = intl.Intl.selectLogic(isRoom, {
      'true': 'কোনও রুম খালি নেই',
      'false': 'আসন্ন কোনও রুম খালি নেই',
      'other': 'রুমের কোনও তথ্য পাওয়া যাচ্ছে না',
    });
    return '$_temp0\nনিচে একটি রুম যোগ করে শুরু করুন!';
  }

  @override
  String get user1 => 'ইউজার ১';

  @override
  String get user2 => 'ইউজার ২';

  @override
  String get you => 'আপনি';

  @override
  String get areYouSure => 'আপনি কি নিশ্চিত?';

  @override
  String get loggingOut => 'আপনি রেজোনেট থেকে লগ আউট করছেন।';

  @override
  String get yes => 'হাঁ';

  @override
  String get no => 'না';

  @override
  String get incorrectEmailOrPassword => 'ভুল ইমেইল বা পাসওয়ার্ড';

  @override
  String get passwordShort => 'পাসওয়ার্ড ৮ অক্ষরের কম';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন!';

  @override
  String get success => 'সাফল্য';

  @override
  String get passwordResetSent => 'পাসওয়ার্ড রিসেট ইমেইল পাঠানো হয়েছে!';

  @override
  String get error => 'ত্রুটি';

  @override
  String get resetPassword => 'পাসওয়ার্ড রিসেট করুন';

  @override
  String get enterNewPassword => 'আপনার নতুন পাসওয়ার্ড লিখুন';

  @override
  String get newPassword => 'নতুন পাসওয়ার্ড';

  @override
  String get setNewPassword => 'নতুন পাসওয়ার্ড সেট করুন';

  @override
  String get emailChanged => 'ইমেইল পরিবর্তন করা হয়েছে';

  @override
  String get emailChangeSuccess => 'ইমেইল সফলভাবে পরিবর্তন করা হয়েছে!';

  @override
  String get failed => 'ব্যর্থ হয়েছে';

  @override
  String get emailChangeFailed => 'ইমেইল পরিবর্তন করতে ব্যর্থ হয়েছে';

  @override
  String get oops => 'ওহো!';

  @override
  String get emailExists => 'ইমেইল ইতিমধ্যেই বিদ্যমান';

  @override
  String get changeEmail => 'ইমেইল পরিবর্তন করুন';

  @override
  String get enterValidEmail => 'দয়া করে একটি বৈধ ইমেইল ঠিকানা লিখুন';

  @override
  String get newEmail => 'নতুন ইমেইল';

  @override
  String get currentPassword => 'বর্তমান পাসওয়ার্ড';

  @override
  String get emailChangeInfo =>
      'অতিরিক্ত নিরাপত্তার জন্য, আপনার ইমেইল ঠিকানা পরিবর্তন করার সময় আপনাকে অবশ্যই আপনার অ্যাকাউন্টের বর্তমান পাসওয়ার্ড প্রদান করতে হবে। আপনার ইমেইল পরিবর্তন করার পরে, ভবিষ্যতে লগইনের জন্য আপডেট করা ইমেইলটি ব্যবহার করুন।';

  @override
  String get oauthUsersMessage =>
      '(শুধুমাত্র Google বা Github ব্যবহার করে লগ ইন করা ইউজারদের জন্য)';

  @override
  String get oauthUsersEmailChangeInfo =>
      'যদি আপনি আপনার ইমেইল পরিবর্তন করতে চান, \"বর্তমান পাসওয়ার্ড\" ক্ষেত্রে একটি নতুন পাসওয়ার্ড লিখুন। এই পাসওয়ার্ডটি মনে রাখতে ভুলবেন না, কারণ ভবিষ্যতে যেকোনো ইমেইল পরিবর্তনের জন্য আপনার এটির প্রয়োজন হবে। ভবিষ্যতে, আপনি Google/GitHub অথবা আপনার নতুন ইমেইল এবং পাসওয়ার্ড সংমিশ্রণ ব্যবহার করে লগ ইন করতে পারেন।';

  @override
  String get resonateTagline => 'সীমাহীন এক জগতে প্রবেশ করুন\nকথোপকথন।';

  @override
  String get signInWithEmail => 'ইমেইল দিয়ে সাইন ইন করুন';

  @override
  String get or => 'অথবা';

  @override
  String get continueWith => 'এর মধ্যে যেকোনো একটি দিয়ে সাইন ইন করুন';

  @override
  String get continueWithGoogle => 'Google দিয়ে সাইন ইন করুন';

  @override
  String get continueWithGitHub => 'GitHub দিয়ে সাইন ইন করুন';

  @override
  String get resonateLogo => 'রেজনেট লোগো';

  @override
  String get iAlreadyHaveAnAccount => 'আপনার ইতিমধ্যেই একটি অ্যাকাউন্ট আছে';

  @override
  String get createNewAccount => 'নতুন অ্যাকাউন্ট তৈরি করুন';

  @override
  String get userProfile => 'ইউজার প্রোফাইল';

  @override
  String get passwordIsStrong => 'পাসওয়ার্ড শক্তিশালী আছে';

  @override
  String get admin => 'অ্যাডমিন';

  @override
  String get moderator => 'মডারেটর';

  @override
  String get speaker => 'বক্তা';

  @override
  String get listener => 'শ্রোতা';

  @override
  String get removeModerator => 'মডারেটর সরান';

  @override
  String get kickOut => 'কিক আউট';

  @override
  String get addModerator => 'মডারেটর যোগ করুন';

  @override
  String get addSpeaker => 'বক্তা যোগ করুন';

  @override
  String get makeListener => 'শ্রোতা বানান';

  @override
  String get pairChat => 'পেয়ার চ্যাট';

  @override
  String get chooseIdentity => 'পরিচয় নির্বাচন করুন';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন কর';

  @override
  String get noConnection => 'কোন সংযোগ নেই';

  @override
  String get loadingDialog => 'লোড হচ্ছে...';

  @override
  String get createAccount => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get enterValidEmailAddress => 'বৈধ ইমেইল ঠিকানা লিখুন';

  @override
  String get email => 'ইমেইল';

  @override
  String get passwordRequirements => 'পাসওয়ার্ড অন্তত ৮ অক্ষরের হতে হবে';

  @override
  String get includeNumericDigit =>
      'অন্তত ১টি সাংখ্যিক সংখ্যা অন্তর্ভুক্ত করুন';

  @override
  String get includeUppercase => 'অন্তত ১টি বড় হাতের অক্ষর অন্তর্ভুক্ত করুন';

  @override
  String get includeLowercase => 'অন্তত ১টি ছোট হাতের অক্ষর অন্তর্ভুক্ত করুন';

  @override
  String get includeSymbol => 'অন্তত ১টি চিহ্ন অন্তর্ভুক্ত করুন';

  @override
  String get signedUpSuccessfully => 'সফলভাবে সাইন আপ করা হয়েছে';

  @override
  String get newAccountCreated =>
      'আপনি সফলভাবে একটি নতুন অ্যাকাউন্ট তৈরি করেছেন';

  @override
  String get signUp => 'সাইন আপ';

  @override
  String get login => 'লগইন';

  @override
  String get settings => 'সেটিংস';

  @override
  String get accountSettings => 'অ্যাকাউন্ট সেটিংস';

  @override
  String get account => 'অ্যাকাউন্ট';

  @override
  String get appSettings => 'অ্যাপ সেটিংস';

  @override
  String get themes => 'থিম';

  @override
  String get about => 'রেজোনেট সম্পর্কে';

  @override
  String get other => 'অন্যান্য';

  @override
  String get contribute => 'অবদান রাখুন';

  @override
  String get appPreferences => 'অ্যাপ পছন্দসমূহ';

  @override
  String get transcriptionModel => 'ট্রান্সক্রিপশন মডেল';

  @override
  String get transcriptionModelDescription =>
      'ভয়েস ট্রান্সক্রিপশনের জন্য AI মডেলটি বেছে নিন। বড় মডেলগুলি আরও নির্ভুল কিন্তু ধীর এবং আরও বেশি স্টোরেজ প্রয়োজন।';

  @override
  String get whisperModelTiny => 'টিনি';

  @override
  String get whisperModelTinyDescription =>
      'দ্রুততম, সবচেয়ে কম নির্ভুল (~39 MB)';

  @override
  String get whisperModelBase => 'বেশ';

  @override
  String get whisperModelBaseDescription => 'সুষম গতি এবং নির্ভুলতা (~74 MB)';

  @override
  String get whisperModelSmall => 'স্মল';

  @override
  String get whisperModelSmallDescription =>
      'ভালো নির্ভুলতা, ধীর গতি (~244 MB)';

  @override
  String get whisperModelMedium => 'মিডিয়াম';

  @override
  String get whisperModelMediumDescription =>
      'উচ্চ নির্ভুলতা, ধীর গতি (~769 MB)';

  @override
  String get whisperModelLargeV1 => 'লার্জ V1';

  @override
  String get whisperModelLargeV1Description =>
      'সবচেয়ে নির্ভুল, সবচেয়ে ধীর (~1.55 GB)';

  @override
  String get whisperModelLargeV2 => 'লার্জ V2';

  @override
  String get whisperModelLargeV2Description =>
      'উন্নত বড় মডেল, উচ্চ নির্ভুলতা সহ (~1.55 GB)';

  @override
  String get modelDownloadInfo =>
      'মডেলগুলি প্রথমবার ব্যবহার করার সময় ডাউনলোড করা হয়। আমরা বেস, স্মল বা মিডিয়াম ব্যবহার করার পরামর্শ দিই। বড় মডেলগুলির জন্য খুব উচ্চমানের ডিভাইসের প্রয়োজন হয়।';

  @override
  String get logOut => 'লগ আউট';

  @override
  String get participants => 'পার্টিসিপেন্টস';

  @override
  String get delete => 'ডিলিট';

  @override
  String get leave => 'বিদায়';

  @override
  String get leaveButton => 'বিদায়';

  @override
  String get findingRandomPartner =>
      'আপনার জন্য একটি রেন্ডম পার্টনার খোঁজা হচ্ছে';

  @override
  String get quickFact => 'দ্রুত তথ্য';

  @override
  String get cancel => 'ক্যানসেল';

  @override
  String get hide => 'রিমুভ';

  @override
  String get removeRoom => 'রিমুভ রুম';

  @override
  String get removeRoomFromList => 'রিমুভ ফ্রম লিস্ট';

  @override
  String get removeRoomConfirmation =>
      'আপনি কি নিশ্চিত যে আপনি এই আসন্ন রুমটি আপনার তালিকা থেকে সরিয়ে ফেলতে চান?';

  @override
  String get completeYourProfile => 'আপনার প্রোফাইল সম্পূর্ণ করুন';

  @override
  String get uploadProfilePicture => 'প্রোফাইল ছবি আপলোড করুন';

  @override
  String get enterValidName => 'বৈধ নাম লিখুন';

  @override
  String get name => 'নাম';

  @override
  String get username => 'ইউজারনেম';

  @override
  String get enterValidDOB => 'বৈধ জন্ম তারিখ লিখুন';

  @override
  String get dateOfBirth => 'জন্ম তারিখ';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get next => 'পরবর্তী';

  @override
  String get noStoriesExist => 'উপস্থাপন করার মতো কোনও গল্প নেই';

  @override
  String get enterVerificationCode => 'আপনার\nভেরিফিকেশন কোড লিখুন';

  @override
  String get verificationCodeSent =>
      'আমরা 6-সংখ্যার একটি ভেরিফিকেশন কোড পাঠিয়েছি\n';

  @override
  String get verificationComplete => 'ভেরিফিকেশন সম্পন্ন হয়েছে';

  @override
  String get verificationCompleteMessage =>
      'অভিনন্দন! আপনি আপনার ইমেইল ভেরিফাই করেছেন';

  @override
  String get verificationFailed => 'ভেরিফিকেশন ব্যর্থ হয়েছে';

  @override
  String get otpMismatch => 'OTP অমিল হয়েছে, অনুগ্রহ করে আবার চেষ্টা করুন';

  @override
  String get otpResent => 'OTP পুনরায় পাঠানো হয়েছে';

  @override
  String get requestNewCode => 'একটি নতুন কোডের অনুরোধ করুন';

  @override
  String get requestNewCodeIn => 'এই সময়ের পরে একটি নতুন কোডের অনুরোধ করুন';

  @override
  String get clickPictureCamera => 'ক্যামেরা ব্যবহার করে ছবি তুলুন';

  @override
  String get pickImageGallery => 'গ্যালারি থেকে ছবি নির্বাচন করুন';

  @override
  String get deleteMyAccount => 'আমার অ্যাকাউন্ট ডিলিট করুন';

  @override
  String get createNewRoom => 'নতুন রুম তৈরি করুন';

  @override
  String get pleaseEnterScheduledDateTime =>
      'অনুগ্রহ করে নির্ধারিত তারিখ-সময় লিখুন';

  @override
  String get scheduleDateTimeLabel => 'তারিখ সময় নির্ধারণ করুন';

  @override
  String get enterTags => 'ট্যাগ লিখুন';

  @override
  String get joinCommunity => 'কমিউনিটিতে যোগদান করুন!';

  @override
  String get followUsOnX => 'X এ আমাদের ফলো করুন';

  @override
  String get joinDiscordServer => 'Discord সার্ভারে যোগদান করুন';

  @override
  String get noLyrics => 'কোনও লিরিক উপলব্ধ নেই';

  @override
  String noStoriesInCategory(String categoryName) {
    return 'বর্তমানে $categoryName বিভাগে কোনও গল্প নেই।';
  }

  @override
  String get newChapters => 'নতুন অধ্যায়';

  @override
  String get helpToGrow => 'বৃদ্ধিতে সাহায্য করুন!';

  @override
  String get share => 'শেয়ার করুন';

  @override
  String get rate => 'রেটিং দিন';

  @override
  String get aboutResonate => 'রেজোনেট সম্পর্কে';

  @override
  String get description => 'বিবরণ';

  @override
  String get confirm => 'নিশ্চিত করুন';

  @override
  String get classic => 'ক্লাসিক';

  @override
  String get time => 'টাইম';

  @override
  String get vintage => 'ভিনটেজ';

  @override
  String get amber => 'অ্যাম্বার';

  @override
  String get forest => 'ফরেস্ট';

  @override
  String get cream => 'ক্রিম';

  @override
  String get none => 'কোনটিই নয়';

  @override
  String checkOutGitHub(String url) {
    return 'আমাদের GitHub রিপোজিটরি দেখুন: $url';
  }

  @override
  String get aossie => 'AOSSIE';

  @override
  String get aossieLogo => 'aossie লোগো';

  @override
  String get errorLoadPackageInfo => 'প্যাকেজ তথ্য লোড করা যায়নি';

  @override
  String get searchFailed =>
      'রুমগুলি অনুসন্ধান করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get updateAvailable => 'আপডেট উপলব্ধ আছে';

  @override
  String get newVersionAvailable => 'একটি নতুন ভার্সন পাওয়া যাচ্ছে!';

  @override
  String get upToDate => 'আপ টু ডেট';

  @override
  String get latestVersion => 'আপনি সর্বশেষ ভার্সন ব্যবহার করছেন';

  @override
  String get profileCreatedSuccessfully => 'প্রোফাইল সফলভাবে তৈরি করা হয়েছে!';

  @override
  String get invalidScheduledDateTime => 'অবৈধ নির্ধারিত তারিখ-সময়';

  @override
  String get scheduledDateTimePast => 'নির্ধারিত তারিখ-সময় অতীতের হতে পারে না';

  @override
  String get joinRoom => 'রুমে যৌন করুন';

  @override
  String get unknownUser => 'অজানা';

  @override
  String get canceled => 'বাতিল করা হয়েছে';

  @override
  String get english => 'en';

  @override
  String get emailVerificationRequired => 'ইমেইল যাচাইকরণ প্রয়োজন';

  @override
  String get verify => 'যাচাই করুন';

  @override
  String get audioRoom => 'অডিও রুম';

  @override
  String toRoomAction(String action) {
    return 'রুমে $action করার জন্য';
  }

  @override
  String get mailSentMessage => 'মেইল পাঠানো হয়েছে';

  @override
  String get disconnected => 'সংযোগ বিচ্ছিন্ন';

  @override
  String get micOn => 'মাইক';

  @override
  String get speakerOn => 'স্পিকার';

  @override
  String get endChat => 'চ্যাট বন্ধ করুন';

  @override
  String get monthJan => 'জানুয়ারী';

  @override
  String get monthFeb => 'ফেব্রুয়ারি';

  @override
  String get monthMar => 'মার্চ';

  @override
  String get monthApr => 'এপ্রিল';

  @override
  String get monthMay => 'মে';

  @override
  String get monthJun => 'জুন';

  @override
  String get monthJul => 'জুলাই';

  @override
  String get monthAug => 'আগস্ট';

  @override
  String get monthSep => 'সেপ্টেম্বর';

  @override
  String get monthOct => 'অক্টোবর';

  @override
  String get monthNov => 'নভেম্বর';

  @override
  String get monthDec => 'ডিসেম্বর';

  @override
  String get register => 'রেজিস্টার';

  @override
  String get newToResonate => 'রেজোনেটে নতুন? ';

  @override
  String get alreadyHaveAccount => 'ইতিমধ্যে একটি অ্যাকাউন্ট আছে? ';

  @override
  String get checking => 'পরীক্ষা করা হচ্ছে...';

  @override
  String get forgotPasswordMessage =>
      'আপনার পাসওয়ার্ড রিসেট করতে আপনার ইতিমধ্যে রেজিস্টার্ড ইমেইল ঠিকানাটি দিন';

  @override
  String get usernameUnavailable => 'ইউজারনেম অনুপলব্ধ!';

  @override
  String get usernameInvalidOrTaken =>
      'এই ইউজারনেমটি অবৈধ অথবা ইতিমধ্যেই নেওয়া হয়েছে।';

  @override
  String get otpResentMessage => 'নতুন OTP এর জন্য আপনার মেইল ​​চেক করুন।';

  @override
  String get connectionError =>
      'সংযোগে সমস্যা হয়েছে। অনুগ্রহ করে আপনার ইন্টারনেট পরীক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get seconds => 'সেকেন্ড।';

  @override
  String get unsavedChangesWarning =>
      'যদি আপনি সেভ না করে এগিয়ে যান, তাহলে যেকোনো সেভ না করা পরিবর্তন হারিয়ে যাবে।';

  @override
  String get deleteAccountPermanent =>
      'এই পদক্ষেপটি আপনার অ্যাকাউন্ট স্থায়ীভাবে ডিলিট করে দেবে। এটি একটি অপরিবর্তনীয় প্রক্রিয়া। আমরা আপনার ইউজারনেম, ইমেইল ঠিকানা এবং আপনার অ্যাকাউন্টের সাথে সম্পর্কিত অন্যান্য সমস্ত ডেটা ডিলিট করে দেব। আপনি এটি পুনরুদ্ধার করতে পারবেন না।';

  @override
  String get giveGreatName => 'দারুন একটা নাম দিন..';

  @override
  String get joinCommunityDescription =>
      'কমিউনিটিতে যোগদানের মাধ্যমে আপনি আপনার সন্দেহ দূর করতে পারেন, নতুন বৈশিষ্ট্যগুলির জন্য পরামর্শ দিতে পারেন, আপনার সম্মুখীন সমস্যাগুলি রিপোর্ট করতে পারেন এবং আরও অনেক কিছু করতে পারেন।';

  @override
  String get resonateDescription =>
      'রেজোনেট একটি সোশ্যাল মিডিয়া প্ল্যাটফর্ম, যেখানে প্রতিটি কণ্ঠস্বরকে মূল্য দেওয়া হয়। আপনার চিন্তাভাবনা, গল্প এবং অভিজ্ঞতা অন্যদের সাথে ভাগ করে নিন। এখনই আপনার অডিও যাত্রা শুরু করুন। বিভিন্ন আলোচনা এবং বিষয়ে ডুবে যান। এমন রুম খুঁজুন যা আপনার সাথে প্রতিধ্বনিত হয় এবং সম্প্রদায়ের অংশ হয়ে উঠুন। কথোপকথনে যোগ দিন! রুমগুলি অন্বেষণ করুন, বন্ধুদের সাথে সংযোগ স্থাপন করুন এবং বিশ্বের সাথে আপনার কণ্ঠস্বর ভাগ করুন।';

  @override
  String get resonateFullDescription =>
      'রেজোনেট একটি বিপ্লবী ভয়েস-ভিত্তিক সোশ্যাল মিডিয়া প্ল্যাটফর্ম যেখানে প্রতিটি ভয়েস গুরুত্বপূর্ণ। \nরিয়েল-টাইম অডিও কথোপকথনে যোগ দিন, বিভিন্ন আলোচনায় অংশগ্রহণ করুন এবং \nএকই মনের ইউজারদের সাথে সংযোগ স্থাপন করুন। আমাদের প্ল্যাটফর্মটি অফার করে:\n- বিষয়-ভিত্তিক আলোচনা সহ লাইভ অডিও রুম\n- ভয়েসের মাধ্যমে নিরবচ্ছিন্ন সোশ্যাল নেটওয়ার্কিং\n- সম্প্রদায়-চালিত কন্টেন্ট মডারেশন\n- ক্রস-প্ল্যাটফর্ম সামঞ্জস্য\n- এন্ড-টু-এন্ড এনক্রিপ্ট করা ব্যক্তিগত কথোপকথন\n\n AOSSIE ওপেন সোর্স কমিউনিটি দ্বারা তৈরি, আমরা উজারদের গোপনীয়তা এবং \n সম্প্রদায়-চালিত উন্নয়নকে অগ্রাধিকার দিই। সামাজিক অডিওর ভবিষ্যত গঠনে আমাদের সাথে যোগ দিন!';

  @override
  String get stable => 'স্থিতিশীল';

  @override
  String get usernameCharacterLimit => 'ইউজারনেম ৫টির বেশি অক্ষরের হতে হবে।';

  @override
  String get submit => 'জমা দিন';

  @override
  String get anonymous => 'অজানা';

  @override
  String get noSearchResults => 'কোনও রেজাল্ট পাওয়া যায়নি';

  @override
  String get searchRooms => 'রুম খুঁজুন...';

  @override
  String get searchingRooms => 'রুম খোঁজা চলছে...';

  @override
  String get clearSearch => 'সার্চ মুছে ফেলুন';

  @override
  String get searchError => 'সার্চে ত্রুটি';

  @override
  String get searchRoomsError =>
      'রুমগুলি অনুসন্ধান করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get searchUpcomingRoomsError =>
      'আসন্ন রুমগুলি অনুসন্ধান করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get search => 'সার্চ';

  @override
  String get clear => 'মুছে ফেলুন';

  @override
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  ) {
    return '🚀এই অসাধারণ রুমটি দেখুন: $roomName!\n\n📖 বিবরণ: $description\n👥 এখনই $participants অংশগ্রহণকারীরদেড় সাথে যোগ দিন!';
  }

  @override
  String participantsCount(int count) {
    return '$count অংশগ্রহণকারীরা';
  }

  @override
  String get join => 'যোগ দিন';

  @override
  String get invalidTags => 'অবৈধ ট্যাগ:';

  @override
  String get cropImage => 'ছবি ক্রপ করুন';

  @override
  String get profileSavedSuccessfully => 'প্রোফাইল আপডেট করা হয়েছে';

  @override
  String get profileUpdatedSuccessfully =>
      'সকল পরিবর্তন সফলভাবে সেভ হয়ে গেছে।';

  @override
  String get profileUpToDate => 'প্রোফাইল আপ টু ডেট আছে';

  @override
  String get noChangesToSave =>
      'নতুন কোনও পরিবর্তন করা হয়নি, সেভ করার মতো কিছু নেই।';

  @override
  String get connectionFailed => 'সংযোগ ব্যর্থ হয়েছে!';

  @override
  String get unableToJoinRoom =>
      'রুম যৌন করতে ব্যার্থ হয়েছে। আপনার নেটওয়ার্ক পরীক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get connectionLost => 'সংযোগ বিচ্ছিন্ন';

  @override
  String get unableToReconnect =>
      'রুমে পুনরায় যৌন করা যাচ্ছে না। অনুগ্রহ করে আবার যোগদানের চেষ্টা করুন।';

  @override
  String get invalidFormat => 'অবৈধ ফর্ম্যাট!';

  @override
  String get usernameAlphanumeric =>
      'ইউজারনেম অবশ্যই আলফানিউমেরিক হতে হবে এবং বিশেষ অক্ষর থাকা উচিত নয়।';

  @override
  String get userProfileCreatedSuccessfully =>
      'আপনার ইউজার প্রোফাইল সফলভাবে তৈরি হয়েছে।';

  @override
  String get emailVerificationMessage =>
      'এগিয়ে যেতে, আপনার ইমেইল ঠিকানা যাচাই করুন।';

  @override
  String addNewChaptersToStory(String storyName) {
    return '$storyName এ নতুন অধ্যায় যোগ করুন';
  }

  @override
  String get currentChapters => 'বর্তমান অধ্যায়গুলি';

  @override
  String get sourceCodeOnGitHub => 'GitHub এর সোর্স কোড';

  @override
  String get createAChapter => 'একটি নতুন অধ্যায় তৈরি করুন';

  @override
  String get chapterTitle => 'অধ্যায়ের শিরোনাম *';

  @override
  String get aboutRequired => 'অধ্যায় সম্পর্কে *';

  @override
  String get changeCoverImage => 'কভার ছবি পরিবর্তন করুন';

  @override
  String get uploadAudioFile => 'অডিও ফাইল আপলোড করুন';

  @override
  String get uploadLyricsFile => 'লিরিক্স ফাইল আপলোড করুন';

  @override
  String get createChapter => 'একটি নতুন অধ্যায় বানান';

  @override
  String audioFileSelected(String fileName) {
    return 'অডিও ফাইলটি নির্বাচিত: $fileName';
  }

  @override
  String lyricsFileSelected(String fileName) {
    return 'লিরিক্স ফাইলটি নির্বাচিত: $fileName';
  }

  @override
  String get fillAllRequiredFields =>
      'অনুগ্রহ করে সমস্ত প্রয়োজনীয় ক্ষেত্র পূরণ করুন এবং আপনার অডিও ফাইল এবং লিরিক্স ফাইল আপলোড করুন।';

  @override
  String get scheduled => 'নির্ধারিত';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get roomDescriptionOptional => 'রুমের বর্ণনা (ঐচ্ছিক)';

  @override
  String get deleteAccount => 'অ্যাকাউন্ট ডিলিট করুন';

  @override
  String get createYourStory => 'আপনার গল্প তৈরি করুন';

  @override
  String get titleRequired => 'শিরোনাম *';

  @override
  String get category => 'বিভাগ *';

  @override
  String get addChapter => 'অধ্যায় যোগ করুন';

  @override
  String get createStory => 'গল্প তৈরি করুন';

  @override
  String get fillAllRequiredFieldsAndChapter =>
      'অনুগ্রহ করে সমস্ত প্রয়োজনীয় ক্ষেত্র পূরণ করুন, কমপক্ষে একটি অধ্যায় যোগ করুন এবং একটি কভার ছবি নির্বাচন করুন।';

  @override
  String get toConfirmType => 'নিশ্চিত করতে, টাইপ করুন';

  @override
  String get inTheBoxBelow => 'নিচের বাক্সে লিখুন';

  @override
  String get iUnderstandDeleteMyAccount =>
      'আমি বুঝতে পারছি, আমার অ্যাকাউন্ট ডিলিট করে দিন';

  @override
  String get whatDoYouWantToListenTo => 'আপনি কী শুনতে চান?';

  @override
  String get categories => 'বিভাগসমূহ';

  @override
  String get stories => 'গল্পসমূহ';

  @override
  String get someSuggestions => 'কিছু পরামর্শ';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get skip => 'এড়িয়ে যান';

  @override
  String get welcomeToResonate => 'রেজোনেটে স্বাগতম';

  @override
  String get exploreDiverseConversations => 'বিভিন্ন ধরনের আলোচনায় যোগ দিন';

  @override
  String get yourVoiceMatters => 'আপনার কণ্ঠস্বর গুরুত্বপূর্ণ';

  @override
  String get joinConversationExploreRooms =>
      'আলোচনায় যোগ দিন! রুমগুলি ঘুরে দেখুন, বন্ধুদের সাথে সংযুক্ত হন এবং বিশ্বের সাথে আপনার মতামত ভাগ করে নিন।';

  @override
  String get diveIntoDiverseDiscussions =>
      'বিভিন্ন আলোচনা এবং বিষয়গুলিতে ডুবে যান। \nএমন রুম খুঁজুন যা আপনার সাথে রেজোনেট করে এবং সম্প্রদায়ের অংশ হয়ে উঠুন।';

  @override
  String get atResonateEveryVoiceValued =>
      'রেজোনেটে, প্রতিটি কণ্ঠস্বরকে মূল্য দেওয়া হয়। আপনার চিন্তাভাবনা, গল্প এবং অভিজ্ঞতা অন্যদের সাথে ভাগ করুন। এখনই আপনার অডিও যাত্রা শুরু করুন।';

  @override
  String get notifications => 'নোটিফিকেশন্স';

  @override
  String taggedYouInUpcomingRoom(String username, String subject) {
    return '$username আপনাকে একটি আসন্ন রুমে ট্যাগ করেছে: $subject';
  }

  @override
  String taggedYouInRoom(String username, String subject) {
    return '$username আপনাকে এই রুমে ট্যাগ করেছে: $subject';
  }

  @override
  String likedYourStory(String username, String subject) {
    return '$username আপনার গল্পটা লাইক করেছে: $subject';
  }

  @override
  String subscribedToYourRoom(String username, String subject) {
    return '$username আপনার রুমে সাবস্ক্রাইব করেছে: $subject';
  }

  @override
  String startedFollowingYou(String username) {
    return '$username আপনাকে ফলো করা শুরু করেছে:';
  }

  @override
  String get youHaveNewNotification => 'আপনার একটি নতুন নোটিফিকেশন আছে।';

  @override
  String get hangOnGoodThingsTakeTime =>
      'একটু অপেক্ষা করুন, ভালো জিনিসের জন্য সময় লাগে 🔍';

  @override
  String get resonateOpenSourceProject =>
      'Resonate হল AOSSIE দ্বারা পরিচালিত একটি ওপেন সোর্স প্রকল্প। অবদান রাখতে আমাদের github দেখুন।';

  @override
  String get mute => 'মিউট';

  @override
  String get speakerLabel => 'স্পিকার';

  @override
  String get end => 'শেষ করুন';

  @override
  String get saveChanges => 'পরিবর্তনগুলি সেভ করুন';

  @override
  String get discard => 'বাতিল করুন';

  @override
  String get save => 'সেভ করুন';

  @override
  String get changeProfilePicture => 'প্রোফাইল ছবি পরিবর্তন করুন';

  @override
  String get camera => 'ক্যামেরা';

  @override
  String get gallery => 'গ্যালারি';

  @override
  String get remove => 'সরিয়ে ফেলুন';

  @override
  String created(String date) {
    return 'বানানো হয়েছিল $date';
  }

  @override
  String get chapters => 'অধ্যায়গুলি';

  @override
  String get deleteStory => 'গল্প ডিলিট করুন';

  @override
  String createdBy(String creatorName) {
    return '$creatorName এনার দ্বারা বানানো হয়েছে';
  }

  @override
  String get start => 'শুরু করুন';

  @override
  String get unsubscribe => 'আনসাবস্ক্রাইব করুন';

  @override
  String get subscribe => 'সাবস্ক্রাইব করুন';

  @override
  String storyCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'drama': 'নাটক',
      'comedy': 'কমেডি',
      'horror': 'ভয়ের',
      'romance': 'রমন্যাস',
      'thriller': 'থ্রিলার',
      'spiritual': 'আধ্যাত্মিক',
      'other': 'অন্যান্য',
    });
    return '$_temp0';
  }

  @override
  String chooseTheme(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'classicTheme': 'ক্লাসিক',
      'timeTheme': 'সময়',
      'vintageTheme': 'ভিনটেজ',
      'amberTheme': 'অ্যাম্বার',
      'forestTheme': 'জনজঙ্গল',
      'creamTheme': 'ক্রিম',
      'other': 'অন্যান্য',
    });
    return '$_temp0';
  }

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মিনিট আগে',
      one: '১ মিনিট আগে',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ঘন্টা আগে',
      one: '১ ঘন্টা আগে',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন আগে',
      one: '১ দিন আগে',
    );
    return '$_temp0';
  }

  @override
  String get by => 'লিখেছেন';

  @override
  String get likes => 'লাইক';

  @override
  String get lengthMinutes => 'মিনিট';

  @override
  String get requiredField => 'প্রয়োজনীয় ক্ষেত্র';

  @override
  String get onlineUsers => 'অনলাইন ইউজার্স';

  @override
  String get noOnlineUsers => 'বর্তমানে কোনও ইউজার অনলাইনে নেই।';

  @override
  String get chooseUser => 'চ্যাট করার জন্য ইউজার পছন্দ করুন';

  @override
  String get quickMatch => 'দ্রুত মিল করুন';

  @override
  String get story => 'গল্প';

  @override
  String get user => 'ইউজার';

  @override
  String get following => 'ফলো করছে';

  @override
  String get followers => 'ফলোয়ার্স';

  @override
  String get friendRequests => 'বন্ধুত্বের অনুরোধ';

  @override
  String get friendRequestSent => 'বন্ধুত্বের অনুরোধ পাঠানো হয়েছে';

  @override
  String friendRequestSentTo(String username) {
    return 'আপনার বন্ধুত্বের অনুরোধ $username-কে পাঠানো হয়েছে।';
  }

  @override
  String get friendRequestCancelled => 'বন্ধুত্বের অনুরোধ বাতিল করা হয়েছে';

  @override
  String friendRequestCancelledTo(String username) {
    return '$username-এর কাছে আপনার বন্ধুত্বের অনুরোধ বাতিল করা হয়েছে।';
  }

  @override
  String get requested => 'অনুরোধ পাঠানো হয়েছে';

  @override
  String get friends => 'বন্ধুরা';

  @override
  String get addFriend => 'বন্ধু যোগ করুন';

  @override
  String get friendRequestAccepted => 'বন্ধুত্বের অনুরোধ গৃহীত হয়েছে';

  @override
  String friendRequestAcceptedTo(String username) {
    return 'আপনি এখন $username এর বন্ধু।';
  }

  @override
  String get friendRequestDeclined =>
      'বন্ধুত্বের অনুরোধ প্রত্যাখ্যান করা হয়েছে';

  @override
  String friendRequestDeclinedTo(String username) {
    return 'আপনি $username এর বন্ধুত্বের অনুরোধ প্রত্যাখ্যান করেছেন।';
  }

  @override
  String get accept => 'গ্রহণ করুন';

  @override
  String get callDeclined => 'কল প্রত্যাখ্যান করা হয়েছে';

  @override
  String callDeclinedTo(String username) {
    return '$username কলটি প্রত্যাখ্যান করেছেন।';
  }

  @override
  String get checkForUpdates => 'আপডেট চেক করুন';

  @override
  String get updateNow => 'এখনই আপডেট করুন';

  @override
  String get updateLater => 'পরে';

  @override
  String get updateSuccessful => 'আপডেট সফল হয়েছে';

  @override
  String get updateSuccessfulMessage => 'রেজোনেট সফলভাবে আপডেট করা হয়েছে!';

  @override
  String get updateCancelled => 'আপডেট বাতিল করা হয়েছে';

  @override
  String get updateCancelledMessage => 'ইউজার আপডেট বাতিল করেছেন';

  @override
  String get updateFailed => 'আপডেট ব্যর্থ হয়েছে';

  @override
  String get updateFailedMessage =>
      'আপডেট করা যায়নি। অনুগ্রহ করে Play Store থেকে ম্যানুয়ালি আপডেট করার চেষ্টা করুন।';

  @override
  String get updateError => 'আপডেটে ত্রুটি';

  @override
  String get updateErrorMessage =>
      'আপডেট করার সময় একটি ত্রুটি ঘটেছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get platformNotSupported => 'প্ল্যাটফর্ম সমর্থিত নয়';

  @override
  String get platformNotSupportedMessage =>
      'আপডেট চেকিং শুধুমাত্র Android ডিভাইসেই উপলব্ধ';

  @override
  String get updateCheckFailed => 'আপডেট চেক ব্যর্থ হয়েছে';

  @override
  String get updateCheckFailedMessage =>
      'আপডেটগুলি পরীক্ষা করা যায়নি। অনুগ্রহ করে পরে আবার চেষ্টা করুন।';

  @override
  String get upToDateTitle => 'আপনি আপ টু ডেট আছেন!';

  @override
  String get upToDateMessage => 'আপনি রেজোনেটের সর্বশেষ ভার্সন ব্যবহার করছেন।';

  @override
  String get updateAvailableTitle => 'আপডেট উপলব্ধ আছে!';

  @override
  String get updateAvailableMessage =>
      'রেজোনেটের একটি নতুন ভার্সন Play Store এ উপলব্ধ আছে';

  @override
  String get updateFeaturesImprovement =>
      'সর্বশেষ বৈশিষ্ট্য এবং উন্নতি সহ আপডেট করুন।';

  @override
  String get failedToRemoveRoom => 'রুম সরানো যায়নি';

  @override
  String get roomRemovedSuccessfully =>
      'আপনার তালিকা থেকে রুমটি সফলভাবে সরানো হয়েছে';

  @override
  String get alert => 'সতর্কতা';

  @override
  String get removedFromRoom =>
      'আপনার বিরুদ্ধে অভিযোগ করা হয়েছে অথবা আপনাকে রুম থেকে সরিয়ে দেওয়া হয়েছে।';

  @override
  String reportType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'harassment': 'হ্যারাসমেন্ট / ঘৃণাত্মক বক্তব্য',
      'abuse': 'অপমানজনক বিষয়বস্তু / হিংস্রতা',
      'spam': 'স্প্যাম / স্ক্যাম / জালিয়াতি',
      'impersonation': 'নকল পরিচয় / নকল অ্যাকাউন্ট',
      'illegal': 'অবৈধ কার্যকলাপ',
      'selfharm': 'নিজের ক্ষতি / আত্মহত্যা / মানসিক স্বাস্থ্য',
      'misuse': 'প্ল্যাটফর্মের অপব্যবহার',
      'other': 'অন্যান্য',
    });
    return '$_temp0';
  }

  @override
  String get userBlockedFromResonate =>
      'আপনি ইউজারদের কাছ থেকে একাধিক প্রতিবেদন পেয়েছেন এবং আপনাকে Resonate ব্যবহার থেকে ব্লক করা হয়েছে। যদি আপনি মনে করেন এটি একটি ভুল, তাহলে অনুগ্রহ করে AOSSIE-এর সাথে যোগাযোগ করুন।';

  @override
  String get reportParticipant => 'অংশগ্রহণকারীকে রিপোর্ট করুন';

  @override
  String get selectReportType =>
      'অনুগ্রহ করে একটি রিপোর্টের ধরণ নির্বাচন করুন।';

  @override
  String get reportSubmitted => 'রিপোর্ট সফলভাবে জমা দেওয়া হয়েছে';

  @override
  String get reportFailed => 'রিপোর্ট জমা দেওয়া ব্যর্থ হয়েছে';

  @override
  String get additionalDetailsOptional => 'অতিরিক্ত বিবরণ (ঐচ্ছিক)';

  @override
  String get submitReport => 'রিপোর্ট জমা দিন';

  @override
  String get actionBlocked => 'অ্যাকশন ব্লক করা হয়েছে';

  @override
  String get cannotStopRecording =>
      'আপনি ম্যানুয়ালি রেকর্ডিং বন্ধ করতে পারবেন না, রুম বন্ধ হয়ে গেলে রেকর্ডিং বন্ধ হয়ে যাবে।';

  @override
  String get liveChapter => 'লাইভ অধ্যায়';

  @override
  String get viewOrEditLyrics => 'লিরিকস দেখুন বা সম্পাদনা করুন';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get verifyChapterDetails => 'অধ্যায়ের বিবরণ যাচাই করুন';

  @override
  String get author => 'লেখক';

  @override
  String get startLiveChapter => 'একটি লাইভ অধ্যায় শুরু করুন';

  @override
  String get fillAllFields =>
      'অনুগ্রহ করে সমস্ত প্রয়োজনীয় ক্ষেত্র পূরণ করুন।';

  @override
  String get noRecordingError =>
      'আপনি অধ্যায়টির জন্য কিছুই রেকর্ড করোনি। রুম থেকে বের হওয়ার আগে অনুগ্রহ করে একটি অধ্যায় রেকর্ড করুন।';

  @override
  String get deleteMessageTitle => 'Delete Message';

  @override
  String get deleteMessageContent =>
      'Are you sure you want to delete this message?';

  @override
  String get thisMessageWasDeleted => 'This message was deleted';

  @override
  String get failedToDeleteMessage => 'Failed to delete message';
}
