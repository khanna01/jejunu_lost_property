import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:jejunu_lost_property/component/text_field.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:jejunu_lost_property/component/auth_service.dart';
import 'package:image_picker/image_picker.dart';

import '../component/auth_service.dart';
import '../model/find_list_model.dart';
import 'find_list_screen.dart';

class FindListLoadScreen extends StatefulWidget {
  const FindListLoadScreen({Key? key}) : super(key: key);

  @override
  State<FindListLoadScreen> createState() => _FindListLoadScreenState();
}

class _FindListLoadScreenState extends State<FindListLoadScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String? title;

  //DateTime? createdTime;
  String? placeAddress;
  LatLng? placeLatLng;
  String? content = '';
  PickResult? addressResult;
  String? picUrl = '';

  final picker = ImagePicker();
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러 장의 사진을 선택해서 저장할 변수
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수

  // 임시 위치
  static final LatLng currentLocation = LatLng(37, 126.92);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RenderAppBar(
        title: '게시물 등록',
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 9),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RenderTextField(
                    label: '제목',
                    textEditingController: nameController,
                    validator: textValidator,
                    textInputAction: TextInputAction.done,
                    onSaved: (String? val) {
                      title = val;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // 장소등록창
                  TextFormField(
                    validator: textValidator,
                    controller: addresscontroller,
                    decoration: InputDecoration(
                      hintText: '주소',
                      hintStyle: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 23.0,
                      ),
                    ),
                    readOnly: true,
                    onSaved: (String? val) {
                      placeAddress = val;
                    },
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            apiKey: "AIzaSyDpo7YIMXr1EkXviZdi8sDnN8_dYTaCYoY",
                            onPlacePicked: (result) {
                              addressResult = result;
                              Navigator.of(context).pop();
                              if (addressResult != null) {
                                // 장소 이름에 건물명이 뜨는 경우
                                if (addressResult!.name!.contains('제주')) {
                                  setState(() {
                                    addresscontroller.text =
                                        addressResult!.name!;
                                  });
                                  // 장소 주소가 없어서 플러스 코드가 뜨는 경우
                                } else if (addressResult!.name!
                                    .contains('8Q')) {
                                  setState(() {
                                    addresscontroller.text = '제주 제주시 제주대학로 102';
                                  });
                                  // 장소 이름이 이상한 경우 주소로
                                } else {
                                  setState(() {
                                    addresscontroller.text =
                                        addressResult!.formattedAddress!;
                                  });
                                }
                                //latitude, longitude 저장
                                final lat =
                                    addressResult!.geometry!.location.lat;
                                final lng =
                                    addressResult!.geometry!.location.lng;
                                placeLatLng = LatLng(lat, lng);
                              }
                            },
                            autocompleteLanguage: "ko",
                            // 한국어로
                            region: "kr",
                            // 지역을 한국으로
                            initialPosition: currentLocation,
                            // 초기위치를 현재 위치로
                            useCurrentLocation: true,
                            // 현재 위치가 뜨도록
                            resizeToAvoidBottomInset: false,
                            // only works in page mode, less flickery, remove if wrong offsets
                            zoomControlsEnabled: true,
                            usePlaceDetailSearch: true,
                            // 자세한 정보얻도록
                            selectInitialPosition: true,
                            // 초기위치 등록창이 뜨도록
                            searchingText: "검색중...",
                            // 검색중일 때 안내문
                            selectText: "해당 위치입니다.",
                            // 위치를 선택했을 때 안내문
                            outsideOfPickAreaText: '이 위치는 등록할 수 없습니다.',
                            // 등록불가한 위치 선택시 안내문
                            // 등록가능한 위치 제한 (제주대학교 주변만)
                            pickArea: CircleArea(
                              center: LatLng(33.4547583, 126.5622562),
                              radius: 800,
                              fillColor: Color(0x00FF00FF),
                              strokeColor: Color(0x000000FF),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: contentController,
                    onSaved: (String? val) {
                      content = val;
                    },
                    decoration: InputDecoration(
                      label: const Text('내용을 입력하세요.'),
                      labelStyle: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 23.0,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 8,
                    textInputAction: TextInputAction.done,
                  ),
                  ElevatedButton(
                    onPressed: () => takeImage(context),
                    child: const Text(
                      "사진 등록",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: images.length,
                      //보여줄 item 개수. images 리스트 변수에 담겨있는 사진 수 만큼.
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //1 개의 행에 보여줄 사진 개수
                        childAspectRatio: 1 / 1, //사진 의 가로 세로의 비율
                        mainAxisSpacing: 10, //수평 Padding
                        crossAxisSpacing: 10, //수직 Padding
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        // 사진 오른 쪽 위 삭제 버튼을 표시하기 위해 Stack을 사용함
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      fit: BoxFit
                                          .cover, //사진 크기를 Container 크기에 맞게 조절
                                      image: FileImage(File(images[index]!
                                              .path // images 리스트 변수 안에 있는 사진들을 순서대로 표시함
                                          )))),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                //삭제 버튼
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.close,
                                      color: Colors.white, size: 15),
                                  onPressed: () {
                                    //버튼을 누르면 해당 이미지가 삭제됨
                                    setState(() {
                                      images.remove(images[index]);
                                    });
                                  },
                                ))
                          ],
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: submitInformation,
                    child: const Text(
                      "글 등록",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 등록버튼을 누르면 데이터가 저장되는 함수*
  void submitInformation() async {
    User? user = AuthService().currentUser();
    String? userEmail = user?.email;
    //DateTime now = DateTime.now();
    Image image = Image.network("");

    // 폼 검증
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); // 폼 저장

      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          File _file = File(images[i]!.path);
          await FirebaseStorage.instance.ref("test").putFile(_file);
        }
      }
      //print("등록테스트");
      final findList = FindListModel(
          id: Uuid().v4(),
          userEmail: userEmail,
          title: title!,
          //createdTime: now,
          placeAddress: placeAddress!,
          latitude: placeLatLng!.latitude,
          longitude: placeLatLng!.longitude,
          content: '테스트',
          picUrl: images[0]!.path);

      // findList 모델을 파이어스토어 findlist 컬렉션 문서에 추가
      await FirebaseFirestore.instance
          .collection(
            'findlist1',
          )
          .doc(findList.id)
          .set(findList.toJson());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FindListScreen()),
      );
    }
  }

  // 값을 입력했는지 확인
  String? textValidator(String? val) {
    if (val == null || val.length == 0) {
      return '값을 입력해주세요';
    }
    return null;
  }

  takeImage(mConText) {
    return showDialog(
        context: mConText,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            title: const Text(
              "사진 추가",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text(
                  '카메라로 촬영하기',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      images.add(image);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                  child: const Text(
                    '사진첩에서 사진 고르기',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    multiImage = await picker.pickMultiImage();
                    setState(() {
                      images.addAll(multiImage);
                    });
                    Navigator.pop(context);
                  } // TODO 사진을 선택하고 창이 없어지도록 해야 함
                  ),
              SimpleDialogOption(
                child: const Text(
                  '취소',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}
