import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

import '../component/auth_service.dart';
import '../model/keyword_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController _notificationController = TextEditingController();
  final FocusNode notificationFocusNode = FocusNode();

  String? userEmail = '';
  String? userKeyword = '';
  String? keywordId = '';
  var messageString = "";

  void getMyDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();
  }

  @override
  void initState() {
    getMyDeviceToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            ),
          ),
        );
        if (mounted) {
          setState(() {
            messageString = message.notification!.body!;
            print("Foreground 메시지 수신: $messageString");
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        notificationFocusNode.unfocus(); // 키보드가 아닌 화면을 클릭하면 키보드가 사라지도록
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '키워드 알림',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 23,
            ),
          ),
          backgroundColor: Colors.grey[400],
          elevation: 4,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: textValidator,
                  controller: _notificationController,
                  focusNode: notificationFocusNode,
                  decoration: InputDecoration(labelText: '키워드 입력'),
                  onSaved: (String? val) {
                    userKeyword = val;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('키워드 등록'), //등록 시 keyword컬렉션에 저장
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(35),
                      ))),
                  onPressed: () {
                    notificationSubmit();
                    notificationFocusNode.unfocus();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void notificationSubmit() async {
    //키워드 등록 버튼 누를 때 함수
    User? user = AuthService().currentUser();
    String? userEmail = user?.email; //유저 이메일
    String? userKeyword = _notificationController.text; //받는 키워드

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final keyword = KeywordModel(
        userEmail: userEmail!,
        userKeyword: userKeyword,
        keywordId: Uuid().v4(),
      );

      try {
        //keyword collection 생성
        await FirebaseFirestore.instance
            .collection('keyword')
            .doc(keyword.keywordId)
            .set(keyword.toJson());
      } catch (e) {
        print("오류:$e");
      }
    }

    // 키워드 등록하면 글자 삭제
    _notificationController.clear();
    // 등록하면 이전 화면으로 이동
    //Navigator.of(context).pop();
  }

  // 값을 입력했는지 확인
  String? textValidator(String? val) {
    if (val == null || val.length == 0) {
      return '값을 입력해주세요';
    }
    return null;
  }
}
