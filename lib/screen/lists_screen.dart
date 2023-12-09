import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/screen/my_list_get_screen.dart';
import 'my_list_screen.dart';

// 게시판별로 작성한 글 목록을 탭바를 통해 보여주는 화면
class ListsScreen extends StatefulWidget {
  const ListsScreen({Key? key}) : super(key: key);

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // debug banner 안보이게
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '작성한 글',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 23,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: ColoredBox(
                color: Colors.white,
                child: const TabBar(
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                  indicatorColor: Colors.grey,
                  tabs: [
                    Tab(
                      text: '잃어버린 분 게시판',
                    ),
                    Tab(
                      text: '발견하신 분 게시판',
                    )
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.grey[400],
            iconTheme: IconThemeData(
              color: Colors.black, //색변경
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              // 잃어버린분 게시판에 작성한 글 목록을 보여주는 화면
              MyListScreen(),
              // 발견하신 분 게시판에 작성한 글 목록을 보여주는 화면
              MyListGetScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
