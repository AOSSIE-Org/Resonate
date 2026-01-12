class BadgeConstants {
  static const String anchor = 'ANCHOR';
  static const String storyteller = 'STORYTELLER';
  static const String crowdFavorite = 'CROWD_FAVORITE';
  static const String conversationalist = 'CONVERSATIONALIST';
  static const String audiophile = 'AUDIOPHILE';

  // This maps the ID to the image file
  static const Map<String, String> icons = {
    anchor: 'assets/badges/anchor.png',
    storyteller: 'assets/badges/storyteller.png',
    crowdFavorite: 'assets/badges/crowdfav.png',
    conversationalist: 'assets/badges/conversationalist.png',
    audiophile: 'assets/badges/audiophile.png',
  };

  // This maps the ID to the text description (tooltip)
  static const Map<String, String> tooltips = {
    anchor: 'The Anchor: Hosted 5 Rooms',
    storyteller: 'The Storyteller: Published 1 Story',
    crowdFavorite: 'Crowd Favorite: 100 Listeners',
    conversationalist: 'Conversationalist: 10 Pair Chats',
    audiophile: 'Audiophile: 10 Hours Listening',
  };
}