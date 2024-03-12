class RewardModel {
  final String uid;
  final int reward;

  const RewardModel({
    required this.uid,
    required this.reward,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'uid': String uid,
        'reward': int reward,
      } =>
        RewardModel(uid: uid, reward: reward),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
