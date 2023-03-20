import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {


  const LoginPage({final Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? loginError;
  Credentials? _credentials;
  late Auth0 auth0;
  UserProfile? userProfile;

  @override
  void initState(){
    super.initState();
    auth0 = Auth0("dev-5w4x3qxvszw8f0u6.us.auth0.com", "4uYaXmTa00TbAZ8WLTQkxAusQAZ8HS0O");
  }



  Future<void> loginAction() async{
    try{
      final Credentials credentials =  await auth0.webAuthentication(scheme: "resonate").login();
      setState(() {
        _credentials = credentials;
        userProfile = credentials.user;
      });
    }
    catch (e) {
      setState(() {
        loginError = e.toString();
      });
    }
  }

  Future<void> logoutAction() async{
    try{
      await auth0.webAuthentication(scheme: "resonate").logout();
      setState(() {
        _credentials = null;
        userProfile = null;
      });
    }
    catch (e) {
      setState(() {
        loginError = e.toString();
      });
    }
  }


  List<Widget> withoutLoginWidgets() {
    return [
      ElevatedButton(
        onPressed: () async {
          await loginAction();
        },
        child: const Text('Login'),
      ),
      Text(loginError ?? ''),
    ];
  }

  List<Widget> withLoginWidget(){
    return [
      const Text("Logged in as:"),
      userProfile?.pictureUrl == null ? const SizedBox() :
        CircleAvatar(
            backgroundImage: NetworkImage(userProfile!.pictureUrl.toString())
        ),
      Text("Name: ${userProfile?.name}"),
      Text("Email: ${userProfile?.email}"),
      const SizedBox(height: 15),
      ElevatedButton(
        onPressed: () async {
          await logoutAction();
        },
        child: const Text('Logout'),
      ),
      Text(loginError ?? ''),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _credentials == null
              ? withoutLoginWidgets()
              : withLoginWidget(),
        ),
      ),
    );
  }
}
