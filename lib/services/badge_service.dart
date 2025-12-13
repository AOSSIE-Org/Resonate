import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/badge_constants.dart';
import 'package:resonate/utils/constants.dart';

/// Service for managing user badges.
/// 
/// Handles badge assignment based on user metrics. Badges are stored as an array
/// of strings in the user's Appwrite document. Badges are additive and never removed.
/// 
/// Badge types:
/// - ANCHOR: Hosted 5 rooms
/// - STORYTELLER: Published 1 story
/// - CROWD_FAVORITE: 100 total listeners across all hosted rooms
/// - CONVERSATIONALIST: 10 pair chats
/// - AUDIOPHILE: 10 hours of listening (requires totalListeningTimeHours in user doc)
class BadgeService {
  final Databases databases;

  BadgeService({Databases? databases})
      : databases = databases ?? AppwriteService.getDatabases();

  /// Checks and assigns badges for a user based on their current metrics.
  /// Returns the list of newly assigned badges.
  Future<List<String>> checkAndAssignBadges(String userId) async {
    try {
      // Get current user document
      Document userDoc = await databases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: userId,
      );

      List<String> currentBadges =
          List<String>.from(userDoc.data['badges'] ?? []);
      List<String> newBadges = [];

      // Check each badge type
      if (!currentBadges.contains(BadgeConstants.anchor)) {
        if (await _checkAnchorBadge(userId)) {
          newBadges.add(BadgeConstants.anchor);
        }
      }

      if (!currentBadges.contains(BadgeConstants.storyteller)) {
        if (await _checkStorytellerBadge(userId)) {
          newBadges.add(BadgeConstants.storyteller);
        }
      }

      if (!currentBadges.contains(BadgeConstants.crowdFavorite)) {
        if (await _checkCrowdFavoriteBadge(userId)) {
          newBadges.add(BadgeConstants.crowdFavorite);
        }
      }

      if (!currentBadges.contains(BadgeConstants.conversationalist)) {
        if (await _checkConversationalistBadge(userId)) {
          newBadges.add(BadgeConstants.conversationalist);
        }
      }

      if (!currentBadges.contains(BadgeConstants.audiophile)) {
        if (await _checkAudiophileBadge(userId)) {
          newBadges.add(BadgeConstants.audiophile);
        }
      }

      // Update user document with new badges if any
      if (newBadges.isNotEmpty) {
        currentBadges.addAll(newBadges);
        await databases.updateDocument(
          databaseId: userDatabaseID,
          collectionId: usersCollectionID,
          documentId: userId,
          data: {'badges': currentBadges},
        );
        log('Assigned badges to user $userId: $newBadges');
      }

      return newBadges;
    } catch (e) {
      log('Error checking badges for user $userId: $e');
      return [];
    }
  }

  /// Check if user qualifies for ANCHOR badge (hosted 5 rooms)
  Future<bool> _checkAnchorBadge(String userId) async {
    try {
      var rooms = await databases.listDocuments(
        databaseId: masterDatabaseId,
        collectionId: roomsCollectionId,
        queries: [Query.equal('adminUid', userId)],
      );
      return rooms.documents.length >= BadgeConstants.anchorThreshold;
    } catch (e) {
      log('Error checking ANCHOR badge: $e');
      return false;
    }
  }

  /// Check if user qualifies for STORYTELLER badge (published 1 story)
  Future<bool> _checkStorytellerBadge(String userId) async {
    try {
      var stories = await databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: storyCollectionId,
        queries: [Query.equal('creatorId', userId)],
      );
      return stories.documents.length >= BadgeConstants.storytellerThreshold;
    } catch (e) {
      log('Error checking STORYTELLER badge: $e');
      return false;
    }
  }

  /// Check if user qualifies for CROWD_FAVORITE badge (100 total listeners)
  Future<bool> _checkCrowdFavoriteBadge(String userId) async {
    try {
      // Get all rooms where user is admin
      var rooms = await databases.listDocuments(
        databaseId: masterDatabaseId,
        collectionId: roomsCollectionId,
        queries: [Query.equal('adminUid', userId)],
      );

      int totalListeners = 0;
      for (var room in rooms.documents) {
        // Sum up totalParticipants from all rooms (approximation)
        totalListeners += room.data['totalParticipants'] ?? 0;
      }

      return totalListeners >= BadgeConstants.crowdFavoriteThreshold;
    } catch (e) {
      log('Error checking CROWD_FAVORITE badge: $e');
      return false;
    }
  }

  /// Check if user qualifies for CONVERSATIONALIST badge (10 pair chats)
  Future<bool> _checkConversationalistBadge(String userId) async {
    try {
      // Count pair chats where user is either sender or receiver
      var pairChats = await databases.listDocuments(
        databaseId: userDatabaseID,
        collectionId: activePairsCollectionId,
        queries: [
          Query.or([
            Query.equal('senderId', userId),
            Query.equal('receiverId', userId),
          ]),
        ],
      );
      return pairChats.documents.length >= BadgeConstants.conversationalistThreshold;
    } catch (e) {
      log('Error checking CONVERSATIONALIST badge: $e');
      return false;
    }
  }

  /// Check if user qualifies for AUDIOPHILE badge (10 hours of listening)
  Future<bool> _checkAudiophileBadge(String userId) async {
    try {
      // Get total listening time from user document
      // Note: This assumes listening time is tracked in the user document
      // If not, we may need to calculate from room participation history
      Document userDoc = await databases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: userId,
      );

      // Check if totalListeningTimeHours exists in user document
      double? totalListeningTimeHours =
          (userDoc.data['totalListeningTimeHours'] as num?)?.toDouble();

      if (totalListeningTimeHours == null) {
        // If not tracked, return false (can be enhanced later)
        return false;
      }

      return totalListeningTimeHours >=
          BadgeConstants.audiophileThresholdHours;
    } catch (e) {
      log('Error checking AUDIOPHILE badge: $e');
      return false;
    }
  }

  /// Get badges for a user
  Future<List<String>> getUserBadges(String userId) async {
    try {
      Document userDoc = await databases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: userId,
      );
      return List<String>.from(userDoc.data['badges'] ?? []);
    } catch (e) {
      log('Error getting badges for user $userId: $e');
      return [];
    }
  }
}

