import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:jejunu_lost_property/screen/setting_screen.dart';
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
  //final FormFieldValidator<String> validator;
  final TextEditingController _notificationController = TextEditingController();
  String? userEmail = '';
  String? userKeyword = '';
  String? keywordId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                decoration: InputDecoration(labelText: '키워드 입력'),
                //readOnly: true,
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
                },
              )
            ],
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

        QuerySnapshot findList1Snapshot = await FirebaseFirestore.instance
            .collection('findlist1')
            .where('userEmail', isEqualTo: userEmail)
            .get();

        if (findList1Snapshot.docs.isNotEmpty) // keyword 컬렉션의 userKeyword 호출
          QuerySnapshot keywordSnapshot = await FirebaseFirestore.instance
              .collection('keyword')
              .where('userEmail', isEqualTo: userEmail)
              .get();
      } catch (e) {
        print("오류:$e");
      }
    }

    Navigator.of(context).pop();
  }

  // 값을 입력했는지 확인
  String? textValidator(String? val) {
    if (val == null || val.length == 0) {
      return '값을 입력해주세요';
    }
    return null;
  }
}
