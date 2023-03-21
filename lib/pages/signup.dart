import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:resonate/pages/email_verification_page.dart';
import 'package:resonate/pages/login.dart';

class SignupPage extends StatefulWidget {


  const SignupPage({final Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? loginError;
  Credentials? _credentials;
  late Auth0 auth0;
  UserProfile? userProfile;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState(){
    super.initState();
    auth0 = Auth0("dev-5w4x3qxvszw8f0u6.us.auth0.com", "4uYaXmTa00TbAZ8WLTQkxAusQAZ8HS0O");
  }



  Future<void> registerAction() async{
    try{
      final DatabaseUser credentials = await auth0.api.signup(
          email: emailController.text,
          password: passwordController.text,
          connection: 'Username-Password-Authentication'
      );
      print(credentials.email);
      print(credentials.isEmailVerified);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const EmailVerficationLink()),
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
        title: const Text("Signup"),
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
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                                (route) => false
                        );
                      },
                      child: const Text(
                        "Login",
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
                  onPressed: registerAction,
                  child: const Text("Signup"),
                )
              ]
          ),
        ),
      ),
    );
  }
}
