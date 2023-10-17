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

  FindListModel({
    required this.id,
    required this.userEmail,
    required this.title,
    //required this.createdTime,
    required this.placeAddress,
    required this.latitude,
    required this.longitude,
    required this.content,
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
        content = json['content'];

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
      'content': content
    };
  }

  // 현재 모델을 특정 속성만 변환해서 새로 생성
  FindListModel fromDocs(QueryDocumentSnapshot data) {
    Map<String, dynamic> info = data.data() as Map<String, dynamic>;
    return FindListModel(
      id: info['id'],
      userEmail: info['userEmail'],
      title: info['title'],
      //createdTime: info['createdTime'],
      placeAddress: info['placeAddress'],
      latitude: info['latitude'],
      longitude: info['longitude'],
      content: info['content'],
    );
  }

  factory FindListModel.fromDoc(QueryDocumentSnapshot data) {
    Map<String, dynamic> info = data.data() as Map<String, dynamic>;
    return FindListModel(
      id: info['id'],
      userEmail: info['userEmail'],
      title: info['title'],
      //createdTime: info['createTime'],
      placeAddress: info['placeAddress'],
      latitude: info['latitude'],
      longitude: info['longitude'],
      content: info['content'],
    );
  }
}
