import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/appbar.dart';

import '../model/find_list_model.dart';

class FindListScreen extends StatefulWidget {
  const FindListScreen({Key? key}) : super(key: key);

  @override
  State<FindListScreen> createState() => _FindListScreenState();
}

class _FindListScreenState extends State<FindListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RenderAppBar(title: "잃어버린분"),
      body: StreamBuilder<QuerySnapshot>(
        // 파이어스토어에서 findlist 컬렉션 정보 가져오기
        stream: FirebaseFirestore.instance.collection('findlist').snapshots(),
        builder: (context, snapshot) {
          // 가져오는 동안 에러가 발생하면 보여줄 메세지 화면
          if (snapshot.hasError) {
            return Center(
              child: Text("목록을 가져오지 못했습니다."),
            );
          }

          // 로딩 화면
          if (snapshot.connectionState == ConnectionState.waiting) {
            const CircularProgressIndicator();
            //return Container(child: CircularProgressIndicator());
          }

          // 성공적으로 가져온 경우 실행
          // FindListModel로 데이터 매핑
          final findlists = snapshot.data!.docs
              .map(
                (QueryDocumentSnapshot e) => FindListModel.fromJson(
                    json: (e.data() as Map<String, dynamic>)),
              )
              .toList();
          return Scaffold(
            //height: double.infinity,
            //width: double.infinity,
            body: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  final findlist = findlists[index];
                  return Padding(
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 15.0, left: 8.0, right: 8.0),
                      child: Column(
                        children: [
                          Text(findlist.title),
                          Text(findlist.placeAddress),
                          /*Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(child: Text(findlist.title)),
                                SizedBox(width: 16.0),
                                Expanded(child: Text(findlist.placeAddress)),
                              ],
                            ),
                          ),

                           */
                          Text(findlist.content),
                        ],
                      ));
                }),
          );
        },
      ),
    );
  }
}

/*
Future<Map<String, String>?> _imagePickerToUpload() async {
  final String _dateTime = DateTime.now().millisecondsSinceEpoch.toString();
  ImagePicker _picker = ImagePicker();
  XFile? _images = await _picker.pickImage(source: ImageSource.gallery);
  if (_images != null) {
    String _imageRef = "feed/${_uid}_$_dateTime";
    File _file = File(_images.path);
    await FirebaseStorage.instance.ref(_imageRef).putFile(_file);
    final String _urlString =
    await FirebaseStorage.instance.ref(_imageRef).getDownloadURL();
    return {
      "image": _urlString,
      "path": _imageRef,
    };
  } else {
    return null;
  }
}

 */
