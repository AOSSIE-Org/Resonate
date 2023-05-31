import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/enums/gender.dart';

import '../../controllers/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: Get.height * 0.9,
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                child: Column(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset("assets/images/aossie_logo.png"),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Complete your Profile",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () async => await controller.pickImage(),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 50,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: controller.imageController.text == ""
                              ? null
                              : NetworkImage(controller.imageController.text),
                          radius: 50,
                          child: Stack(
                            children: const [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.yellow,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      validator: (value) =>
                          value!.isNotEmpty ? null : "Enter Valid Name",
                      controller: controller.nameController,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: "Full Name",
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      validator: (value) =>
                          value!.isNotEmpty ? null : "Enter Valid Username",
                      controller: controller.usernameController,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: "Username",
                        prefixText: "@",
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      validator: (value) =>
                          value!.isNotEmpty ? null : "Enter Valid DOB",
                      readOnly: true,
                      controller: controller.dobController,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.person),
                        labelText: "Date of Birth",
                        suffix: GestureDetector(
                          onTap: () async {
                            await controller.chooseDate();
                          },
                          child: const Icon(Icons.date_range),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.width * 0.4,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.male,
                              color: controller.genderController.text ==
                                      Gender.male.name
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () => controller.setGender(Gender.male),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  controller.genderController.text ==
                                          Gender.male.name
                                      ? AppColor.yellowColor
                                      : AppColor.bgBlackColor,
                            ),
                            label: Text(
                              'Male',
                              style: TextStyle(
                                color: controller.genderController.text ==
                                        Gender.male.name
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.4,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  controller.genderController.text ==
                                          Gender.female.name
                                      ? AppColor.yellowColor
                                      : AppColor.bgBlackColor,
                            ),
                            icon: Icon(
                              Icons.female,
                              color: controller.genderController.text ==
                                      Gender.female.name
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            onPressed: () =>
                                controller.setGender(Gender.female),
                            label: Text(
                              'Female',
                              style: TextStyle(
                                color: controller.genderController.text ==
                                        Gender.female.name
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () async => await controller.saveProfile(),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
