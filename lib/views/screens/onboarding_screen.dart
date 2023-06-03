import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
                key: controller.userOnboardingFormKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Complete your Profile",
                      style: TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () async => await controller.pickImage(),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 50,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: (controller.profileImage == null)
                              ? NetworkImage(controller.imageController.text)
                              : FileImage(controller.profileImage!)
                                  as ImageProvider,
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
                    Obx(
                      () => TextFormField(
                        validator: (value) {
                          if (value!.length>5) {
                            return null;
                          } else {
                            return "Username should contain more than 5 characters.";
                          }
                        },
                        controller: controller.usernameController,
                        onChanged: (value) async{
                          if (value.length>4){
                            controller.usernameAvailable.value =
                            await controller.isUsernameAvailable(value);
                          }
                          else{
                            controller.usernameAvailable.value = false;
                          }
                        },
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        decoration: InputDecoration(
                            icon: Icon(Icons.account_circle),
                            labelText: "Username",
                            prefixText: "@",
                            suffixIcon: controller.usernameAvailable.value
                                ? Icon(Icons.verified_outlined)
                                : null),
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
                        icon: const Icon(Icons.calendar_month),
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
                    Obx(() {
                      return ElevatedButton(
                        onPressed: () async {
                          if (!controller.isLoading.value) {
                            await controller.saveProfile();
                          }
                        },
                        child: controller.isLoading.value
                            ? Center(
                                child: LoadingAnimationWidget
                                    .horizontalRotatingDots(
                                  color: Colors.black,
                                  size: 40,
                                ),
                              )
                            : Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                ),
                              ),
                      );
                    }),
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
