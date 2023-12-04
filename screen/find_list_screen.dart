import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:jejunu_lost_property/screen/detail_screen.dart';

import '../model/find_list_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import 'dart:io';

class FindListScreen extends StatefulWidget {
  const FindListScreen({Key? key}) : super(key: key);

  @override
  State<FindListScreen> createState() => _FindListScreenState();
}

class _FindListScreenState extends State<FindListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RenderAppBar(title: "잃어버린분"),
      // Stream으로 값을 받아서 화면에 보여주기 위해 StreamBuilder 사용
      body: StreamBuilder<QuerySnapshot>(
          // 파이어스토어에서 findlist 컬렉션 정보 가져오기
          // 데이터가 변경될 때마다 실시간으로 컬렉션 업데이트받기 위한 Stream 사용
          stream: FirebaseFirestore.instance
              .collection('findlist3')
              .orderBy('title', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            // 가져오는 동안 에러가 발생하면 보여줄 메세지 화면
            if (snapshot.hasError) {
              return Center(
                child: Text("목록을 가져오지 못했습니다."),
              );
            }

            // 로딩 화면
            if (snapshot.connectionState == ConnectionState.waiting) {
              const CircularProgressIndicator();
              //return Container(child: CircularProgressIndicator());
            }

            // 성공적으로 가져온 경우 실행
            // 컬렉션에 문서가 있는 경우
            if (snapshot!.hasData && snapshot.data!.docs.isNotEmpty) {
              // FindListModel로 데이터를 매핑하여 리스트 형태 저장
              final findlists = snapshot.data!.docs
                  .map(
                    (QueryDocumentSnapshot e) => FindListModel.fromJson(
                        json: (e.data() as Map<String, dynamic>)),
                  )
                  .toList();

              return Scaffold(
                body: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      final findlist = findlists[index];

                      return Column(
                        children: [
                          SizedBox(
                            height: 80,
                            child: ListTile(
                              title: Text(
                                findlist.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                findlist.content,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              trailing: findlist!.picUrl != null
                                  ? Image.network(findlist!.picUrl!)
                                  : Container(width: 0, height: 0),
                              onTap: () {
                                // 클릭하면 상세화면으로 이동, 현재 글 정보를 넘겨줌
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(lists: findlist)),
                                );
                              },
                            ),
                          ),
                          Divider(
                            thickness: 1.0,
                          )
                        ],
                      );
                    }),
              );
            } else {
              // 컬렉션에 문서가 없는 경우
              return Scaffold(
                body: Center(
                  child: Text("등록된 글이 없습니다."),
                ),
              );
            }
          }),
    );
  }
}
