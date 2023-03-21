import 'package:flutter/material.dart';
import 'package:resonate/pages/login.dart';

class EmailVerficationLink extends StatelessWidget {
  const EmailVerficationLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify Email")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Email Verfication has been sent your email. Please verify and login.", textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false
              );
            },
            child: const Text("Login"),
          )
        ],
      )
    );
  }
}
