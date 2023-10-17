import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jejunu_lost_property/screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jejunu_lost_property/screen/root_screen.dart';
import 'package:jejunu_lost_property/screen/sign_in_screen.dart';
import 'package:provider/provider.dart';

import 'component/auth_service.dart';
import 'const/navigation_colors.dart';
import 'firebase_options.dart';

void main() async {
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // firebase 앱 시작
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = context.read<AuthService>().currentUser();
    //print(user);
    //print(Type);
    return MaterialApp(
      debugShowCheckedModeBanner: false, // debug banner 안보이게
      theme: ThemeData(
        // BottomNavigationBar 테마 설정
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: backgroundColor,
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryColor,
        ),
      ),
      // 자동로그인
      // 유저정보가 있으면 홈 화면으로 이동
      // //유저정보가 없으면 로그인 화면으로 이동
      home: user == null ? SignInScreen() : RootScreen(),
    );
    //HomeScreen();
  }
}
