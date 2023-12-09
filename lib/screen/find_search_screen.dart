import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:jejunu_lost_property/screen/detail_screen.dart';
import '../model/find_list_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: '검색어를 입력하세요..',
          ),
        ),
        backgroundColor: Colors.grey[400],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('lostlist').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("목록을 가져오지 못했습니다.오류:${snapshot.error}"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(), // 이 부분 수정
              );
            }

            if (snapshot!.hasData && snapshot.data!.docs.isNotEmpty) {
              // FindListModel로 데이터를 매핑하여 리스트 형태 저장
              final lostlists = snapshot.data!.docs
                  .map((QueryDocumentSnapshot e) => FindListModel.fromJson(
                      json: (e.data() as Map<String, dynamic>)))
                  .toList();

              // 아무것도 입력하지 않은 경우 빈화면으로 뜨도록 초기 빈리스트로 설정
              List<FindListModel> lostLists = [];
              // 입력하면 해당하는 글자가 포함된 글목록을 보여준다
              if (_searchController.text.length >= 1) {
                lostLists = lostlists
                    .where((element) =>
                        element.title.contains(_searchController.text) ||
                        element.content.contains(_searchController.text))
                    .toList();
              }

              return Scaffold(
                body: ListView.builder(
                    itemCount: lostLists.length, //snapshot.data!.size,
                    itemBuilder: (context, index) {
                      final lostlist = lostLists[index];
                      final lostCreatedTime = DateFormat('MM/dd  HH:ss')
                          .format(lostlist.createdTime);
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
                                  (lostlist.placeAddress.contains('대한민국') ||
                                          lostlist.placeAddress.length == 0)
                                      ? Text(
                                          '${lostCreatedTime}', // 글 작성 시간
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.grey),
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              '${lostCreatedTime}  ∣', // 글 작성 시간
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
                                              lostlist.placeAddress, // 위치
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                  Text(
                                    lostlist.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                lostlist.content,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              trailing: lostlist!.picUrl != null
                                  ? Image.network(lostlist!.picUrl!)
                                  : Container(width: 0, height: 0),
                              onTap: () {
                                // 클릭하면 상세화면으로 이동, 현재 글 정보를 넘겨줌
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(lists: lostlist)),
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
