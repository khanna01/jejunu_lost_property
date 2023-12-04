
import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:provider/provider.dart';
import '../component/auth_service.dart';

class ChangeProfileScreen extends StatefulWidget {
  const ChangeProfileScreen({Key? key}) : super(key: key);

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
        builder: (context, authService, child) {
          return Scaffold(
            appBar: RenderAppBar(title: "비밀번호 변경"),
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
                        height: 20.0,
                      ),
                      // 현재 비밀번호 입력창
                      TextField(
                        controller: currentPasswordController,
                        obscureText: true, // 비밀번호 안보이게 설정
                        decoration: const InputDecoration(
                            hintText: "현재 비밀번호", border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 5),

                      // 비밀번호 입력창
                      TextField(
                        controller: passwordController,
                        obscureText: true, // 비밀번호 안보이게 설정
                        decoration: const InputDecoration(
                            hintText: "새로운 비밀번호", border: OutlineInputBorder()),
                      ),

                      // 비밀번호 변경 버튼
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600]),
                        onPressed: () {
                          /*if (_changePassword(currentPasswordController.text, passwordController.text) == true) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("비밀번호를 변경했습니다."),
                            ));*/
                        _changePassword(currentPasswordController.text, passwordController.text);
                          },
                        child: const Text(
                            "비밀번호 변경", style: TextStyle(fontSize: 21)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}

// 비밀번호 변경 함수
Future<bool> _changePassword(String currentPassword, String newPassword) async {
  bool success = false;
  var user = await FirebaseAuth.instance.currentUser!;

  final cred = await EmailAuthProvider.credential(email: user.email!,
    password: currentPassword);
  await user.reauthenticateWithCredential(cred).then((value) async {
  await user.updatePassword(newPassword).then((_) {
    success = true;
  }).catchError((error) {
    print(error);
  });
  }).catchError((err) {
    print(err);
  });

  /*ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(
      content: Text("비밀번호를 변경했습니다.");*/

  return success;
}
