import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/screen/home_screen.dart';
import 'package:jejunu_lost_property/screen/map_screen.dart';
import 'package:jejunu_lost_property/screen/setting_screen.dart';

// BottomNavigationBar를 설정하는 화면 위젯
class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller; // TabController

  @override
  void initState() {
    super.initState();

    // controller 초기화
    controller = TabController(length: 3, vsync: this);

    // controller 속성이 변경될 때마다 실행할 함수 등록
    controller!.addListener(tabListener);
  }

  // 리스너로 사용할 함수
  tabListener() {
    setState(() {});
  }

  // 리스너에 등록한 함수 등록 취소 함수
  @override
  void dispose() {
    controller!.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller, // controller 등록하여 TabBarView 조작
        // 탭 화면을 보여줄 위젯
        children: renderChildren(),
      ),
      //탭 네이게이션 구현 매개변수
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  //
  List<Widget> renderChildren() {
    return [
      // 홈 화면
      HomeScreen(),
      // 지도 화면
      MapScreen(),
      // 설정 화면
      SettingScreen(),
    ];
  }

  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
        // 탭 Icon과 Label을 모두 보이도록 설정
        type: BottomNavigationBarType.fixed,
        // 현재 화면에 렌더링되는 탭의 인덱스
        currentIndex: controller!.index,
        onTap: (int index) {
          // 탭이 선택될 때마다 실행되는 함수
          setState(() {
            controller!.animateTo(index);
          });
        },
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        iconSize: 35.0,
        // BottomNavigation 목록 아이콘과 이름 설정
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.room,
            ),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: '설정',
          ),
        ]);
  }
}
