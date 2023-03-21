import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:resonate/pages/profile.dart';
import 'package:resonate/pages/signup.dart';

class LoginPage extends StatefulWidget {


  const LoginPage({final Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? loginError;
  late Auth0 auth0;
  UserProfile? userProfile;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState(){
    super.initState();
    auth0 = Auth0("dev-5w4x3qxvszw8f0u6.us.auth0.com", "4uYaXmTa00TbAZ8WLTQkxAusQAZ8HS0O");
  }



  Future<void> loginAction(BuildContext ctx) async{
    try{
      final Credentials credentials = await auth0.api.login(
          usernameOrEmail: emailController.text,
          password: passwordController.text,
          connectionOrRealm: 'Username-Password-Authentication'
      );
      await auth0.credentialsManager.storeCredentials(credentials);
      print(credentials.user.email);
      setState(() {
        userProfile = credentials.user;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(userProfile)),
              (route) => false
      );
    }
    catch (e) {
      print(e);
      setState(() {
        loginError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Center(
          child: Column(
            children: <Widget>[
              const CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/13849023?s=280&v=4"),
              ),
              const SizedBox(height: 15),
              const Text("Welcome", style: TextStyle(fontSize: 25)),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("New User? "),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupPage()),
                          (route) => false
                      );
                    },
                    child: const Text(
                      "Signup",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: (){
                    loginAction(context);
                  },
                  child: const Text("Login"),
              )
            ]
          ),
        ),
      ),
    );
  }
}
