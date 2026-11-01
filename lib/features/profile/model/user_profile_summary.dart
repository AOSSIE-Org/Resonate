class UserProfileSummary {
  const UserProfileSummary({
    required this.uid,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.rating,
    required this.followerCount,
  });

  final String uid;
  final String name;
  final String username;
  final String avatarUrl;
  final double rating;
  final int followerCount;
}
