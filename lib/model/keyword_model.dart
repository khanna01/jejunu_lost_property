class KeywordModel {
  final String userEmail;
  final String? userKeyword;
  final String keywordId;

  KeywordModel({
    required this.userEmail,
    required this.userKeyword,
    required this.keywordId,
  });

  // JSON으로부터 모델을 만드는 생성자
  KeywordModel.fromJson({
    required Map<String, dynamic> json,
  })  : userEmail = json['userEmail'],
        userKeyword = json["userKeyword"],
        keywordId = json["keywordId"];

  // 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'userKeyword': userKeyword,
      'keywordId': keywordId,
    };
  }
}
