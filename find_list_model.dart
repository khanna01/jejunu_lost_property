import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FindListModel with ChangeNotifier {
  final String id;
  final String? userEmail;
  final String title;
  //final DateTime createdTime;
  final String placeAddress;
  final double latitude;
  final double longitude;
  final String content;
  final String? picUrl;

  FindListModel({
    required this.id,
    required this.userEmail,
    required this.title,
    //required this.createdTime,
    required this.placeAddress,
    required this.latitude,
    required this.longitude,
    required this.content,
    required this.picUrl,
  });

  // JSON으로부터 모델을 만드는 생성자
  FindListModel.fromJson({
    required Map<String, dynamic> json,
  })  : id = json['id'],
        userEmail = json['userEmail'],
        title = json['title'],
        //createdTime = json['createdTime'],
        placeAddress = json['placeAddress'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        content = json['content'],
        picUrl = json['picUrl'];

  // 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userEmail': userEmail,
      'title': title,
      //'createdTime': createdTime,
      'placeAddress': placeAddress,
      'latitude': latitude,
      'longitude': longitude,
      'content': content,
      'picUrl': picUrl
    };
  }

  late CollectionReference cartReference;
  List<FindListModel> cartItems = [];

  Future<void> fetchCartItemsOrCreate(String uid) async {
    if (uid == ''){
      return ;
    }
    final cartSnapshot = await cartReference.doc(uid).get();
    if(cartSnapshot.exists) {
      Map<String, dynamic> cartItemsMap = cartSnapshot.data() as Map<String, dynamic>;
      List<FindListModel> temp = [];
      for (var item in cartItemsMap['items']) {
        temp.add(FindListModel.fromJson(json: {}));
      }
      cartItems = temp.cast<FindListModel>();
      notifyListeners();
    } else {
      await cartReference.doc(uid).set({'items': []});
      notifyListeners();
    }
  }

  Future<void> addCartItem(String uid, FindListModel item) async {
    cartItems.add(item);
    Map<String, dynamic> cartItemsMap = {
      'items': cartItems.map( (item) {
        return item.toJson();
      }).toList()
    };
    await cartReference.doc(uid).set(cartItemsMap);
    notifyListeners();
  }

  Future<void> removeCartItem(String uid, FindListModel item) async { //FindListModel 이 맞나?
    cartItems.removeWhere((element) => element.id == item.id);
    Map<String, dynamic> cartItemsMap = {
      'items': cartItems.map((item) {
        return item.toJson();
      }).toList()
    };
    await cartReference.doc(uid).set(cartItemsMap);
    notifyListeners();
  }

  bool isCartItemIn(FindListModel item) {
    return cartItems.any((element) => element.id == item.id);
  }

}



enum AuthStatus { registerSuccess, registerFail, loginSuccess, loginFail }

class FirebaseAuthProvider with ChangeNotifier {
  FirebaseAuth authClient;
  User? user;

  FirebaseAuthProvider({auth}) : authClient = auth ?? FirebaseAuth.instance;

  Future<AuthStatus> registerWithEmail(String email, String password) async {
    try {
      UserCredential credential = await authClient
          .createUserWithEmailAndPassword(email: email, password: password);
      return AuthStatus.registerSuccess;
    } catch (e) {
      return AuthStatus.registerFail;
    }
  }

  Future<AuthStatus> loginWithEmail(String email, String password) async {
    try {
      await authClient
          .signInWithEmailAndPassword(email: email, password: password)
          .then((credential) async {
        user = credential.user;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLogin', true);
        prefs.setString('email', email);
        prefs.setString('password', password);
        prefs.setString('uid', user!.uid);
      });
      return AuthStatus.loginSuccess;
    } catch (e) {
      return AuthStatus.loginFail;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
    prefs.setString('email', '');
    prefs.setString('password', '');
    prefs.setString('uid', '');
    user = null;
    await authClient.signOut();
  }
}
