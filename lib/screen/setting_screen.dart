import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:jejunu_lost_property/component/auth_service.dart';
import 'package:jejunu_lost_property/screen/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
