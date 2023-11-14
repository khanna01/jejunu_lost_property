
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:jejunu_lost_property/screen/detail_screen.dart';


import '../model/find_list_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import 'dart:io';
import 'package:algolia/algolia.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            title:
            TextField(

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

      body: StreamBuilder <QuerySnapshot>(

        stream: FirebaseFirestore.instance.collection('findlist1').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(
              child: Text("목록을 가져오지 못했습니다.오류:${snapshot.error}"),
            );
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(), // 이 부분 수정
            );
          }

          if(snapshot!.hasData && snapshot.data!.docs.isNotEmpty) {
           // FindListModel로 데이터를 매핑하여 리스트 형태 저장
            final findlists = snapshot.data!.docs
        .map(
               (QueryDocumentSnapshot e)
          => FindListModel.fromJson(
                    json: (e.data() as Map<String, dynamic>))
        )
         .toList();
        final findlists1 = findlists.where((element) => element.title.contains(_searchController.text) || element.content.contains(_searchController.text)).toList();


        return Scaffold(
          body: ListView.builder(
              itemCount: findlists1.length,//snapshot.data!.size,
              itemBuilder: (context, index) {
                final findlist = findlists1[index];

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

                //if( _containsAny(findlist.title, _searchController.text)||
                // _containsAny(findlist.content, _searchController.text)){


              })
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
  // 문자열에 주어진 단어 중 어느 하나라도 포함되어 있는지 확인하는 함수
}








