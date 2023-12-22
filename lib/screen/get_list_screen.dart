import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:intl/intl.dart';
import 'package:jejunu_lost_property/screen/detail_screen.dart';
import '../model/find_list_model.dart';
import 'find_search_screen.dart';
import 'get_list_load_screen.dart';
import 'get_search_screen.dart';

class GetListScreen extends StatefulWidget {
  const GetListScreen({Key? key}) : super(key: key);

  @override
  State<GetListScreen> createState() => _GetListScreenState();
}

class _GetListScreenState extends State<GetListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar 제목
        title: Text('습득물 목록',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 23,
            )),
        // AppBar 배경색
        backgroundColor: Colors.grey[400],
        elevation: 4,
        actions: [
          // 글 작성 화면으로 이동하는 버튼
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GetListLoadScreen(),
                  ));
            },
          ),
          // 검색 화면으로 이동하는 버튼
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GetSearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      // Stream으로 값을 받아서 화면에 보여주기 위해 StreamBuilder 사용
      body: StreamBuilder<QuerySnapshot>(
          // 파이어스토어에서 findlist 컬렉션 정보 가져오기
          // 데이터가 변경될 때마다 실시간으로 컬렉션 업데이트받기 위한 Stream 사용
          stream: FirebaseFirestore.instance
              .collection('getlist')
              .orderBy('createdTime', descending: true) // 작성시간 최신순으로 정렬
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
            }

            // 성공적으로 가져온 경우 실행
            // 컬렉션에 문서가 있는 경우
            if (snapshot!.hasData && snapshot.data!.docs.isNotEmpty) {
              // FindListModel로 데이터를 매핑하여 리스트 형태 저장
              final getlists = snapshot.data!.docs
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
                      final getlist = getlists[index];
                      final findCreatedTime = DateFormat('MM/dd  HH:ss')
                          .format(getlist.createdTime);
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
                                  (getlist.placeAddress.contains('대한민국'))
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
                                              getlist.placeAddress, // 위치
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                  Text(
                                    getlist.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                getlist.content,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              trailing: getlist!.picUrl != null
                                  ? Image.network(getlist!.picUrl!)
                                  : Container(width: 0, height: 0),
                              onTap: () {
                                // 클릭하면 상세화면으로 이동, 현재 글 정보를 넘겨줌
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(lists: getlist)),
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
