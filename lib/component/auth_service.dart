import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // 현재 로그인 된 유저를 조회하는 함수
  User? currentUser() {
    // 로그인하지 않은 경우 null 반환
    return FirebaseAuth.instance.currentUser;
  }

  // 회원가입 함수
  void signUp({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function onSuccess, // 가입 성공하면 호출되는 함수
    required Function(String err) onError, //  에러가 발생하면 호출되는 함수
  }) async {
    // 이메일 및 비밀번호 입력 여부 확인
    if (email.isEmpty) {
      onError("이메일을 입력해 주세요.");
      return;
    } else if (password.isEmpty) {
      onError("비밀번호를 입력해 주세요.");
      return;
    }

    // Firebase Auth 회원 가입 요청
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess(); // 성공 함수 호출
    } on FirebaseAuthException catch (e) {
      // Firebase Auth 에러 발생
      if (e.code == 'weak-password') {
        onError('비밀번호를 6자리 이상 입력해 주세요.');
      } else if (e.code == 'email-already-in-use') {
        onError('이미 가입된 이메일 입니다.');
      } else if (e.code == 'invalid-email') {
        onError('이메일 형식을 확인해 주세요.');
      } else {
        onError(e.message!);
      }
    } catch (e) {
      // Firebase Auth 이외의 에러 발생
      onError(e.toString());
    }
  }

  // 로그인 함수
  void signIn({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function onSuccess, // 로그인 성공하면 호출되는 함수
    required Function(String err) onError, // 에러가 발생하면 호출되는 함수
  }) async {
    // 이메일 및 비밀번호 입력 여부 확인
    if (email.isEmpty) {
      onError('이메일을 입력해주세요.');
      return;
    } else if (password.isEmpty) {
      onError('비밀번호를 입력해주세요.');
      return;
    }

    // Firebase Auth 로그인 요청
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess(); // 성공 함수 호출
      notifyListeners(); // 로그인 상태 변경 알림
    } on FirebaseAuthException catch (e) {
      // Firebase Auth 에러 발생
      if (e.code == 'user-not-found') {
        onError('등록된 이메일이 아닙니다.');
      } else if (e.code == 'wrong-password') {
        onError('비밀번호가 일치하지 않습니다.');
      } else {
        onError(e.message!);
      }
    } catch (e) {
      // Firebase Auth 이외의 에러 발생
      onError(e.toString());
    }
  }

// 로그아웃 함수
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners(); // 로그인 상태 변경 알림
  }
}
