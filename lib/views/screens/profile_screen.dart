import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/profile_controller.dart';
import 'package:resonate/main.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/services/auth/google_signin.dart';
import 'package:resonate/views/screens/login_screen.dart';

// class ProfileScreen extends StatelessWidget {
//   final GoogleSignInAccount user;
//   const ProfileScreen({super.key, required this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               backgroundImage: NetworkImage(user.photoUrl!),
//               radius: 50,
//             ),
//             Text(
//               user.displayName!,
//               style: TextStyle(fontSize: 25),
//             ),
//             Text(
//               user.email!,
//               style: TextStyle(fontSize: 15),
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   GoogleSignInApi.logout();
//                   Get.to(LoginScreen());
//                 },
//                 child: Text("Logout"))
//           ],
//         ),
//       ),
//     );
//   }
// }

class ProfileScreen extends StatelessWidget {
  ProfileScreen({final Key? key}) : super(key: key);
  final AuthenticationController authenticationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 4),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(controller.userProfile.pictureUrl.toString() ?? ''),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Name: ${controller.userProfile.name}'),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  authenticationController.logout();
                  Get.offNamed(AppRoutes.login);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}