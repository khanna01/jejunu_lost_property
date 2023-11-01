import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:jejunu_lost_property/screen/sign_in_screen.dart';

//회원가입 화면 위젯
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        //User? user = authService.currentUser();
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
                    obscureText: true, // 비밀번호 안보이게
                    decoration: const InputDecoration(
                        hintText: "비밀번호", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 32),
                  // 회원가입 버튼
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    ),
                    onPressed: () {
                      // 회원가입
                      authService.signUp(
                        email: emailController.text,
                        password: passwordController.text,
                        // 회원가입 성공
                        onSuccess: () {
                          // 회원가입 완료 메세지
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("회원가입 완료"),
                          ));
                          // 로그인 화면으로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()),
                          );
                        },
                        // 회원가입 실패
                        onError: (err) {
                          // 에러 발생
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err),
                          ));
                        },
                      );
                    },
                    child: const Text("회원가입", style: TextStyle(fontSize: 21)),
                  ),
                ],
              ),
            ),
          ],
        ));
      },
    );
  }
}
