class AppwriteUpcommingRoom {
  AppwriteUpcommingRoom({
    required this.id,
    required this.name,
    required this.isTime,
    required this.scheduledDateTime,
    required this.description,
    required this.totalSubscriberCount,
    required this.tags,
    required this.subscribersAvatarUrls,
    required this.userIsCreator,
    required this.hasUserSubscribed,
  });
  late final String id;
  late final String name;
  late final bool isTime;
  late final DateTime scheduledDateTime;
  late final String description;
  late final int totalSubscriberCount;
  late final List tags;
  late final List<String> subscribersAvatarUrls;
  late final bool userIsCreator;
  // Only matters if user is not a creator (if not a creator has he subscribed or not)
  late final bool hasUserSubscribed;
}
