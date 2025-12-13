/// Badge constants for the gamification system.
/// Badges are stored as uppercase strings in the user's Appwrite document.
class BadgeConstants {
  // Badge type constants
  static const String anchor = 'ANCHOR';
  static const String storyteller = 'STORYTELLER';
  static const String crowdFavorite = 'CROWD_FAVORITE';
  static const String conversationalist = 'CONVERSATIONALIST';
  static const String audiophile = 'AUDIOPHILE';

  // Badge thresholds
  static const int anchorThreshold = 5; // Hosted 5 rooms
  static const int storytellerThreshold = 1; // Published 1 story
  static const int crowdFavoriteThreshold = 100; // 100 total listeners
  static const int conversationalistThreshold = 10; // 10 pair chats
  static const int audiophileThresholdHours = 10; // 10 hours of listening

  // Badge descriptions for tooltips
  static String getBadgeDescription(String badge) {
    switch (badge) {
      case anchor:
        return 'Hosted 5 Rooms';
      case storyteller:
        return 'Published 1 Story';
      case crowdFavorite:
        return '100 Total Listeners';
      case conversationalist:
        return '10 Pair Chats';
      case audiophile:
        return '10 Hours of Listening';
      default:
        return '';
    }
  }

  // All available badges
  static const List<String> allBadges = [
    anchor,
    storyteller,
    crowdFavorite,
    conversationalist,
    audiophile,
  ];
}

