
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';

class RatingSheetWidget extends StatelessWidget {
  RatingSheetWidget({super.key});
  final Databases databases = AppwriteService.getDatabases();
  final PairChatController controller = Get.find<PairChatController>();
  final AuthStateController authController = Get.find<AuthStateController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: UiSizes.height_246,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Theme.of(context).colorScheme.surface,
      ),
      // Placeholder for the rating sheet content
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Rate your experience',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Obx(
            () => Text(
              'Rating: ${controller.pairRating.value.toStringAsFixed(1)}/5.0',
              //style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          AnimatedRatingStars(
            onChanged: (double rating) {
              controller.pairRating.value = rating;
            },
            customFilledIcon: Icons.star,
            customHalfFilledIcon: Icons.star_half,
            customEmptyIcon: Icons.star_border_outlined,
            displayRatingValue: true,
            initialRating: 2.5,
            minRating: 0.0,
            maxRating: 5.0,
            interactiveTooltips: true,
            filledIcon: Icons.star,
            halfFilledIcon: Icons.star_half,
            emptyIcon: Icons.star_border_outlined,
          ),
          ElevatedButton(
              onPressed: () async {
                await databases.updateDocument(
                    databaseId: userDatabaseID,
                    collectionId: usersCollectionID,
                    documentId: authController.uid!,
                    data: {
                      "ratingTotal": authController.ratingTotal +
                          controller.pairRating.value,
                      "ratingCount": authController.ratingCount + 1
                    });
                await authController.setUserProfileData();
                Get.back();
              },
              child: const Text('Submit'))
        ],
      )),
    );
  }
}
