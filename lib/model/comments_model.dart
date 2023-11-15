class CommentModel {
  final String postId;
  final String commentId;
  final String? userEmail;
  final DateTime createdTime;
  final String content;

  CommentModel({
    required this.postId,
    required this.commentId,
    required this.userEmail,
    required this.createdTime,
    required this.content,
  });

  // JSON으로부터 모델을 만드는 생성자
  CommentModel.fromJson({
    required Map<String, dynamic> json,
  })  : postId = json['postId'],
        commentId = json['commentId'],
        userEmail = json['userEmail'],
        createdTime = json["createdTime"].toDate(),
        content = json['content'];

  // 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'commentId': commentId,
      'userEmail': userEmail,
      'createdTime': createdTime,
      'content': content,
    };
  }
}
