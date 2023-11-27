import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/auth_service.dart';
import 'package:jejunu_lost_property/screen/detail_screen.dart';
import 'package:jejunu_lost_property/screen/root_screen.dart';
import 'package:provider/provider.dart';
import 'package:jejunu_lost_property/screen/sign_up_screen.dart';
import '../component/appbar.dart';
import 'package:jejunu_lost_property/model/find_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class BookMarkListScreen extends StatelessWidget {
  late String uid = '';
  late final FindListModel lists;

  Future<void> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    //final cartProvider = Provider.of<FindListModel>(context);
    getUid();

    return Scaffold(
      appBar: RenderAppBar(title: "북마크 목록"),
      body: StreamBuilder<QuerySnapshot> (
        stream: FirebaseFirestore.instance
        .collection('bookmark').orderBy('id', descending: true)
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("목록을 가져오지 못했습니다."),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          CircularProgressIndicator();
        }
        if (snapshot!.hasData && snapshot.data!.docs.isNotEmpty) {
          final findlists = snapshot.data!.docs
              .map(
                (QueryDocumentSnapshot e) =>
                FindListModel.fromJson(
                    json: (e.data() as Map<String, dynamic>)),
          ).toList();

          return Scaffold(
            body: ListView.builder(
              //shrinkWrap: true,
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  final findlist = findlists[index];

                  return Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: ListTile(
                          title: Text(
                            findlist.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            findlist.content,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          trailing: findlist!.picUrl != null
                              ? Image.network(findlist!.picUrl!)
                              : Container(width: 0, height: 0),
                          onTap: () {
                            // 클릭하면 상세화면으로 이동, 현재 글 정보를 넘겨줌
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  DetailScreen(lists: findlist)),
                            );
                          },

                        ),
                      ),
                      Divider(thickness: 1.0)
                    ],
                  );
                }),
          );
        } else {
          // 컬렉션에 문서가 없는 경우
          return Scaffold(
            body: Center(
              child: Text("등록된 글이 없습니다."),
            ),
          );
        }
      }),



    );
/*
    return FutureBuilder(
      future: cartProvider.fetchCartItemsOrCreate(uid),
      builder: (context, snapshot) {
        if (cartProvider.cartItems.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/detail./',
                      arguments: DetailScreen(lists: cartProvider.cartItems as FindListModel));
                },
                title: Text(cartProvider.cartItems[index].title),
                subtitle: Text(cartProvider.cartItems[index].content.toString()),
                leading: cartProvider!.picUrl != null
                    ? Image.network(cartProvider!.picUrl!)
                    : SizedBox(width: 0, height: 0),
                //SizedBox(width: 0, height: 0),
                //Image.network(cartProvider.cartItems[index].picUrl!),
                *//*cartProvider.picUrl != null
                    ? Image.network(cartProvider.cartItems[index].picUrl!)
                    : const SizedBox(width: 0, height: 0),*//*
                trailing: InkWell(
                  onTap: () {
                    cartProvider.removeCartItem(uid, cartProvider.cartItems[index] as FindListModel );
                  },
                  child: const Icon(Icons.delete),
                ),
              );
            },
          );
        }
      },
    );*/
  }
}



