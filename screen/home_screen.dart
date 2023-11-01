import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/main.dart';
import 'package:jejunu_lost_property/screen/find_list_load_screen.dart';
import 'package:jejunu_lost_property/screen/find_list_screen.dart';
import 'package:jejunu_lost_property/screen/root_screen.dart';
import 'package:jejunu_lost_property/component/appbar.dart';

import 'map_screen.dart';

// 홈 화면 위젯
// 게시판 - 선택 화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // debug banner 안보이게
      home: Scaffold(
        appBar: RenderAppBar(
          title: '홈',
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              child: Image.asset('assets/images/logo.png'),
            ),
            Center(
              child: Text("해당 게시판으로 이동"),
            ),
            SizedBox(height: 30, width: double.infinity), // 수평정렬을 위한 Sizebox
            Container(
              height: 120,
              width: 300,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.pink)
                    //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FindListLoadScreen()), // 테스트용 네이게이션
                  );
                },
                child: const Text(
                  "분실하신 분",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50, width: double.infinity), // 수평정렬을 위한 Sizebox
            Container(
              height: 120,
              width: 300,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue)
                    //padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FindListScreen()), // 테스트용 네이게이션
                  );
                },
                child: const Text(
                  "발견하신 분",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
Navigator.push(
context,
MaterialPageRoute(builder: (context) => MapScreen()),
);

 */
