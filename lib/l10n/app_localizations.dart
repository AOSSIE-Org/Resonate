import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Resonate'**
  String get title;

  /// No description provided for @roomDescription.
  ///
  /// In en, this message translates to:
  /// **'Be polite and respect the other person\'s opinion. Avoid rude comments.'**
  String get roomDescription;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide Password'**
  String get hidePassword;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show Password'**
  String get showPassword;

  /// No description provided for @passwordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordEmpty;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNotMatch;

  /// No description provided for @userCreatedStories.
  ///
  /// In en, this message translates to:
  /// **'User Created Stories'**
  String get userCreatedStories;

  /// No description provided for @yourStories.
  ///
  /// In en, this message translates to:
  /// **'Your Stories'**
  String get yourStories;

  /// No description provided for @userNoStories.
  ///
  /// In en, this message translates to:
  /// **'User has not created any story'**
  String get userNoStories;

  /// No description provided for @youNoStories.
  ///
  /// In en, this message translates to:
  /// **'You have not created any story'**
  String get youNoStories;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @userLikedStories.
  ///
  /// In en, this message translates to:
  /// **'User Liked Stories'**
  String get userLikedStories;

  /// No description provided for @yourLikedStories.
  ///
  /// In en, this message translates to:
  /// **'Your Liked Stories'**
  String get yourLikedStories;

  /// No description provided for @userNoLikedStories.
  ///
  /// In en, this message translates to:
  /// **'User has not liked any story'**
  String get userNoLikedStories;

  /// No description provided for @youNoLikedStories.
  ///
  /// In en, this message translates to:
  /// **'You have not liked any story'**
  String get youNoLikedStories;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// Message when no room or upcoming room is available
  ///
  /// In en, this message translates to:
  /// **'{isRoom, select, true{No Room Available} false{No Upcoming Room Available} other{No Room Information Available}}\nGet Started By Adding One Below!'**
  String noAvailableRoom(String isRoom);

  /// No description provided for @user1.
  ///
  /// In en, this message translates to:
  /// **'User 1'**
  String get user1;

  /// No description provided for @user2.
  ///
  /// In en, this message translates to:
  /// **'User 2'**
  String get user2;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'You are logging out of Resonate.'**
  String get loggingOut;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @incorrectEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get incorrectEmailOrPassword;

  /// No description provided for @passwordShort.
  ///
  /// In en, this message translates to:
  /// **'Password is less than 8 characters'**
  String get passwordShort;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again!'**
  String get tryAgain;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent!'**
  String get passwordResetSent;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// No description provided for @emailChanged.
  ///
  /// In en, this message translates to:
  /// **'Email Changed'**
  String get emailChanged;

  /// No description provided for @emailChangeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email changed successfully!'**
  String get emailChangeSuccess;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @emailChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to change email'**
  String get emailChangeFailed;

  /// No description provided for @oops.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get oops;

  /// No description provided for @emailExists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists'**
  String get emailExists;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @newEmail.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get newEmail;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @emailChangeInfo.
  ///
  /// In en, this message translates to:
  /// **'For added security, you must provide your account\'s current password when changing your email address. After changing your email, use the updated email for future logins.'**
  String get emailChangeInfo;

  /// No description provided for @oauthUsersMessage.
  ///
  /// In en, this message translates to:
  /// **'(Only for users who logged in using Google or Github)'**
  String get oauthUsersMessage;

  /// No description provided for @oauthUsersEmailChangeInfo.
  ///
  /// In en, this message translates to:
  /// **'To change your email, please enter a new password in the \"Current Password\" field. Be sure to remember this password, as you\'ll need it for any future email changes. Moving forward, you can log in using Google/GitHub or your new email and password combination.'**
  String get oauthUsersEmailChangeInfo;

  /// No description provided for @resonateTagline.
  ///
  /// In en, this message translates to:
  /// **'Enter a world of limitless\nconversations.'**
  String get resonateTagline;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Email'**
  String get signInWithEmail;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue with'**
  String get continueWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithGitHub.
  ///
  /// In en, this message translates to:
  /// **'Continue with GitHub'**
  String get continueWithGitHub;

  /// No description provided for @resonateLogo.
  ///
  /// In en, this message translates to:
  /// **'Resonate Logo'**
  String get resonateLogo;

  /// No description provided for @iAlreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get iAlreadyHaveAnAccount;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get createNewAccount;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User profile'**
  String get userProfile;

  /// No description provided for @passwordIsStrong.
  ///
  /// In en, this message translates to:
  /// **'Password is strong'**
  String get passwordIsStrong;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @moderator.
  ///
  /// In en, this message translates to:
  /// **'Moderator'**
  String get moderator;

  /// No description provided for @speaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get speaker;

  /// No description provided for @listener.
  ///
  /// In en, this message translates to:
  /// **'Listener'**
  String get listener;

  /// No description provided for @removeModerator.
  ///
  /// In en, this message translates to:
  /// **'Remove Moderator'**
  String get removeModerator;

  /// No description provided for @kickOut.
  ///
  /// In en, this message translates to:
  /// **'Kick Out'**
  String get kickOut;

  /// No description provided for @addModerator.
  ///
  /// In en, this message translates to:
  /// **'Add Moderator'**
  String get addModerator;

  /// No description provided for @addSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Add Speaker'**
  String get addSpeaker;

  /// No description provided for @makeListener.
  ///
  /// In en, this message translates to:
  /// **'Make Listener'**
  String get makeListener;

  /// No description provided for @pairChat.
  ///
  /// In en, this message translates to:
  /// **'Pair Chat'**
  String get pairChat;

  /// No description provided for @chooseIdentity.
  ///
  /// In en, this message translates to:
  /// **'Choose Identity'**
  String get chooseIdentity;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @noConnection.
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get noConnection;

  /// No description provided for @loadingDialog.
  ///
  /// In en, this message translates to:
  /// **'Loading Dialog'**
  String get loadingDialog;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @enterValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Valid Email Address'**
  String get enterValidEmailAddress;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordRequirements;

  /// No description provided for @includeNumericDigit.
  ///
  /// In en, this message translates to:
  /// **'Include at least 1 numeric digit'**
  String get includeNumericDigit;

  /// No description provided for @includeUppercase.
  ///
  /// In en, this message translates to:
  /// **'Include at least 1 uppercase letter'**
  String get includeUppercase;

  /// No description provided for @includeLowercase.
  ///
  /// In en, this message translates to:
  /// **'Include at least 1 lowercase letter'**
  String get includeLowercase;

  /// No description provided for @includeSymbol.
  ///
  /// In en, this message translates to:
  /// **'Include at least 1 symbol'**
  String get includeSymbol;

  /// No description provided for @signedUpSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Signed Up Successfully'**
  String get signedUpSuccessfully;

  /// No description provided for @newAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'You have successfully created a new account'**
  String get newAccountCreated;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get accountSettings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get appSettings;

  /// No description provided for @themes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contribute;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'leave'**
  String get leave;

  /// No description provided for @leaveButton.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveButton;

  /// No description provided for @findingRandomPartner.
  ///
  /// In en, this message translates to:
  /// **'Finding a Random Partner For You'**
  String get findingRandomPartner;

  /// No description provided for @quickFact.
  ///
  /// In en, this message translates to:
  /// **'Quick fact'**
  String get quickFact;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete your Profile'**
  String get completeYourProfile;

  /// No description provided for @uploadProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Upload profile picture'**
  String get uploadProfilePicture;

  /// No description provided for @enterValidName.
  ///
  /// In en, this message translates to:
  /// **'Enter Valid Name'**
  String get enterValidName;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterValidDOB.
  ///
  /// In en, this message translates to:
  /// **'Enter Valid DOB'**
  String get enterValidDOB;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noStoriesExist.
  ///
  /// In en, this message translates to:
  /// **'No stories exist to present'**
  String get noStoriesExist;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your\nVerification Code'**
  String get enterVerificationCode;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit verification code to\n'**
  String get verificationCodeSent;

  /// No description provided for @verificationComplete.
  ///
  /// In en, this message translates to:
  /// **'Verification Complete'**
  String get verificationComplete;

  /// No description provided for @verificationCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Congratulations you have verified your Email'**
  String get verificationCompleteMessage;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification Failed'**
  String get verificationFailed;

  /// No description provided for @otpMismatch.
  ///
  /// In en, this message translates to:
  /// **'OTP mismatch occurred please try again'**
  String get otpMismatch;

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'OTP resent'**
  String get otpResent;

  /// No description provided for @requestNewCode.
  ///
  /// In en, this message translates to:
  /// **'Request a new code'**
  String get requestNewCode;

  /// No description provided for @requestNewCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Request a new code in'**
  String get requestNewCodeIn;

  /// No description provided for @clickPictureCamera.
  ///
  /// In en, this message translates to:
  /// **'Click picture using camera'**
  String get clickPictureCamera;

  /// No description provided for @pickImageGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick image from gallery'**
  String get pickImageGallery;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteMyAccount;

  /// No description provided for @createNewRoom.
  ///
  /// In en, this message translates to:
  /// **'Create New Room'**
  String get createNewRoom;

  /// No description provided for @pleaseEnterScheduledDateTime.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Scheduled Date-Time'**
  String get pleaseEnterScheduledDateTime;

  /// No description provided for @scheduleDateTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Schedule Date Time'**
  String get scheduleDateTimeLabel;

  /// No description provided for @enterTags.
  ///
  /// In en, this message translates to:
  /// **'Enter tags'**
  String get enterTags;

  /// No description provided for @joinCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join Community'**
  String get joinCommunity;

  /// No description provided for @followUsOnX.
  ///
  /// In en, this message translates to:
  /// **'Follow us on X'**
  String get followUsOnX;

  /// No description provided for @joinDiscordServer.
  ///
  /// In en, this message translates to:
  /// **'Join discord server'**
  String get joinDiscordServer;

  /// No description provided for @noLyrics.
  ///
  /// In en, this message translates to:
  /// **'No lyrics'**
  String get noLyrics;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// Message when no stories exist in a category
  ///
  /// In en, this message translates to:
  /// **'No stories currently exist in the {categoryName} category to present'**
  String noStoriesInCategory(String categoryName);

  /// No description provided for @pushNewChapters.
  ///
  /// In en, this message translates to:
  /// **'Push New Chapters'**
  String get pushNewChapters;

  /// No description provided for @helpToGrow.
  ///
  /// In en, this message translates to:
  /// **'Help to grow'**
  String get helpToGrow;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @aboutResonate.
  ///
  /// In en, this message translates to:
  /// **'About Resonate'**
  String get aboutResonate;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @classic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get classic;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @vintage.
  ///
  /// In en, this message translates to:
  /// **'Vintage'**
  String get vintage;

  /// No description provided for @amber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get amber;

  /// No description provided for @forest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forest;

  /// No description provided for @cream.
  ///
  /// In en, this message translates to:
  /// **'Cream'**
  String get cream;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get none;

  /// Share message for GitHub repository
  ///
  /// In en, this message translates to:
  /// **'Check out our GitHub repository: {url}'**
  String checkOutGitHub(String url);

  /// No description provided for @aossie.
  ///
  /// In en, this message translates to:
  /// **'AOSSIE'**
  String get aossie;

  /// No description provided for @aossieLogo.
  ///
  /// In en, this message translates to:
  /// **'aossie logo'**
  String get aossieLogo;

  /// No description provided for @errorLoadPackageInfo.
  ///
  /// In en, this message translates to:
  /// **'Could not load package info'**
  String get errorLoadPackageInfo;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailable;

  /// No description provided for @newVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'A new version is available!'**
  String get newVersionAvailable;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to Date'**
  String get upToDate;

  /// No description provided for @latestVersion.
  ///
  /// In en, this message translates to:
  /// **'You\'re using the latest version'**
  String get latestVersion;

  /// No description provided for @profileCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile created successfully'**
  String get profileCreatedSuccessfully;

  /// No description provided for @invalidScheduledDateTime.
  ///
  /// In en, this message translates to:
  /// **'Invalid Scheduled Date Time'**
  String get invalidScheduledDateTime;

  /// No description provided for @scheduledDateTimePast.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Date Time cannot be in past'**
  String get scheduledDateTimePast;

  /// No description provided for @joinRoom.
  ///
  /// In en, this message translates to:
  /// **'Join Room'**
  String get joinRoom;

  /// No description provided for @loadingDialogName.
  ///
  /// In en, this message translates to:
  /// **'Loading Dialog'**
  String get loadingDialogName;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownUser;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'canceled'**
  String get canceled;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get english;

  /// No description provided for @emailVerificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Email Verification Required'**
  String get emailVerificationRequired;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @audioRoom.
  ///
  /// In en, this message translates to:
  /// **'Audio Room'**
  String get audioRoom;

  /// Room action message
  ///
  /// In en, this message translates to:
  /// **'To {action} the room'**
  String toRoomAction(String action);

  /// No description provided for @mailSentMessage.
  ///
  /// In en, this message translates to:
  /// **'mail sent'**
  String get mailSentMessage;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'disconnected'**
  String get disconnected;

  /// No description provided for @micOn.
  ///
  /// In en, this message translates to:
  /// **'mic'**
  String get micOn;

  /// No description provided for @speakerOn.
  ///
  /// In en, this message translates to:
  /// **'speaker'**
  String get speakerOn;

  /// No description provided for @endChat.
  ///
  /// In en, this message translates to:
  /// **'end-chat'**
  String get endChat;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthDec;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @newToResonate.
  ///
  /// In en, this message translates to:
  /// **'New to Resonate? '**
  String get newToResonate;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checking;

  /// No description provided for @forgotPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address to reset your password.'**
  String get forgotPasswordMessage;

  /// No description provided for @usernameUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Username Unavailable!'**
  String get usernameUnavailable;

  /// No description provided for @usernameInvalidOrTaken.
  ///
  /// In en, this message translates to:
  /// **'This username is invalid or either taken already.'**
  String get usernameInvalidOrTaken;

  /// No description provided for @otpResentMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your mail for a new OTP.'**
  String get otpResentMessage;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'There is a connection error. Please check your internet and try again.'**
  String get connectionError;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds.'**
  String get seconds;

  /// No description provided for @unsavedChangesWarning.
  ///
  /// In en, this message translates to:
  /// **'If you proceed without saving, any unsaved changes will be lost.'**
  String get unsavedChangesWarning;

  /// No description provided for @deleteAccountPermanent.
  ///
  /// In en, this message translates to:
  /// **'This action will Delete Your Account Permanently. It is irreversible process. We will delete your username, email address, and all other data associated with your account. You will not be able to recover it.'**
  String get deleteAccountPermanent;

  /// No description provided for @giveGreatName.
  ///
  /// In en, this message translates to:
  /// **'Give a great name..'**
  String get giveGreatName;

  /// No description provided for @joinCommunityDescription.
  ///
  /// In en, this message translates to:
  /// **'By joining community you can Clear your doubts, Suggest for new features, Report issues you faced and More.'**
  String get joinCommunityDescription;

  /// No description provided for @resonateDescription.
  ///
  /// In en, this message translates to:
  /// **'Resonate is a social media platform, where every voice is valued. Share your thoughts, stories, and experiences with others. Start your audio journey now. Dive into diverse discussions and topics. Find rooms that resonate with you and become a part of the community. Join the conversation! Explore rooms, connect with friends, and share your voice with the world.'**
  String get resonateDescription;

  /// No description provided for @resonateFullDescription.
  ///
  /// In en, this message translates to:
  /// **'Resonate is a revolutionary voice-based social media platform where every voice matters. \nJoin real-time audio conversations, participate in diverse discussions, and connect with \nlike-minded individuals. Our platform offers:\n- Live audio rooms with topic-based discussions\n- Seamless social networking through voice\n- Community-driven content moderation\n- Cross-platform compatibility\n- End-to-end encrypted private conversations\n\nDeveloped by the AOSSIE open source community, we prioritize user privacy and \ncommunity-driven development. Join us in shaping the future of social audio!'**
  String get resonateFullDescription;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @congratulationsEmailVerified.
  ///
  /// In en, this message translates to:
  /// **'Congratulations you have verified your Email'**
  String get congratulationsEmailVerified;

  /// No description provided for @otpMismatchError.
  ///
  /// In en, this message translates to:
  /// **'OTP mismatch occurred please try again'**
  String get otpMismatchError;

  /// No description provided for @usernameCharacterLimit.
  ///
  /// In en, this message translates to:
  /// **'Username should contain more than 5 characters.'**
  String get usernameCharacterLimit;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @resonate.
  ///
  /// In en, this message translates to:
  /// **'Resonate'**
  String get resonate;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No Search Results'**
  String get noSearchResults;

  /// Message to share room information
  ///
  /// In en, this message translates to:
  /// **'🚀 Check out this amazing room: {roomName}!\n\n📖 Description: {description}\n👥 Join {participants} participants now!'**
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  );

  /// Number of participants in a room
  ///
  /// In en, this message translates to:
  /// **'{count} Participants'**
  String participantsCount(int count);

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @invalidTags.
  ///
  /// In en, this message translates to:
  /// **'Invalid Tag:'**
  String get invalidTags;

  /// No description provided for @cropImage.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get cropImage;

  /// No description provided for @profileSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileSavedSuccessfully;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'All changes are saved successfully.'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @profileUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Profile up to date'**
  String get profileUpToDate;

  /// No description provided for @noChangesToSave.
  ///
  /// In en, this message translates to:
  /// **'There are no new changes made, Nothing to save.'**
  String get noChangesToSave;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection Failed'**
  String get connectionFailed;

  /// No description provided for @unableToJoinRoom.
  ///
  /// In en, this message translates to:
  /// **'Unable to join the room. Please check your network and try again.'**
  String get unableToJoinRoom;

  /// No description provided for @connectionLost.
  ///
  /// In en, this message translates to:
  /// **'Connection Lost'**
  String get connectionLost;

  /// No description provided for @unableToReconnect.
  ///
  /// In en, this message translates to:
  /// **'Unable to reconnect to the room. Please try rejoining.'**
  String get unableToReconnect;

  /// No description provided for @invalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid Format!'**
  String get invalidFormat;

  /// No description provided for @usernameAlphanumeric.
  ///
  /// In en, this message translates to:
  /// **'Username must be alphanumeric and should not contain special characters.'**
  String get usernameAlphanumeric;

  /// No description provided for @userProfileCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your user profile is successfully created.'**
  String get userProfileCreatedSuccessfully;

  /// No description provided for @emailVerificationMessage.
  ///
  /// In en, this message translates to:
  /// **'To proceed, verify your email address.'**
  String get emailVerificationMessage;

  /// Title for adding new chapters to a story
  ///
  /// In en, this message translates to:
  /// **'Add New Chapters to {storyName}'**
  String addNewChaptersToStory(String storyName);

  /// No description provided for @currentChapters.
  ///
  /// In en, this message translates to:
  /// **'Current Chapters'**
  String get currentChapters;

  /// No description provided for @newChapters.
  ///
  /// In en, this message translates to:
  /// **'New Chapters'**
  String get newChapters;

  /// No description provided for @sourceCodeOnGitHub.
  ///
  /// In en, this message translates to:
  /// **'Source code on GitHub'**
  String get sourceCodeOnGitHub;

  /// No description provided for @createAChapter.
  ///
  /// In en, this message translates to:
  /// **'Create a Chapter'**
  String get createAChapter;

  /// No description provided for @chapterTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapter Title *'**
  String get chapterTitle;

  /// No description provided for @aboutRequired.
  ///
  /// In en, this message translates to:
  /// **'About *'**
  String get aboutRequired;

  /// No description provided for @changeCoverImage.
  ///
  /// In en, this message translates to:
  /// **'Change Cover Image'**
  String get changeCoverImage;

  /// No description provided for @uploadAudioFile.
  ///
  /// In en, this message translates to:
  /// **'Upload Audio File'**
  String get uploadAudioFile;

  /// No description provided for @uploadLyricsFile.
  ///
  /// In en, this message translates to:
  /// **'Upload Lyrics File'**
  String get uploadLyricsFile;

  /// No description provided for @createChapter.
  ///
  /// In en, this message translates to:
  /// **'Create Chapter'**
  String get createChapter;

  /// Message when audio file is selected
  ///
  /// In en, this message translates to:
  /// **'Audio file Selected: {fileName}'**
  String audioFileSelected(String fileName);

  /// Message when lyrics file is selected
  ///
  /// In en, this message translates to:
  /// **'Lyrics File Selected: {fileName}'**
  String lyricsFileSelected(String fileName);

  /// No description provided for @fillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields and upload your Audio file and Lyrics file'**
  String get fillAllRequiredFields;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @roomDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Room Description (optional)'**
  String get roomDescriptionOptional;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @createYourStory.
  ///
  /// In en, this message translates to:
  /// **'Create Your Story'**
  String get createYourStory;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get titleRequired;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category *'**
  String get category;

  /// No description provided for @addChapter.
  ///
  /// In en, this message translates to:
  /// **'Add Chapter'**
  String get addChapter;

  /// No description provided for @createStory.
  ///
  /// In en, this message translates to:
  /// **'Create Story'**
  String get createStory;

  /// No description provided for @fillAllRequiredFieldsAndChapter.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields, add at least one chapter, and select a cover image.'**
  String get fillAllRequiredFieldsAndChapter;

  /// No description provided for @toConfirmType.
  ///
  /// In en, this message translates to:
  /// **'To confirm, type'**
  String get toConfirmType;

  /// No description provided for @inTheBoxBelow.
  ///
  /// In en, this message translates to:
  /// **'in the box below'**
  String get inTheBoxBelow;

  /// No description provided for @iUnderstandDeleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'I understand, Delete My Account'**
  String get iUnderstandDeleteMyAccount;

  /// No description provided for @whatDoYouWantToListenTo.
  ///
  /// In en, this message translates to:
  /// **'What do you want to listen to?'**
  String get whatDoYouWantToListenTo;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @stories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get stories;

  /// No description provided for @someSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Some Suggestions'**
  String get someSuggestions;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @welcomeToResonate.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Resonate'**
  String get welcomeToResonate;

  /// No description provided for @exploreDiverseConversations.
  ///
  /// In en, this message translates to:
  /// **'Explore Diverse Conversations'**
  String get exploreDiverseConversations;

  /// No description provided for @yourVoiceMatters.
  ///
  /// In en, this message translates to:
  /// **'Your Voice Matters'**
  String get yourVoiceMatters;

  /// No description provided for @joinConversationExploreRooms.
  ///
  /// In en, this message translates to:
  /// **'Join the conversation! Explore rooms, connect with friends, and share your voice with the world.'**
  String get joinConversationExploreRooms;

  /// No description provided for @diveIntoDiverseDiscussions.
  ///
  /// In en, this message translates to:
  /// **'Dive into diverse discussions and topics. \nFind rooms that resonate with you and become a part of the community.'**
  String get diveIntoDiverseDiscussions;

  /// No description provided for @atResonateEveryVoiceValued.
  ///
  /// In en, this message translates to:
  /// **'At Resonate, every voice is valued. Share your thoughts, stories, and experiences with others. Start your audio journey now.'**
  String get atResonateEveryVoiceValued;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notification message when tagged in upcoming room
  ///
  /// In en, this message translates to:
  /// **'{username} tagged you in an upcoming room: {subject}'**
  String taggedYouInUpcomingRoom(String username, String subject);

  /// Notification message when tagged in room
  ///
  /// In en, this message translates to:
  /// **'{username} tagged you in room: {subject}'**
  String taggedYouInRoom(String username, String subject);

  /// Notification message when someone likes your story
  ///
  /// In en, this message translates to:
  /// **'{username} liked your story: {subject}'**
  String likedYourStory(String username, String subject);

  /// Notification message when someone subscribes to your room
  ///
  /// In en, this message translates to:
  /// **'{username} subscribed to your room: {subject}'**
  String subscribedToYourRoom(String username, String subject);

  /// Notification message when someone starts following you
  ///
  /// In en, this message translates to:
  /// **'{username} started following you'**
  String startedFollowingYou(String username);

  /// No description provided for @youHaveNewNotification.
  ///
  /// In en, this message translates to:
  /// **'You have a new notification'**
  String get youHaveNewNotification;

  /// No description provided for @hangOnGoodThingsTakeTime.
  ///
  /// In en, this message translates to:
  /// **'Hang on, Good Things take time 🔍'**
  String get hangOnGoodThingsTakeTime;

  /// No description provided for @resonateOpenSourceProject.
  ///
  /// In en, this message translates to:
  /// **'Resonate is an open source project maintained by AOSSIE. Checkout our github to contribute.'**
  String get resonateOpenSourceProject;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @speakerLabel.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get speakerLabel;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'DISCARD'**
  String get discard;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get save;

  /// No description provided for @changeProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Change profile picture'**
  String get changeProfilePicture;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Story creation date
  ///
  /// In en, this message translates to:
  /// **'Created {date}'**
  String created(String date);

  /// No description provided for @aboutStory.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutStory;

  /// No description provided for @chapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// No description provided for @deleteStory.
  ///
  /// In en, this message translates to:
  /// **'Delete Story'**
  String get deleteStory;

  /// Story creator information
  ///
  /// In en, this message translates to:
  /// **'Created by {creatorName}'**
  String createdBy(String creatorName);

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @unsubscribe.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get unsubscribe;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// Choose the category for Story
  ///
  /// In en, this message translates to:
  /// **'{category, select, drama{Drama} comedy{Comedy} horror{Horror} romance{Romance} thriller{Thriller} spiritual{Spiritual} other{Other}}'**
  String storyCategory(String category);

  /// Choose the theme for the app
  ///
  /// In en, this message translates to:
  /// **'{category, select, classicTheme{Classic} timeTheme{Time} vintageTheme{Vintage} amberTheme{Amber} forestTheme{Forest} creamTheme{Cream} other{Other}}'**
  String chooseTheme(String category);

  /// Time format for minutes ago
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String minutesAgo(int count);

  /// Time format for hours ago
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String hoursAgo(int count);

  /// Time format for days ago
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @lengthMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get lengthMinutes;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @clickPictureUsingCamera.
  ///
  /// In en, this message translates to:
  /// **'Click picture using camera'**
  String get clickPictureUsingCamera;

  /// No description provided for @pickImageFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick image from gallery'**
  String get pickImageFromGallery;

  /// No description provided for @onlineUsers.
  ///
  /// In en, this message translates to:
  /// **'Online Users'**
  String get onlineUsers;

  /// No description provided for @noOnlineUsers.
  ///
  /// In en, this message translates to:
  /// **'No users currently online'**
  String get noOnlineUsers;

  /// No description provided for @chooseUser.
  ///
  /// In en, this message translates to:
  /// **'Choose User to chat with'**
  String get chooseUser;

  /// No description provided for @quickMatch.
  ///
  /// In en, this message translates to:
  /// **'Quick Match'**
  String get quickMatch;

  /// No description provided for @story.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get story;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @friendRequests.
  ///
  /// In en, this message translates to:
  /// **'Friend Requests'**
  String get friendRequests;

  /// No description provided for @friendRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent'**
  String get friendRequestSent;

  /// Message when a friend request is sent to a user
  ///
  /// In en, this message translates to:
  /// **'Your friend request to {username} has been sent.'**
  String friendRequestSentTo(String username);

  /// No description provided for @friendRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Friend request cancelled'**
  String get friendRequestCancelled;

  /// Message when a friend request is cancelled
  ///
  /// In en, this message translates to:
  /// **'Your friend request to {username} has been cancelled.'**
  String friendRequestCancelledTo(String username);

  /// No description provided for @requested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requested;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// No description provided for @friendRequestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Friend request accepted'**
  String get friendRequestAccepted;

  /// Message when a friend request is accepted
  ///
  /// In en, this message translates to:
  /// **'You are now friends with \${username}.'**
  String friendRequestAcceptedTo(String username);

  /// No description provided for @friendRequestDeclined.
  ///
  /// In en, this message translates to:
  /// **'Friend request declined'**
  String get friendRequestDeclined;

  /// Message when a friend request is declined
  ///
  /// In en, this message translates to:
  /// **'You have declined the friend request from \${username}.'**
  String friendRequestDeclinedTo(String username);

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @callDeclined.
  ///
  /// In en, this message translates to:
  /// **'Call declined'**
  String get callDeclined;

  /// Message when a call is declined
  ///
  /// In en, this message translates to:
  /// **'User \${username} declined the call.'**
  String callDeclinedTo(String username);

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check Updates'**
  String get checkForUpdates;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @updateSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Update Successful'**
  String get updateSuccessful;

  /// No description provided for @updateSuccessfulMessage.
  ///
  /// In en, this message translates to:
  /// **'Resonate has been updated successfully!'**
  String get updateSuccessfulMessage;

  /// No description provided for @updateCancelled.
  ///
  /// In en, this message translates to:
  /// **'Update Cancelled'**
  String get updateCancelled;

  /// No description provided for @updateCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'Update was cancelled by user'**
  String get updateCancelledMessage;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update Failed'**
  String get updateFailed;

  /// No description provided for @updateFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update. Please try updating from Play Store manually.'**
  String get updateFailedMessage;

  /// No description provided for @updateError.
  ///
  /// In en, this message translates to:
  /// **'Update Error'**
  String get updateError;

  /// No description provided for @updateErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while updating. Please try again.'**
  String get updateErrorMessage;

  /// No description provided for @platformNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Platform Not Supported'**
  String get platformNotSupported;

  /// No description provided for @platformNotSupportedMessage.
  ///
  /// In en, this message translates to:
  /// **'Update checking is only available on Android devices'**
  String get platformNotSupportedMessage;

  /// No description provided for @updateCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Update Check Failed'**
  String get updateCheckFailed;

  /// No description provided for @updateCheckFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not check for updates. Please try again later.'**
  String get updateCheckFailedMessage;

  /// No description provided for @upToDateTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re Up to Date!'**
  String get upToDateTitle;

  /// No description provided for @upToDateMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re using the latest version of Resonate'**
  String get upToDateMessage;

  /// No description provided for @updateAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Available!'**
  String get updateAvailableTitle;

  /// No description provided for @updateAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'A new version of Resonate is available on Play Store'**
  String get updateAvailableMessage;

  /// No description provided for @updateFeaturesImprovement.
  ///
  /// In en, this message translates to:
  /// **'Get the latest features and improvements!'**
  String get updateFeaturesImprovement;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
