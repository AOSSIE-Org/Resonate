import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../utils/ui_sizes.dart';

class NewEmailVerificationScreen extends StatelessWidget {
  const NewEmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_20,
          vertical: UiSizes.height_20,
        ),
        width: double.maxFinite,
        child: Form(
          child: Column(
            children: [
              SizedBox(
                height: UiSizes.height_60,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your\nVerification Code",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(
                height: UiSizes.height_30,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We sent 4-digit verification code to\n<your email address>",
                ),
              ),
              SizedBox(
                height: UiSizes.height_30,
              ),
              OtpTextField(
                margin: EdgeInsets.symmetric(horizontal: UiSizes.width_10),
                showFieldAsBox: true,
                keyboardType: TextInputType.number,
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
                borderWidth: 1,
                borderColor: Colors.transparent,
                fieldHeight: 50,
                fieldWidth: 50,
                contentPadding: EdgeInsets.zero,
                enabledBorderColor: Colors.transparent,
                focusedBorderColor: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                height: UiSizes.height_30,
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "Verify",
                  ),
                ),
              ),
              SizedBox(
                height: UiSizes.height_10,
              ),
              SizedBox(
                width: double.maxFinite,
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text(
                    "Open mail app",
                  ),
                ),
              ),
              SizedBox(
                height: UiSizes.height_40,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Request a new code",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
