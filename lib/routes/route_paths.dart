class RoutePaths {
  RoutePaths._();

  // Auth flow
  static const splash = '/splash';
  static const landing = '/landing';
  static const welcome = '/welcomeScreen';
  static const login = '/loginScreen';
  static const signup = '/signup';
  static const emailVerification = '/emailVerification';
  static const forgotPassword = '/forgotPassword';
  static const resetPassword = '/resetPassword';
  static const userBlocked = '/userBlockedScreen';
  static const onboarding = '/onBoarding';

  // Main app
  static const tabview = '/tabview';
  static const homeScreen = '/homeScreen';
  static const createRoom = '/createRoom';
  static const profile = '/profile';
  static const editProfile = '/editProfile';
  static const deleteAccount = '/deleteAccount';
  static const changeEmail = '/changeEmail';
  static const updateEmail = '/updateEmail';
  static const settings = '/settings';
  static const themeScreen = '/themeScreen';
  static const userAccountScreen = '/userAccountScreen';
  static const notificationsScreen = '/notificationsScreen';
  static const aboutApp = '/aboutApp';
  static const contributeScreen = '/contributeScreen';
  static const appPreferencesScreen = '/appPreferencesScreen';

  // Rooms / discussion
  static const discuss = '/discuss';
  static const roomScreen = '/roomScreen';
  static const bottomNavBar = '/bottomNavBar';

  // Pair chat / friend calls
  static const pairing = '/pairing';
  static const pairChat = '/pairChat';
  static const pairChatUsers = '/pairChatUsers';
  static const ringingScreen = '/ringingScreen';
  static const friendCallScreen = '/friendCallScreen';

  // Stories / live chapters
  static const exploreScreen = '/exploreScreen';
  static const createStoryScreen = '/createStoryScreen';
  static const liveChapterScreen = '/liveChapterScreen';
  static const verifyChapterDetails = '/verifyChapterDetails';

  static const Set<String> protected = {
    tabview,
    homeScreen,
    createRoom,
    profile,
    editProfile,
    deleteAccount,
    changeEmail,
    updateEmail,
    settings,
    themeScreen,
    userAccountScreen,
    notificationsScreen,
    appPreferencesScreen,
    discuss,
    roomScreen,
    bottomNavBar,
    pairing,
    pairChat,
    pairChatUsers,
    ringingScreen,
    friendCallScreen,
    exploreScreen,
    createStoryScreen,
    liveChapterScreen,
  };

  static const Set<String> authOnly = {
    landing,
    welcome,
    login,
    signup,
    forgotPassword,
    resetPassword,
  };
}
