import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jejunu_lost_property/component/auth_service.dart';
import 'package:jejunu_lost_property/screen/detail_screen.dart';
import 'package:jejunu_lost_property/screen/root_screen.dart';
import 'package:provider/provider.dart';
import 'package:jejunu_lost_property/screen/sign_up_screen.dart';
import '../component/appbar.dart';
import 'package:jejunu_lost_property/model/find_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class BookMarkListScreen extends StatefulWidget {
  const BookMarkListScreen({Key? key}) : super(key: key);

  @override
  State<BookMarkListScreen> createState() => _BookMarkListScreenState();
}

class _BookMarkListScreenState extends State<BookMarkListScreen> {
  late String uid = '';
  late final FindListModel lists;
  var currentUserEmail = FirebaseAuth.instance.currentUser?.email;

  Future<void> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    getUid();

    return Scaffold(
      appBar: RenderAppBar(title: "북마크 목록"),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookmark')
              .where('userEmail', isEqualTo: currentUserEmail)
              .orderBy('createdTime', descending: true) // 작성시간 최신순으로 정렬
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("목록을 가져오지 못했습니다."),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              CircularProgressIndicator();
            }
            if (snapshot!.hasData && snapshot.data!.docs.isNotEmpty) {
              final bookmarklists = snapshot.data!.docs
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
                      final bookmarklist = bookmarklists[index];
                      final findCreatedTime = DateFormat('MM/dd  HH:ss')
                          .format(bookmarklist.createdTime);

                      return Column(
                        children: [
                          SizedBox(
                            height: 70,
                            child: ListTile(
                              title: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 건물이 아니면 위치정보가 안보이도록
                                  (bookmarklist.placeAddress.contains('대한민국') ||
                                          bookmarklist.placeAddress.length != 0)
                                      ? Text(
                                          '${findCreatedTime}', // 글 작성 시간
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.grey),
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              '${findCreatedTime}  ∣', // 글 작성 시간
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.room,
                                              size: 12,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              bookmarklist.placeAddress, // 위치
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                  Text(
                                    bookmarklist.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                bookmarklist.content,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              trailing: bookmarklist!.picUrl != null
                                  ? Image.network(bookmarklist!.picUrl!)
                                  : Container(width: 0, height: 0),
                              onTap: () {
                                // 클릭하면 상세화면으로 이동, 현재 글 정보를 넘겨줌
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(lists: bookmarklist)),
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
                  child: Text("북마크에 추가한 글이 없습니다."),
                ),
              );
            }
          }),
    );
  }
}
