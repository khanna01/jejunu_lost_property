import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:jejunu_lost_property/component/auth_service.dart';
import 'package:jejunu_lost_property/screen/change_profile.dart';
import 'package:jejunu_lost_property/screen/lists_screen.dart';
import 'package:jejunu_lost_property/screen/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'bookmark_list_screen.dart';
import 'notification_screen.dart';

// 설정 화면 위젯
class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RenderAppBar(title: '설정'),
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15.0,
              ),
              Container(
                // 프로필 편집
                height: 48,
                width: double.maxFinite,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeProfileScreen()),
                    );
                  },
                  child: const Text(
                    "비밀번호 변경",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ), // 프로필 편집
              Container(
                // 작성한 글 목록
                height: 48,
                width: double.maxFinite,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListsScreen()),
                    );
                  },
                  child: const Text(
                    "작성한 글 목록",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ), // 작성한 글 목록
              Container(
                // 북마크 목록
                height: 48,
                width: double.maxFinite,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  onPressed: () {
                    // 북마크 목록 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookMarkListScreen()),
                    );
                  },
                  child: const Text(
                    "북마크 목록",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                // 분실물 알림
                height: 48,
                width: double.maxFinite,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()),
                    );
                  },
                  child: const Text(
                    "분실물 키워드 알림 등록",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                // 로그아웃
                height: 48,
                width: double.maxFinite,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  onPressed: () {
                    // 로그아웃
                    context.read<AuthService>().signOut();
                    // 로그인 페이지로 이동
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: const Text(
                    "로그아웃",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ), // 로그아웃
            ],
          ),
        ),
      ),
    );
  }
}
