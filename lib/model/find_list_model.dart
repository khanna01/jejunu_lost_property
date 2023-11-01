import 'package:cloud_firestore/cloud_firestore.dart';

class FindListModel {
  final String id;
  final String? userEmail;
  final String title;

  //final DateTime createdTime;
  final String placeAddress;
  final double latitude;
  final double longitude;
  final String content;
  final String? picUrl;

  FindListModel({
    required this.id,
    required this.userEmail,
    required this.title,
    //required this.createdTime,
    required this.placeAddress,
    required this.latitude,
    required this.longitude,
    required this.content,
    required this.picUrl,
  });

  // JSON으로부터 모델을 만드는 생성자
  FindListModel.fromJson({
    required Map<String, dynamic> json,
  })  : id = json['id'],
        userEmail = json['userEmail'],
        title = json['title'],
        //createdTime = json['createdTime'],
        placeAddress = json['placeAddress'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        content = json['content'],
        picUrl = json['picUrl'];


  // 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userEmail': userEmail,
      'title': title,
      //'createTime': createdTime,
      'placeAddress': placeAddress,
      'latitude': latitude,
      'longitude': longitude,
      'content': content,
      'picUrl': picUrl
    };
  }
}
