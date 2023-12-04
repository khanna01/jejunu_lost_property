import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:flutter/src/painting/edge_insets.dart';
import '../model/find_list_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.lists,}) : super(key: key);
  final FindListModel lists;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const RenderAppBar(
          title: '상세화면',
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.lists.title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            InkWell(
              onTap:
              SaveBookmark,
              child: Column(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.black12,
                  ),
                  Text(
                    '게시글 저장',
                    style: TextStyle(color: Colors.black12),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),
            Text("습득 장소: ${widget.lists.placeAddress}",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 10),
            Text(widget.lists.content,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 10),
            if (widget.lists.picUrl != null)
              Image.network(
                widget.lists.picUrl!,
                width: 400,
                height: 400,
                fit: BoxFit.cover,
              )
          ]),
        ));
  }

  void SaveBookmark() async {
    final findList = FindListModel(
        id: widget.lists.id,
        title: widget.lists.title!,
        content: widget.lists.content,
        picUrl: widget.lists.picUrl,
        userEmail: widget.lists.userEmail,
        placeAddress: widget.lists.placeAddress,
        latitude: widget.lists.latitude,
        longitude: widget.lists.longitude,

    );
    // findList 모델을 파이어스토어 findlist 컬렉션 문서에 추가
    await FirebaseFirestore.instance
        .collection(
      'bookmark',
    )
        .doc(findList.id)
        .set(findList.toJson());
  }
}





