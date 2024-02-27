//AppRoutes class has named routes used by GetPage name property.
//This approach simplifies navigation as all the routes are present in same class.
//Also improves code manageability
//AppRoutes are used in AppPages which can be found in lib\routes\app_pages.dart
class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const profile = '/profile';
  static const emailVerification = '/emailVerification';
  static const onBoarding = "/onBoarding";
  static const tabview = "/tabview";
  static const home = "/home";
  static const createRoom = "/createRoom";
  static const splash = "/splash";
  static const landing = "/landing";
  static const updateEmail = "/updateEmail";
  static const discuss = "/discuss";
  static const pairing = "/pairing";
  static const pairChat = "/pairChat";
  static const settings = "/settings";
  static const editProfile = "/editProfile";
  static const deleteAccount = "/deleteAccount";
}
