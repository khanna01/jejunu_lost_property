import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:flutter/src/painting/edge_insets.dart';
import 'package:uuid/uuid.dart';
import '../component/auth_service.dart';
import '../model/comments_model.dart';
import '../model/find_list_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    Key? key,
    required this.lists,
  }) : super(key: key);
  final FindListModel lists;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // 현재 로그인한 유저 조회
  String? currentUser = AuthService().currentUser()?.email;
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();
  // 댓글 내용을 저장할 변수
  String? cotents;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        commentFocusNode.unfocus(); // 키보드가 아닌 화면을 클릭하면 키보드가 사라지도록
      },
      child: Scaffold(
        appBar: RenderAppBar(
          title: '상세화면',
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 20.0, bottom: 15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 작성시간
                      Text(DateFormat('yyyy/MM/dd  HH:ss')
                          .format(widget.lists.createdTime)),
                      // 제목
                      Text(widget.lists.title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      SizedBox(height: 10),
                      // 건물이 아니면 위치가 보이지 않도록
                      (widget.lists.placeAddress.contains('대한민국'))
                          ? Container(
                              height: 0,
                              width: 0,
                            )
                          : Text("습득 장소: ${widget.lists.placeAddress}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                      SizedBox(height: 10),
                      Text(widget.lists.content,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18,
                              //fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      SizedBox(height: 10),
                      if (widget.lists.picUrl != null)
                        Image.network(
                          widget.lists.picUrl!,
                          width: 400,
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                    ]),
              ),
              Divider(
                thickness: 1.0,
              ),
              // 댓글 화면
              StreamBuilder<QuerySnapshot>(
                  // 파이어스토어에서 commentlist 컬렉션에서 해당 글의 댓글문서 가져오기
                  // 데이터가 변경될 때마다 실시간으로 컬렉션 업데이트받기 위한 Stream 사용
                  stream: FirebaseFirestore.instance
                      .collection('commentlist')
                      .where('postId', isEqualTo: widget.lists.id)
                      .orderBy('createdTime', descending: false)
                      .snapshots(),
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
                    // 컬렉션에 문서가 있는 경우
                    if (snapshot!.hasData && snapshot.data!.docs.isNotEmpty) {
                      // CommentModel로 데이터를 매핑하여 리스트 형태 저장
                      final commentLists = snapshot.data!.docs
                          .map(
                            (QueryDocumentSnapshot e) => CommentModel.fromJson(
                                json: (e.data() as Map<String, dynamic>)),
                          )
                          .toList();

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: commentLists.length, //snapshot.data!.size,
                          itemBuilder: (context, index) {
                            final commentList = commentLists[index];
                            // 날짜 형식 변경
                            final commentCreatedTime =
                                DateFormat('yyyy/MM/dd  HH:ss')
                                    .format(commentList.createdTime);
                            return Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 15.0, right: 15.0, bottom: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SingleChildScrollView(
                                        padding: EdgeInsets.only(bottom: 2.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // 댓글 내용
                                            Expanded(
                                              flex: 6,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 18.0),
                                                child: Text(
                                                  '${commentList.content}',
                                                  style: TextStyle(
                                                      fontSize: 18, height: 1),
                                                  overflow:
                                                      TextOverflow.visible,
                                                  textHeightBehavior:
                                                      TextHeightBehavior(
                                                          applyHeightToFirstAscent:
                                                              true,
                                                          applyHeightToLastDescent:
                                                              true),
                                                ),
                                              ),
                                            ),
                                            // 현재 유저가 댓글을 작성한 유저이면 댓글 삭제 버튼이 보이도록
                                            (commentList.userEmail ==
                                                    currentUser)
                                                ? Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        deleteComment(
                                                            commentList
                                                                .commentId);
                                                      },
                                                      icon: Icon(Icons.delete),
                                                      iconSize: 22,
                                                      color: Colors.grey[700],
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0,
                                                  ),
                                          ],
                                        ),
                                      ),
                                      // 댓글 작성 날짜
                                      Text(
                                        '${commentCreatedTime}',
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1.0,
                                ),
                              ],
                            );
                          });
                    } else {
                      // 컬렉션에 문서가 없는 경우
                      return Container();
                    }
                  }),
            ],
          ),
        ),
        // 댓글 작성란
        bottomNavigationBar: SafeArea(
          child: Padding(
            // 키보드가 생기면 키보드 높이 만큼 이동하도록
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 65,
              padding: EdgeInsets.only(
                  top: 5.0, left: 15.0, right: 15.0, bottom: 8.0),
              child: Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 8),
                    child: TextField(
                      controller: commentController,
                      focusNode: commentFocusNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.none,
                      decoration: InputDecoration(
                          hintText: '댓글을 입력하세요.',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          //댓글 등록 버튼
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            color: Colors.blue,
                            onPressed: () {
                              if (commentController.text.length > 0) {
                                cotents = commentController.text;
                                commentFocusNode.unfocus();
                                postComment();
                              } else {
                                return;
                              }
                            },
                          )),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // 댓글 등록 함수
  void postComment() async {
    User? user = AuthService().currentUser();
    String? userEmail = user?.email;
    DateTime createdTime = DateTime.now();

    final commentList = CommentModel(
      postId: widget.lists.id,
      commentId: Uuid().v4(),
      userEmail: userEmail,
      createdTime: createdTime,
      content: cotents!,
    );

    // CommentModel 모델을 파이어스토어 commentlist 컬렉션 문서에 추가
    await FirebaseFirestore.instance
        .collection(
          'commentlist',
        )
        .doc(commentList.commentId)
        .set(commentList.toJson());

    //댓글 등록하면 작성했던 내용이 사라지게
    commentController.clear();
    // 화면 새로고침
    setState(() {});
  }

  // 댓글 삭제 함수
  void deleteComment(String commentId) async {
    String deletedcommentId = commentId;
    // 컬렉션 문서 삭제
    await FirebaseFirestore.instance
        .collection("commentlist")
        .doc(deletedcommentId)
        .delete();
    setState(() {});
  }
}
