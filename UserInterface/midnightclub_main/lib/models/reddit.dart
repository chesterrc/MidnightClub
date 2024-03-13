class SubmittedID {
  final String author;
  final String name;
  final String score;
  final String selftext;
  final String image;

  SubmittedID({
    required this.author,
    required this.name,
    required this.score,
    required this.selftext,
    required this.image,
  });

  factory SubmittedID.fromJson(Map<String, dynamic> json) {
    return SubmittedID(
      author: json["author"],
      name: json["name"],
      score: json["score"],
      selftext: json["selftext"],
      image: json["image"],
    );
  }
}

class RedditModel {
  final SubmittedID post;

  const RedditModel({
    required this.post,
  });

  factory RedditModel.fromJson(Map<String, dynamic> json) {
    return RedditModel(post: json['post']);
  }
}
