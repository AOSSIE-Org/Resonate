import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';

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
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
  ];

  /// The title of the application.
  ///
  /// In en, this message translates to:
  /// **'Resonate'**
  String get title;

  /// Guideline message for users in a chat room.
  ///
  /// In en, this message translates to:
  /// **'Be polite and respect the other person\'s opinion. Avoid rude comments.'**
  String get roomDescription;

  /// Button text to conceal the password field.
  ///
  /// In en, this message translates to:
  /// **'Hide Password'**
  String get hidePassword;

  /// Button text to reveal the password field.
  ///
  /// In en, this message translates to:
  /// **'Show Password'**
  String get showPassword;

  /// Error message when the password field is left blank.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordEmpty;

  /// Label for the password input field.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label for the confirm password input field.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Error message when password and confirmation password do not match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNotMatch;

  /// Header for the section showing stories created by another user.
  ///
  /// In en, this message translates to:
  /// **'User Created Stories'**
  String get userCreatedStories;

  /// Header for the section showing stories created by the current user.
  ///
  /// In en, this message translates to:
  /// **'Your Stories'**
  String get yourStories;

  /// Message displayed when viewing another user's profile and they have no stories.
  ///
  /// In en, this message translates to:
  /// **'User has not created any story'**
  String get userNoStories;

  /// Message displayed on the current user's profile when they have no stories.
  ///
  /// In en, this message translates to:
  /// **'You have not created any story'**
  String get youNoStories;

  /// Button text to follow a user.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// Button text to navigate to the profile editing screen.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Button or link text to start the email verification process.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// A status label indicating that the user's email has been verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// Label for the user profile section or page.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Header for the section showing stories liked by another user.
  ///
  /// In en, this message translates to:
  /// **'User Liked Stories'**
  String get userLikedStories;

  /// Header for the section showing stories liked by the current user.
  ///
  /// In en, this message translates to:
  /// **'Your Liked Stories'**
  String get yourLikedStories;

  /// Message displayed when viewing another user's profile and they have no liked stories.
  ///
  /// In en, this message translates to:
  /// **'User has not liked any story'**
  String get userNoLikedStories;

  /// Message displayed on the current user's profile when they have no liked stories.
  ///
  /// In en, this message translates to:
  /// **'You have not liked any story'**
  String get youNoLikedStories;

  /// Tab or label for live audio rooms.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// Tab or label for scheduled/upcoming audio rooms.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// Message when no room or upcoming room is available, with a call to action.
  ///
  /// In en, this message translates to:
  /// **'{isRoom, select, true{No Room Available} false{No Upcoming Room Available} other{No Room Information Available}}\nGet Started By Adding One Below!'**
  String noAvailableRoom(String isRoom);

  /// A generic placeholder name for a user.
  ///
  /// In en, this message translates to:
  /// **'User 1'**
  String get user1;

  /// A second generic placeholder name for a user.
  ///
  /// In en, this message translates to:
  /// **'User 2'**
  String get user2;

  /// Label to identify the current user in a list or chat.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// Confirmation prompt title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// Confirmation prompt message for logging out.
  ///
  /// In en, this message translates to:
  /// **'You are logging out of Resonate.'**
  String get loggingOut;

  /// Generic confirmation button text.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Generic cancellation button text.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Error message for failed login attempt.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get incorrectEmailOrPassword;

  /// Error message for a password that is too short.
  ///
  /// In en, this message translates to:
  /// **'Password is less than 8 characters'**
  String get passwordShort;

  /// Button text to retry a failed action.
  ///
  /// In en, this message translates to:
  /// **'Try Again!'**
  String get tryAgain;

  /// Generic title for a successful operation.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Success message after a password reset email has been dispatched.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent!'**
  String get passwordResetSent;

  /// Generic title for a failed operation.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Title or button text for the reset password feature.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Instructional text on the reset password screen.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPassword;

  /// Label for the new password input field.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Button text to confirm setting a new password.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// Title for the success dialog after an email change.
  ///
  /// In en, this message translates to:
  /// **'Email Changed'**
  String get emailChanged;

  /// Success message after changing the user's email.
  ///
  /// In en, this message translates to:
  /// **'Email changed successfully!'**
  String get emailChangeSuccess;

  /// Generic title for a failed operation.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// Error message when an email change operation fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to change email'**
  String get emailChangeFailed;

  /// An informal title for an error or warning message.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get oops;

  /// Error message when a user tries to register or change to an email that is already in use.
  ///
  /// In en, this message translates to:
  /// **'Email already exists'**
  String get emailExists;

  /// Title or button text for the change email feature.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// Error message for an invalid email format.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get enterValidEmail;

  /// Label for the new email input field.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get newEmail;

  /// Label for the current password input field, used for verification.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// Informational text explaining the process and security requirements for changing an email address for standard users.
  ///
  /// In en, this message translates to:
  /// **'For added security, you must provide your account\'s current password when changing your email address. After changing your email, use the updated email for future logins.'**
  String get emailChangeInfo;

  /// A message to specify that the following instructions are for OAuth users.
  ///
  /// In en, this message translates to:
  /// **'(Only for users who logged in using Google or Github)'**
  String get oauthUsersMessage;

  /// Informational text explaining how users who signed up via Google or GitHub can change their email by setting a new password.
  ///
  /// In en, this message translates to:
  /// **'To change your email, please enter a new password in the \"Current Password\" field. Be sure to remember this password, as you\'ll need it for any future email changes. Moving forward, you can log in using Google/GitHub or your new email and password combination.'**
  String get oauthUsersEmailChangeInfo;

  /// The application's tagline, used on splash or login screens.
  ///
  /// In en, this message translates to:
  /// **'Enter a world of limitless\nconversations.'**
  String get resonateTagline;

  /// Button text for signing in using email and password.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Email'**
  String get signInWithEmail;

  /// A separator text, typically used between different login options.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// Informational text preceding a list of third-party login providers.
  ///
  /// In en, this message translates to:
  /// **'Continue with'**
  String get continueWith;

  /// Button text for signing in with a Google account.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Button text for signing in with a GitHub account.
  ///
  /// In en, this message translates to:
  /// **'Continue with GitHub'**
  String get continueWithGitHub;

  /// Accessibility text for the Resonate application logo image.
  ///
  /// In en, this message translates to:
  /// **'Resonate Logo'**
  String get resonateLogo;

  /// Text for a link or button to navigate to the login screen from the sign-up screen.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get iAlreadyHaveAnAccount;

  /// Text for a link or button to navigate to the sign-up screen from the login screen.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get createNewAccount;

  /// Accessibility text for a user's profile picture or avatar.
  ///
  /// In en, this message translates to:
  /// **'User profile'**
  String get userProfile;

  /// Validation message indicating that the entered password meets all strength requirements.
  ///
  /// In en, this message translates to:
  /// **'Password is strong'**
  String get passwordIsStrong;

  /// Label for the Admin user role in a room.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// Label for the Moderator user role in a room.
  ///
  /// In en, this message translates to:
  /// **'Moderator'**
  String get moderator;

  /// Label for the Speaker user role in a room.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get speaker;

  /// Label for the Listener user role in a room.
  ///
  /// In en, this message translates to:
  /// **'Listener'**
  String get listener;

  /// Menu item text to revoke moderator privileges from a user.
  ///
  /// In en, this message translates to:
  /// **'Remove Moderator'**
  String get removeModerator;

  /// Menu item text to remove a user from a room.
  ///
  /// In en, this message translates to:
  /// **'Kick Out'**
  String get kickOut;

  /// Menu item text to grant moderator privileges to a user.
  ///
  /// In en, this message translates to:
  /// **'Add Moderator'**
  String get addModerator;

  /// Menu item text to grant speaker privileges to a listener.
  ///
  /// In en, this message translates to:
  /// **'Add Speaker'**
  String get addSpeaker;

  /// Menu item text to change a speaker's role to listener.
  ///
  /// In en, this message translates to:
  /// **'Make Listener'**
  String get makeListener;

  /// A feature name for one-on-one random chat.
  ///
  /// In en, this message translates to:
  /// **'Pair Chat'**
  String get pairChat;

  /// Prompt for the user to choose their identity, e.g., anonymous or public.
  ///
  /// In en, this message translates to:
  /// **'Choose Identity'**
  String get chooseIdentity;

  /// Label for the language selection setting.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Title indicating that there is no internet connection.
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get noConnection;

  /// Accessibility text for a loading indicator or spinner.
  ///
  /// In en, this message translates to:
  /// **'Loading Dialog'**
  String get loadingDialog;

  /// Button text or page title for the account creation screen.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Error message shown for an invalid email format.
  ///
  /// In en, this message translates to:
  /// **'Enter Valid Email Address'**
  String get enterValidEmailAddress;

  /// Label for the email input field.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Instructional text listing the requirements for a valid password, part 1.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordRequirements;

  /// Instructional text listing the requirements for a valid password, part 2.
  ///
  /// In en, this message translates to:
  /// **'Include at least 1 numeric digit'**
  String get includeNumericDigit;

  /// Instructional text listing the requirements for a valid password, part 3.
  ///
  /// In en, this message translates to:
  /// **'Include at least 1 uppercase letter'**
  String get includeUppercase;

  /// Instructional text listing the requirements for a valid password, part 4.
  ///
  /// In en, this message translates to:
  /// **'Include at least 1 lowercase letter'**
  String get includeLowercase;

  /// Instructional text listing the requirements for a valid password, part 5.
  ///
  /// In en, this message translates to:
  /// **'Include at least 1 symbol'**
  String get includeSymbol;

  /// Title for a success message after account creation.
  ///
  /// In en, this message translates to:
  /// **'Signed Up Successfully'**
  String get signedUpSuccessfully;

  /// Success message confirming that a new account has been created.
  ///
  /// In en, this message translates to:
  /// **'You have successfully created a new account'**
  String get newAccountCreated;

  /// Button text to submit the sign-up form.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// Button text to submit the login form.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Title for the settings page.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Sub-header for account-related settings.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get accountSettings;

  /// Label for the account settings section.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Sub-header for application-related settings.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get appSettings;

  /// Label for the theme selection setting.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// Label for the 'About' section or page of the app or a story.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// A generic category label for miscellaneous settings or items.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Label for a section encouraging users to contribute to the project.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contribute;

  /// Label for the app preferences settings page.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// Section title for choosing AI transcription model.
  ///
  /// In en, this message translates to:
  /// **'Transcription Model'**
  String get transcriptionModel;

  /// Description text explaining transcription model choices.
  ///
  /// In en, this message translates to:
  /// **'Choose the AI model for voice transcription. Larger models are more accurate but slower and require more storage.'**
  String get transcriptionModelDescription;

  /// Name of the smallest Whisper AI model.
  ///
  /// In en, this message translates to:
  /// **'Tiny'**
  String get whisperModelTiny;

  /// Description of the Tiny Whisper model performance and size.
  ///
  /// In en, this message translates to:
  /// **'Fastest, least accurate (~39 MB)'**
  String get whisperModelTinyDescription;

  /// Name of the base Whisper AI model.
  ///
  /// In en, this message translates to:
  /// **'Base'**
  String get whisperModelBase;

  /// Description of the Base Whisper model performance and size.
  ///
  /// In en, this message translates to:
  /// **'Balanced speed and accuracy (~74 MB)'**
  String get whisperModelBaseDescription;

  /// Name of the small Whisper AI model.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get whisperModelSmall;

  /// Description of the Small Whisper model performance and size.
  ///
  /// In en, this message translates to:
  /// **'Good accuracy, slower (~244 MB)'**
  String get whisperModelSmallDescription;

  /// Name of the medium Whisper AI model.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get whisperModelMedium;

  /// Description of the Medium Whisper model performance and size.
  ///
  /// In en, this message translates to:
  /// **'High accuracy, slower (~769 MB)'**
  String get whisperModelMediumDescription;

  /// Name of the large V1 Whisper AI model.
  ///
  /// In en, this message translates to:
  /// **'Large V1'**
  String get whisperModelLargeV1;

  /// Description of the Large V1 Whisper model performance and size.
  ///
  /// In en, this message translates to:
  /// **'Most accurate, slowest (~1.55 GB)'**
  String get whisperModelLargeV1Description;

  /// Name of the large V2 Whisper AI model.
  ///
  /// In en, this message translates to:
  /// **'Large V2'**
  String get whisperModelLargeV2;

  /// Description of the Large V2 Whisper model performance and size.
  ///
  /// In en, this message translates to:
  /// **'Improved large model with higher accuracy (~1.55 GB)'**
  String get whisperModelLargeV2Description;

  /// Information message about model download.
  ///
  /// In en, this message translates to:
  /// **'Models are downloaded when first used. We recommend using Base, Small, or Medium. Large models require very high-end devices.'**
  String get modelDownloadInfo;

  /// Button text to log the user out of their account.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// Label or title for the list of participants in a room.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// Generic button text for a delete action. Parameter for toRoomAction.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// Generic button text for a leave action. Parameter for toRoomAction.
  ///
  /// In en, this message translates to:
  /// **'leave'**
  String get leave;

  /// Button text to leave a room or conversation.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveButton;

  /// Status message shown while the system is searching for a random chat partner.
  ///
  /// In en, this message translates to:
  /// **'Finding a Random Partner For You'**
  String get findingRandomPartner;

  /// Header for a quick fact or tip, often shown during loading.
  ///
  /// In en, this message translates to:
  /// **'Quick fact'**
  String get quickFact;

  /// Generic button text for a cancel action.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button text to remove an item from view.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get hide;

  /// Dialog title for removing an upcoming room.
  ///
  /// In en, this message translates to:
  /// **'Remove Room'**
  String get removeRoom;

  /// Tooltip text for the remove room button.
  ///
  /// In en, this message translates to:
  /// **'Remove from list'**
  String get removeRoomFromList;

  /// Confirmation message asking if the user wants to remove an upcoming room from their list.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this upcoming room from your list?'**
  String get removeRoomConfirmation;

  /// Page title or prompt for the user to finish setting up their profile.
  ///
  /// In en, this message translates to:
  /// **'Complete your Profile'**
  String get completeYourProfile;

  /// Instructional text or button to upload a profile picture.
  ///
  /// In en, this message translates to:
  /// **'Upload profile picture'**
  String get uploadProfilePicture;

  /// Error message for an invalid name format.
  ///
  /// In en, this message translates to:
  /// **'Enter Valid Name'**
  String get enterValidName;

  /// Label for the name input field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Label for the username input field.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Error message for an invalid date of birth.
  ///
  /// In en, this message translates to:
  /// **'Enter Valid DOB'**
  String get enterValidDOB;

  /// Label for the date of birth input field.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Link text for users who have forgotten their password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Button text to proceed to the next step in a process.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Message displayed when there are no stories available in a list.
  ///
  /// In en, this message translates to:
  /// **'No stories exist to present'**
  String get noStoriesExist;

  /// Prompt for the user to enter the verification code sent to their email.
  ///
  /// In en, this message translates to:
  /// **'Enter your\nVerification Code'**
  String get enterVerificationCode;

  /// Message informing the user that a verification code has been sent. The email address is appended in the code.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit verification code to\n'**
  String get verificationCodeSent;

  /// Title for a success message after email verification.
  ///
  /// In en, this message translates to:
  /// **'Verification Complete'**
  String get verificationComplete;

  /// Success message confirming email verification.
  ///
  /// In en, this message translates to:
  /// **'Congratulations you have verified your Email'**
  String get verificationCompleteMessage;

  /// Title for an error message when verification fails.
  ///
  /// In en, this message translates to:
  /// **'Verification Failed'**
  String get verificationFailed;

  /// Error message when the entered OTP is incorrect.
  ///
  /// In en, this message translates to:
  /// **'OTP mismatch occurred please try again'**
  String get otpMismatch;

  /// Confirmation message that the OTP has been resent.
  ///
  /// In en, this message translates to:
  /// **'OTP resent'**
  String get otpResent;

  /// Button text to request a new verification code.
  ///
  /// In en, this message translates to:
  /// **'Request a new code'**
  String get requestNewCode;

  /// Text displayed before a countdown timer for requesting a new code.
  ///
  /// In en, this message translates to:
  /// **'Request a new code in'**
  String get requestNewCodeIn;

  /// Option to take a new photo using the device camera.
  ///
  /// In en, this message translates to:
  /// **'Click picture using camera'**
  String get clickPictureCamera;

  /// Option to choose an existing image from the device gallery.
  ///
  /// In en, this message translates to:
  /// **'Pick image from gallery'**
  String get pickImageGallery;

  /// Button text for the account deletion feature.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteMyAccount;

  /// Button text or page title for creating a new audio room.
  ///
  /// In en, this message translates to:
  /// **'Create New Room'**
  String get createNewRoom;

  /// Error message when the scheduled date and time for a room is not provided.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Scheduled Date-Time'**
  String get pleaseEnterScheduledDateTime;

  /// Label for the input field to schedule a room's date and time.
  ///
  /// In en, this message translates to:
  /// **'Schedule Date Time'**
  String get scheduleDateTimeLabel;

  /// Placeholder or label for the input field for adding tags to a room or story.
  ///
  /// In en, this message translates to:
  /// **'Enter tags'**
  String get enterTags;

  /// Button text or header for the community section.
  ///
  /// In en, this message translates to:
  /// **'Join Community'**
  String get joinCommunity;

  /// Link text to the company's profile on X (formerly Twitter).
  ///
  /// In en, this message translates to:
  /// **'Follow us on X'**
  String get followUsOnX;

  /// Link text to join the project's Discord server.
  ///
  /// In en, this message translates to:
  /// **'Join discord server'**
  String get joinDiscordServer;

  /// Message displayed when lyrics for an audio file are not available.
  ///
  /// In en, this message translates to:
  /// **'No lyrics'**
  String get noLyrics;

  /// Message when no stories exist in a specific category.
  ///
  /// In en, this message translates to:
  /// **'No stories currently exist in the {categoryName} category to present'**
  String noStoriesInCategory(String categoryName);

  /// Header or label for the section to add or view new chapters of a story.
  ///
  /// In en, this message translates to:
  /// **'New Chapters'**
  String get newChapters;

  /// A call to action asking users to help the platform grow, often a header for sharing/rating.
  ///
  /// In en, this message translates to:
  /// **'Help to grow'**
  String get helpToGrow;

  /// Button text for sharing content.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Button text for rating the app or content.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// Title for the 'About' page of the Resonate application.
  ///
  /// In en, this message translates to:
  /// **'About Resonate'**
  String get aboutResonate;

  /// Label for a description field.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Generic button text for a confirm action.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Name of a theme option.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get classic;

  /// Name of a theme option.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Name of a theme option.
  ///
  /// In en, this message translates to:
  /// **'Vintage'**
  String get vintage;

  /// Name of a theme option.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get amber;

  /// Name of a theme option.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forest;

  /// Name of a theme option.
  ///
  /// In en, this message translates to:
  /// **'Cream'**
  String get cream;

  /// Text representing no selection or absence of a value.
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get none;

  /// Share message for the GitHub repository, including a placeholder for the URL.
  ///
  /// In en, this message translates to:
  /// **'Check out our GitHub repository: {url}'**
  String checkOutGitHub(String url);

  /// The name of the organization.
  ///
  /// In en, this message translates to:
  /// **'AOSSIE'**
  String get aossie;

  /// Accessibility text for the AOSSIE organization logo.
  ///
  /// In en, this message translates to:
  /// **'aossie logo'**
  String get aossieLogo;

  /// Error message when the application fails to load its package information (e.g., version).
  ///
  /// In en, this message translates to:
  /// **'Could not load package info'**
  String get errorLoadPackageInfo;

  /// Error message when searching for rooms fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to search rooms. Please try again.'**
  String get searchFailed;

  /// Title indicating that a new version of the app is available.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailable;

  /// Message informing the user about an available update.
  ///
  /// In en, this message translates to:
  /// **'A new version is available!'**
  String get newVersionAvailable;

  /// Title indicating the application is on the latest version.
  ///
  /// In en, this message translates to:
  /// **'Up to Date'**
  String get upToDate;

  /// Message confirming the user has the latest version of the app.
  ///
  /// In en, this message translates to:
  /// **'You\'re using the latest version'**
  String get latestVersion;

  /// Success message after a user's profile is created.
  ///
  /// In en, this message translates to:
  /// **'Profile created successfully'**
  String get profileCreatedSuccessfully;

  /// Error message for an invalid date-time format.
  ///
  /// In en, this message translates to:
  /// **'Invalid Scheduled Date Time'**
  String get invalidScheduledDateTime;

  /// Error message when the user selects a past date-time for a scheduled event.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Date Time cannot be in past'**
  String get scheduledDateTimePast;

  /// Button text to join an audio room.
  ///
  /// In en, this message translates to:
  /// **'Join Room'**
  String get joinRoom;

  /// Placeholder text for a user whose name is not available.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownUser;

  /// A status label indicating that an action was canceled.
  ///
  /// In en, this message translates to:
  /// **'canceled'**
  String get canceled;

  /// The language code for English.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get english;

  /// A title or message indicating that email verification is needed to proceed.
  ///
  /// In en, this message translates to:
  /// **'Email Verification Required'**
  String get emailVerificationRequired;

  /// Button text to initiate a verification process.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Generic title for an audio room.
  ///
  /// In en, this message translates to:
  /// **'Audio Room'**
  String get audioRoom;

  /// A dynamic message for confirming an action on a room, like deleting or leaving.
  ///
  /// In en, this message translates to:
  /// **'To {action} the room'**
  String toRoomAction(String action);

  /// A confirmation message indicating an email has been sent.
  ///
  /// In en, this message translates to:
  /// **'mail sent'**
  String get mailSentMessage;

  /// A status label indicating a loss of connection.
  ///
  /// In en, this message translates to:
  /// **'disconnected'**
  String get disconnected;

  /// Accessibility label for the microphone button when it is on.
  ///
  /// In en, this message translates to:
  /// **'mic'**
  String get micOn;

  /// Accessibility label for the speakerphone button when it is on.
  ///
  /// In en, this message translates to:
  /// **'speaker'**
  String get speakerOn;

  /// Accessibility label for the end chat/call button.
  ///
  /// In en, this message translates to:
  /// **'end-chat'**
  String get endChat;

  /// Abbreviation for January.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJan;

  /// Abbreviation for February.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// Full name for March.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMar;

  /// Full name for April.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApr;

  /// Full name for May.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// Full name for June.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJun;

  /// Full name for July.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJul;

  /// Abbreviation for August.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthAug;

  /// Abbreviation for September.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthSep;

  /// Abbreviation for October.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthOct;

  /// Abbreviation for November.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthNov;

  /// Abbreviation for December.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthDec;

  /// Button text to register a new account.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Text preceding the 'Create new account' link on the login screen.
  ///
  /// In en, this message translates to:
  /// **'New to Resonate? '**
  String get newToResonate;

  /// Text preceding the 'Login' link on the sign-up screen.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// A temporary status message indicating a check is in progress.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checking;

  /// Instructional text on the forgot password screen.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address to reset your password.'**
  String get forgotPasswordMessage;

  /// Title for the error when a chosen username is taken.
  ///
  /// In en, this message translates to:
  /// **'Username Unavailable!'**
  String get usernameUnavailable;

  /// Error message explaining why a username cannot be used.
  ///
  /// In en, this message translates to:
  /// **'This username is invalid or either taken already.'**
  String get usernameInvalidOrTaken;

  /// Message informing the user to check their email for a new OTP.
  ///
  /// In en, this message translates to:
  /// **'Please check your mail for a new OTP.'**
  String get otpResentMessage;

  /// Generic error message for network connection issues.
  ///
  /// In en, this message translates to:
  /// **'There is a connection error. Please check your internet and try again.'**
  String get connectionError;

  /// The word 'seconds', often used after a countdown number.
  ///
  /// In en, this message translates to:
  /// **'seconds.'**
  String get seconds;

  /// A warning message shown when a user tries to leave a screen with unsaved changes.
  ///
  /// In en, this message translates to:
  /// **'If you proceed without saving, any unsaved changes will be lost.'**
  String get unsavedChangesWarning;

  /// A detailed warning message explaining the consequences of deleting an account.
  ///
  /// In en, this message translates to:
  /// **'This action will Delete Your Account Permanently. It is irreversible process. We will delete your username, email address, and all other data associated with your account. You will not be able to recover it.'**
  String get deleteAccountPermanent;

  /// Placeholder text for a name input field, encouraging a creative name.
  ///
  /// In en, this message translates to:
  /// **'Give a great name..'**
  String get giveGreatName;

  /// A description of the benefits of joining the community.
  ///
  /// In en, this message translates to:
  /// **'By joining community you can Clear your doubts, Suggest for new features, Report issues you faced and More.'**
  String get joinCommunityDescription;

  /// A short, user-facing description of the Resonate application.
  ///
  /// In en, this message translates to:
  /// **'Resonate is a social media platform, where every voice is valued. Share your thoughts, stories, and experiences with others. Start your audio journey now. Dive into diverse discussions and topics. Find rooms that resonate with you and become a part of the community. Join the conversation! Explore rooms, connect with friends, and share your voice with the world.'**
  String get resonateDescription;

  /// A comprehensive, detailed description of the Resonate application, its features, and its mission.
  ///
  /// In en, this message translates to:
  /// **'Resonate is a revolutionary voice-based social media platform where every voice matters. \nJoin real-time audio conversations, participate in diverse discussions, and connect with \nlike-minded individuals. Our platform offers:\n- Live audio rooms with topic-based discussions\n- Seamless social networking through voice\n- Community-driven content moderation\n- Cross-platform compatibility\n- End-to-end encrypted private conversations\n\nDeveloped by the AOSSIE open source community, we prioritize user privacy and \ncommunity-driven development. Join us in shaping the future of social audio!'**
  String get resonateFullDescription;

  /// A label indicating a stable, non-beta version of the app.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// Error message when a chosen username is too short.
  ///
  /// In en, this message translates to:
  /// **'Username should contain more than 5 characters.'**
  String get usernameCharacterLimit;

  /// Generic button text for submitting a form.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Label for an anonymous user or identity.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// Message displayed when a search returns no results.
  ///
  /// In en, this message translates to:
  /// **'No Search Results'**
  String get noSearchResults;

  /// Placeholder text for room search input field.
  ///
  /// In en, this message translates to:
  /// **'Search rooms...'**
  String get searchRooms;

  /// Loading message shown while searching for rooms.
  ///
  /// In en, this message translates to:
  /// **'Searching rooms...'**
  String get searchingRooms;

  /// Text for button to clear search results.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// Title for search error messages.
  ///
  /// In en, this message translates to:
  /// **'Search Error'**
  String get searchError;

  /// Error message when room search fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to search rooms. Please try again.'**
  String get searchRoomsError;

  /// Error message when upcoming room search fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to search upcoming rooms. Please try again.'**
  String get searchUpcomingRoomsError;

  /// Tooltip text for search button.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Tooltip text for clear button.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// The default message template used when sharing a room.
  ///
  /// In en, this message translates to:
  /// **'🚀 Check out this amazing room: {roomName}!\n\n📖 Description: {description}\n👥 Join {participants} participants now!'**
  String shareRoomMessage(
    String roomName,
    String description,
    int participants,
  );

  /// Displays the number of participants in a room.
  ///
  /// In en, this message translates to:
  /// **'{count} Participants'**
  String participantsCount(int count);

  /// Generic button text to join an activity or group.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// Error message prefix for an invalid tag.
  ///
  /// In en, this message translates to:
  /// **'Invalid Tag:'**
  String get invalidTags;

  /// Title or button text for the image cropping tool.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get cropImage;

  /// Short success message indicating profile changes have been saved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileSavedSuccessfully;

  /// Detailed success message confirming profile update.
  ///
  /// In en, this message translates to:
  /// **'All changes are saved successfully.'**
  String get profileUpdatedSuccessfully;

  /// Title for the message when there are no changes to save on the profile.
  ///
  /// In en, this message translates to:
  /// **'Profile up to date'**
  String get profileUpToDate;

  /// Message displayed when the user tries to save their profile without making any changes.
  ///
  /// In en, this message translates to:
  /// **'There are no new changes made, Nothing to save.'**
  String get noChangesToSave;

  /// Generic title for connection-related errors.
  ///
  /// In en, this message translates to:
  /// **'Connection Failed'**
  String get connectionFailed;

  /// Error message when a user fails to join a room due to connection issues.
  ///
  /// In en, this message translates to:
  /// **'Unable to join the room. Please check your network and try again.'**
  String get unableToJoinRoom;

  /// Title indicating that the connection to a service was lost.
  ///
  /// In en, this message translates to:
  /// **'Connection Lost'**
  String get connectionLost;

  /// Error message when the app fails to reconnect the user to a room.
  ///
  /// In en, this message translates to:
  /// **'Unable to reconnect to the room. Please try rejoining.'**
  String get unableToReconnect;

  /// Generic error message for data with an incorrect format.
  ///
  /// In en, this message translates to:
  /// **'Invalid Format!'**
  String get invalidFormat;

  /// Error message detailing the character requirements for a valid username.
  ///
  /// In en, this message translates to:
  /// **'Username must be alphanumeric and should not contain special characters.'**
  String get usernameAlphanumeric;

  /// Success message after a user completes their profile setup.
  ///
  /// In en, this message translates to:
  /// **'Your user profile is successfully created.'**
  String get userProfileCreatedSuccessfully;

  /// An instructional message prompting the user to verify their email.
  ///
  /// In en, this message translates to:
  /// **'To proceed, verify your email address.'**
  String get emailVerificationMessage;

  /// Title for the screen where new chapters are added to an existing story.
  ///
  /// In en, this message translates to:
  /// **'Add New Chapters to {storyName}'**
  String addNewChaptersToStory(String storyName);

  /// Header for the list of existing chapters in a story.
  ///
  /// In en, this message translates to:
  /// **'Current Chapters'**
  String get currentChapters;

  /// Link text to the project's source code on GitHub.
  ///
  /// In en, this message translates to:
  /// **'Source code on GitHub'**
  String get sourceCodeOnGitHub;

  /// Title for the screen where a new chapter is created.
  ///
  /// In en, this message translates to:
  /// **'Create a Chapter'**
  String get createAChapter;

  /// Label for the chapter title input field, indicating it is required.
  ///
  /// In en, this message translates to:
  /// **'Chapter Title *'**
  String get chapterTitle;

  /// Label for the 'About' or description input field, indicating it is required.
  ///
  /// In en, this message translates to:
  /// **'About *'**
  String get aboutRequired;

  /// Button text to change the cover image of a story or chapter.
  ///
  /// In en, this message translates to:
  /// **'Change Cover Image'**
  String get changeCoverImage;

  /// Button text to upload an audio file.
  ///
  /// In en, this message translates to:
  /// **'Upload Audio File'**
  String get uploadAudioFile;

  /// Button text to upload a lyrics file.
  ///
  /// In en, this message translates to:
  /// **'Upload Lyrics File'**
  String get uploadLyricsFile;

  /// Button text to finalize and create a new chapter.
  ///
  /// In en, this message translates to:
  /// **'Create Chapter'**
  String get createChapter;

  /// Message shown after an audio file has been selected for upload.
  ///
  /// In en, this message translates to:
  /// **'Audio file Selected: {fileName}'**
  String audioFileSelected(String fileName);

  /// Message shown after a lyrics file has been selected for upload.
  ///
  /// In en, this message translates to:
  /// **'Lyrics File Selected: {fileName}'**
  String lyricsFileSelected(String fileName);

  /// Error message when required fields or files are missing from a form.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields and upload your Audio file and Lyrics file'**
  String get fillAllRequiredFields;

  /// A status label indicating an event is scheduled for the future.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// Generic confirmation button text, often for closing a dialog.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Label for the room description input field, indicating it is not required.
  ///
  /// In en, this message translates to:
  /// **'Room Description (optional)'**
  String get roomDescriptionOptional;

  /// Button text to initiate the account deletion process.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// Title for the screen where a new story is created.
  ///
  /// In en, this message translates to:
  /// **'Create Your Story'**
  String get createYourStory;

  /// Label for the title input field, indicating it is required.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get titleRequired;

  /// Label for the category selection, indicating it is required.
  ///
  /// In en, this message translates to:
  /// **'Category *'**
  String get category;

  /// Button text to add a chapter to a story.
  ///
  /// In en, this message translates to:
  /// **'Add Chapter'**
  String get addChapter;

  /// Button text to finalize and create a new story.
  ///
  /// In en, this message translates to:
  /// **'Create Story'**
  String get createStory;

  /// Error message for the story creation form when requirements are not met.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields, add at least one chapter, and select a cover image.'**
  String get fillAllRequiredFieldsAndChapter;

  /// Instructional text in a confirmation dialog, preceding the text to be typed.
  ///
  /// In en, this message translates to:
  /// **'To confirm, type'**
  String get toConfirmType;

  /// Instructional text in a confirmation dialog, following the text to be typed.
  ///
  /// In en, this message translates to:
  /// **'in the box below'**
  String get inTheBoxBelow;

  /// The specific phrase a user must type to confirm account deletion.
  ///
  /// In en, this message translates to:
  /// **'I understand, Delete My Account'**
  String get iUnderstandDeleteMyAccount;

  /// A prompt on the main screen, encouraging user engagement.
  ///
  /// In en, this message translates to:
  /// **'What do you want to listen to?'**
  String get whatDoYouWantToListenTo;

  /// Header for the list of categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Header for the list of stories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get stories;

  /// Header for a list of suggested content.
  ///
  /// In en, this message translates to:
  /// **'Some Suggestions'**
  String get someSuggestions;

  /// Button text on an onboarding screen to begin using the app.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Button text to skip an optional step, like onboarding.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Onboarding screen title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Resonate'**
  String get welcomeToResonate;

  /// Feature highlight on an onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'Explore Diverse Conversations'**
  String get exploreDiverseConversations;

  /// Feature highlight on an onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'Your Voice Matters'**
  String get yourVoiceMatters;

  /// Descriptive text on an onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'Join the conversation! Explore rooms, connect with friends, and share your voice with the world.'**
  String get joinConversationExploreRooms;

  /// Descriptive text on an onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'Dive into diverse discussions and topics. \nFind rooms that resonate with you and become a part of the community.'**
  String get diveIntoDiverseDiscussions;

  /// Descriptive text on an onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'At Resonate, every voice is valued. Share your thoughts, stories, and experiences with others. Start your audio journey now.'**
  String get atResonateEveryVoiceValued;

  /// Title for the notifications screen.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notification message when tagged in an upcoming room.
  ///
  /// In en, this message translates to:
  /// **'{username} tagged you in an upcoming room: {subject}'**
  String taggedYouInUpcomingRoom(String username, String subject);

  /// Notification message when tagged in a live room.
  ///
  /// In en, this message translates to:
  /// **'{username} tagged you in room: {subject}'**
  String taggedYouInRoom(String username, String subject);

  /// Notification message when someone likes your story.
  ///
  /// In en, this message translates to:
  /// **'{username} liked your story: {subject}'**
  String likedYourStory(String username, String subject);

  /// Notification message when someone subscribes to your room.
  ///
  /// In en, this message translates to:
  /// **'{username} subscribed to your room: {subject}'**
  String subscribedToYourRoom(String username, String subject);

  /// Notification message when someone starts following you.
  ///
  /// In en, this message translates to:
  /// **'{username} started following you'**
  String startedFollowingYou(String username);

  /// Generic title for a new notification.
  ///
  /// In en, this message translates to:
  /// **'You have a new notification'**
  String get youHaveNewNotification;

  /// A friendly message displayed during a long loading process.
  ///
  /// In en, this message translates to:
  /// **'Hang on, Good Things take time 🔍'**
  String get hangOnGoodThingsTakeTime;

  /// Informational text about the open-source nature of the project.
  ///
  /// In en, this message translates to:
  /// **'Resonate is an open source project maintained by AOSSIE. Checkout our github to contribute.'**
  String get resonateOpenSourceProject;

  /// Button text to mute the microphone.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// Label for the speakerphone toggle.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get speakerLabel;

  /// Button text to end a call or session.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// Button text to save modified settings or profile information.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// Button text to discard changes.
  ///
  /// In en, this message translates to:
  /// **'DISCARD'**
  String get discard;

  /// Button text to save changes.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get save;

  /// Button text to open the profile picture selection options.
  ///
  /// In en, this message translates to:
  /// **'Change profile picture'**
  String get changeProfilePicture;

  /// Option to use the camera to take a picture.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Option to choose a picture from the gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Button text to remove an item, like a profile picture.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Displays the creation date of a story or content.
  ///
  /// In en, this message translates to:
  /// **'Created {date}'**
  String created(String date);

  /// Header for the list of chapters in a story.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// Button text to delete a story.
  ///
  /// In en, this message translates to:
  /// **'Delete Story'**
  String get deleteStory;

  /// Displays the name of the content creator.
  ///
  /// In en, this message translates to:
  /// **'Created by {creatorName}'**
  String createdBy(String creatorName);

  /// Button text to start an activity or session.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Button text to unsubscribe from a room or notification.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get unsubscribe;

  /// Button text to subscribe to a room or notification.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// Selects the appropriate category name for a story based on a key.
  ///
  /// In en, this message translates to:
  /// **'{category, select, drama{Drama} comedy{Comedy} horror{Horror} romance{Romance} thriller{Thriller} spiritual{Spiritual} other{Other}}'**
  String storyCategory(String category);

  /// Selects the appropriate theme name based on a key.
  ///
  /// In en, this message translates to:
  /// **'{category, select, classicTheme{Classic} timeTheme{Time} vintageTheme{Vintage} amberTheme{Amber} forestTheme{Forest} creamTheme{Cream} other{Other}}'**
  String chooseTheme(String category);

  /// Displays time in a relative format for minutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String minutesAgo(int count);

  /// Displays time in a relative format for hours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String hoursAgo(int count);

  /// Displays time in a relative format for days.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// A preposition, typically used between a content title and the author's name.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;

  /// Label for the number of likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// Abbreviation for 'minutes', used to display audio length.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get lengthMinutes;

  /// Error message for a mandatory field that was left empty.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// Header for the list of users who are currently online.
  ///
  /// In en, this message translates to:
  /// **'Online Users'**
  String get onlineUsers;

  /// Message displayed when no users are online.
  ///
  /// In en, this message translates to:
  /// **'No users currently online'**
  String get noOnlineUsers;

  /// Instructional text to select a user to start a chat.
  ///
  /// In en, this message translates to:
  /// **'Choose User to chat with'**
  String get chooseUser;

  /// Button text for a feature that quickly matches the user with a random chat partner.
  ///
  /// In en, this message translates to:
  /// **'Quick Match'**
  String get quickMatch;

  /// Label for a story.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get story;

  /// Label for a user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Label for the list of users that the current user is following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// Label for the list of users who are following the current user.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// Header for the list of incoming friend requests.
  ///
  /// In en, this message translates to:
  /// **'Friend Requests'**
  String get friendRequests;

  /// Title for the confirmation message after sending a friend request.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent'**
  String get friendRequestSent;

  /// Confirmation message after sending a friend request to a specific user.
  ///
  /// In en, this message translates to:
  /// **'Your friend request to {username} has been sent.'**
  String friendRequestSentTo(String username);

  /// Title for the confirmation message after cancelling a friend request.
  ///
  /// In en, this message translates to:
  /// **'Friend request cancelled'**
  String get friendRequestCancelled;

  /// Confirmation message after cancelling a friend request to a specific user.
  ///
  /// In en, this message translates to:
  /// **'Your friend request to {username} has been cancelled.'**
  String friendRequestCancelledTo(String username);

  /// A status label on a button indicating a friend request has been sent.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requested;

  /// A status label or header for the list of friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// Button text to send a friend request.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// Title for the confirmation message after accepting a friend request.
  ///
  /// In en, this message translates to:
  /// **'Friend request accepted'**
  String get friendRequestAccepted;

  /// Confirmation message after accepting a friend request from a specific user.
  ///
  /// In en, this message translates to:
  /// **'You are now friends with {username}.'**
  String friendRequestAcceptedTo(String username);

  /// Title for the confirmation message after declining a friend request.
  ///
  /// In en, this message translates to:
  /// **'Friend request declined'**
  String get friendRequestDeclined;

  /// Confirmation message after declining a friend request from a specific user.
  ///
  /// In en, this message translates to:
  /// **'You have declined the friend request from {username}.'**
  String friendRequestDeclinedTo(String username);

  /// Button text to accept a request or invitation.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Title for the message when a call is declined.
  ///
  /// In en, this message translates to:
  /// **'Call declined'**
  String get callDeclined;

  /// Message indicating that a specific user declined a call.
  ///
  /// In en, this message translates to:
  /// **'User {username} declined the call.'**
  String callDeclinedTo(String username);

  /// Button text to manually check for application updates.
  ///
  /// In en, this message translates to:
  /// **'Check Updates'**
  String get checkForUpdates;

  /// Button text to start the update process.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// Button text to postpone an update.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// Title for the success message after an update.
  ///
  /// In en, this message translates to:
  /// **'Update Successful'**
  String get updateSuccessful;

  /// Success message confirming the application has been updated.
  ///
  /// In en, this message translates to:
  /// **'Resonate has been updated successfully!'**
  String get updateSuccessfulMessage;

  /// Title for the message when an update is cancelled.
  ///
  /// In en, this message translates to:
  /// **'Update Cancelled'**
  String get updateCancelled;

  /// Message indicating the user cancelled the update process.
  ///
  /// In en, this message translates to:
  /// **'Update was cancelled by user'**
  String get updateCancelledMessage;

  /// Title for the message when an update fails.
  ///
  /// In en, this message translates to:
  /// **'Update Failed'**
  String get updateFailed;

  /// Error message when an in-app update fails, suggesting a manual update.
  ///
  /// In en, this message translates to:
  /// **'Failed to update. Please try updating from Play Store manually.'**
  String get updateFailedMessage;

  /// Generic title for an update-related error.
  ///
  /// In en, this message translates to:
  /// **'Update Error'**
  String get updateError;

  /// Generic error message for an update that failed due to an unknown error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while updating. Please try again.'**
  String get updateErrorMessage;

  /// Title for an error when a feature is not supported on the current platform.
  ///
  /// In en, this message translates to:
  /// **'Platform Not Supported'**
  String get platformNotSupported;

  /// Message explaining that the in-app update feature is platform-specific.
  ///
  /// In en, this message translates to:
  /// **'Update checking is only available on Android devices'**
  String get platformNotSupportedMessage;

  /// Title for an error when the app fails to check for updates.
  ///
  /// In en, this message translates to:
  /// **'Update Check Failed'**
  String get updateCheckFailed;

  /// Error message when the check for updates process fails.
  ///
  /// In en, this message translates to:
  /// **'Could not check for updates. Please try again later.'**
  String get updateCheckFailedMessage;

  /// Title for the message when the app is already up to date.
  ///
  /// In en, this message translates to:
  /// **'You\'re Up to Date!'**
  String get upToDateTitle;

  /// Message confirming that no update is needed.
  ///
  /// In en, this message translates to:
  /// **'You\'re using the latest version of Resonate'**
  String get upToDateMessage;

  /// Title for the dialog informing the user about a new update.
  ///
  /// In en, this message translates to:
  /// **'Update Available!'**
  String get updateAvailableTitle;

  /// Message prompting the user to update the app from the Play Store.
  ///
  /// In en, this message translates to:
  /// **'A new version of Resonate is available on Play Store'**
  String get updateAvailableMessage;

  /// A message highlighting the benefit of updating the application.
  ///
  /// In en, this message translates to:
  /// **'Get the latest features and improvements!'**
  String get updateFeaturesImprovement;

  /// Error message when unable to remove a room from the list
  ///
  /// In en, this message translates to:
  /// **'Failed to remove room'**
  String get failedToRemoveRoom;

  /// Success message when a room is successfully removed from the user's list
  ///
  /// In en, this message translates to:
  /// **'Room removed from your list successfully'**
  String get roomRemovedSuccessfully;

  /// Title for an alert dialog.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// Message shown when a user is removed or reported from a room.
  ///
  /// In en, this message translates to:
  /// **'You have been reported or removed from the room'**
  String get removedFromRoom;

  /// Selects the appropriate report type label based on a key.
  ///
  /// In en, this message translates to:
  /// **'{type, select, harassment{Harassment / Hate Speech} abuse{Abusive content / Violence} spam{Spam / Scams / Fraud} impersonation{Impersonation / Fake Accounts} illegal{Illegal Activities} selfharm{Self-harm / Suicide / Mental health} misuse{Misuse of platform} other{Other}}'**
  String reportType(String type);

  /// Message shown when a user is blocked from using Resonate.
  ///
  /// In en, this message translates to:
  /// **'You have received multiple reports from users and you have been blocked from using Resonate. Please contact AOSSIE if you believe this is a mistake.'**
  String get userBlockedFromResonate;

  /// Label for the button to report a participant.
  ///
  /// In en, this message translates to:
  /// **'Report Participant'**
  String get reportParticipant;

  /// Prompt for the user to select a report type.
  ///
  /// In en, this message translates to:
  /// **'Please select a report type'**
  String get selectReportType;

  /// Message shown when a report is submitted successfully.
  ///
  /// In en, this message translates to:
  /// **'Report Submitted Successfully'**
  String get reportSubmitted;

  /// Message shown when a report submission fails.
  ///
  /// In en, this message translates to:
  /// **'Report Submission Failed'**
  String get reportFailed;

  /// Label for an optional input field for additional details in a report.
  ///
  /// In en, this message translates to:
  /// **'Additional details (optional)'**
  String get additionalDetailsOptional;

  /// Button text to submit a report.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// Title for a message indicating that a user action is blocked.
  ///
  /// In en, this message translates to:
  /// **'Action Blocked'**
  String get actionBlocked;

  /// Message explaining why a user cannot stop a recording manually.
  ///
  /// In en, this message translates to:
  /// **'You cannot stop the recording manually, the recording will be stopped when the room is closed.'**
  String get cannotStopRecording;

  /// Label indicating that a chapter is currently live.
  ///
  /// In en, this message translates to:
  /// **'Live Chapter'**
  String get liveChapter;

  /// Button text to view or edit the lyrics of a chapter.
  ///
  /// In en, this message translates to:
  /// **'View or Edit Lyrics'**
  String get viewOrEditLyrics;

  /// Label for the button to close a dialog.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Title for the screen where Live chapter details are verified before publishing.
  ///
  /// In en, this message translates to:
  /// **'Verify Chapter Details'**
  String get verifyChapterDetails;

  /// Label for the author of a story or chapter.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// Title for the screen where a live chapter is initiated.
  ///
  /// In en, this message translates to:
  /// **'Start a Live Chapter'**
  String get startLiveChapter;

  /// Error message when required fields are not filled in a form.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get fillAllFields;

  /// Error message when trying to exit a live chapter room without any recording.
  ///
  /// In en, this message translates to:
  /// **'You have not recorded anything for the chapter. Please record a chapter before exiting the room'**
  String get noRecordingError;
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
      <String>['en', 'gu', 'hi', 'kn', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
