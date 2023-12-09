import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jejunu_lost_property/screen/root_screen.dart';
import 'package:jejunu_lost_property/screen/sign_in_screen.dart';
import 'package:provider/provider.dart';

import 'component/auth_service.dart';
import 'const/navigation_colors.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리.. ${message.notification!.body!}");
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));
  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  ));

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> main() async {
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding
      .ensureInitialized(); // 프레임워크가 완전히 부팅될 때까지 위젯이 실행되지 않도록 하는 함수
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // firebase_options.dart 파일에 설정된 프로젝트 설정으로 초기화하여 플러터와 파이어베이스 프로젝트 연결
  initializeNotification();
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

  //void initState() {}

  @override
  Widget build(BuildContext context) {
    //현재 로그인한 유저를 조회
    User? user = context.read<AuthService>().currentUser();
    if (user != null) {
      updateUser(user.email!);
    }
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
      // 유저정보가 있으면 홈 화면으로 이동, 유저정보가 없으면 로그인 화면으로 이동
      home: user == null ? SignInScreen() : RootScreen(),
    );
    //HomeScreen();
  }

  // 자동로그인 시에도 기기로 알림을 보낼 수 있도록 하는 fcmtoken을 가져와 user 컬렉션 문서에 업데이트
  void updateUser(String user) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user)
        .update({'fcmToken': fcmToken});
  }
}
