const int kPollOptionAvatarCap = 5;

class VoterProfile {
  const VoterProfile({
    required this.uid,
    required this.name,
    this.avatarUrl,
  });

  final String uid;
  final String name;
  final String? avatarUrl;
}
