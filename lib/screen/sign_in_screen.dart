import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:jejunu_lost_property/component/auth_service.dart';
import 'package:jejunu_lost_property/screen/root_screen.dart';
import 'package:provider/provider.dart';
import 'package:jejunu_lost_property/screen/sign_up_screen.dart';

// 로그인 화면 위젯
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 35.0, right: 35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      "제대로 찾기",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  // 이메일 입력창
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: "이메일", border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // 비밀번호 입력창
                  TextField(
                    controller: passwordController,
                    obscureText: true, // 비밀번호 안보이게 설정
                    decoration: const InputDecoration(
                        hintText: "비밀번호", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 32),
                  // 로그인 버튼
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600]),
                    onPressed: () {
                      // 로그인
                      authService.signIn(
                        email: emailController.text,
                        password: passwordController.text,
                        onSuccess: () async {
                          // 기기로 알림을 보낼 수 있도록 로그인할 때마다 fcmtoken을 가져와 user 컬렉션 문서에 업데이트
                          String? fcmToken =
                              await FirebaseMessaging.instance.getToken();
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(emailController.text)
                              .update({'fcmToken': fcmToken});

                          // 로그인 성공하면 홈 화면으로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RootScreen()),
                          );
                        },
                        onError: (err) {
                          // 스낵바로 에러 메세지 출력
                          print(err);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err),
                          ));
                        },
                      );
                    },
                    child: const Text("로그인", style: TextStyle(fontSize: 21)),
                  ),

                  // 회원가입 버튼
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600]),
                    onPressed: () {
                      // 버튼 누르면 회원가입 화면으로 이동
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: const Text("회원가입", style: TextStyle(fontSize: 21)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
