import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:jejunu_lost_property/component/text_field.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../component/auth_service.dart';
import '../model/find_list_model.dart';

class FindListLoadScreen extends StatefulWidget {
  const FindListLoadScreen({Key? key}) : super(key: key);

  @override
  State<FindListLoadScreen> createState() => _FindListLoadScreenState();
}

class _FindListLoadScreenState extends State<FindListLoadScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String? title;
  DateTime? createdTime;
  String? placeAddress;
  //LatLng? placeLatLng;
  String? content = '';

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
                    label: '장소명',
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
                  /*
                  TextFormField(
                    validator: textValidator,
                    controller: controller,
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
                      var p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: "AIzaSyCrZAL3EPNYEWfKT_IvPWCpnXex-OXADUA",
                          mode: Mode.fullscreen,
                          language: 'kr',
                          types: [],
                          strictbounds: false,
                          components: [Component(Component.country, 'kr')],
                          //google_map_webservice package
                          onError: (err) {
                            print(err);
                          });

                      if (p != null) {
                        setState(() {
                          controller.text = p.description!;
                        });
                        GoogleMapsPlaces place = GoogleMapsPlaces(
                          apiKey: "AIzaSyCrZAL3EPNYEWfKT_IvPWCpnXex-OXADUA",
                          apiHeaders: await GoogleApiHeaders().getHeaders(),
                        );
                        PlacesDetailsResponse detail =
                            await place.getDetailsByPlaceId(p.placeId!);
                        final lat = detail.result.geometry!.location.lat;
                        final lng = detail.result.geometry!.location.lng;
                        placeLatLng = LatLng(lat, lng);
                      }
                    },
                  ),

                   */
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: contentController,
                    onSaved: (String? val) {
                      content = val;
                    },
                    decoration: InputDecoration(
                      label: const Text('추가 정보를 입력하세요'),
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
                    onPressed: () {
                      submitInformation(context);
                    },
                    child: const Text(
                      "로그아웃",
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
}

// 등록버튼을 누르면 데이터가 저장되는 함수
void submitInformation(BuildContext context) async {
  // 폼 검증
  //if (formKey.currentState!.validate()) {
  //formKey.currentState!.save(); // 폼 저장
  User? user = context.read<AuthService>().currentUser();
  String? userEmail = user?.email;
  DateTime now = DateTime.now();
  print("테스트");
  final findList = FindListModel(
      id: Uuid().v4(),
      userEmail: userEmail,
      title: '2',
      //createdTime: now,
      placeAddress: '장소',
      latitude: 30.0,
      longitude: 30.0,
      content: '내용');

  // place 모델 파이어스토어에 삽입
  await FirebaseFirestore.instance
      .collection(
        'findlist',
      )
      .doc(findList.id)
      .set(findList.toJson());
/*
    nameController.clear();
    controller.clear();
    contentController.clear();
    selectedEvent!.clear();
    selectedDays!.clear();
    event.clear();
    days.clear();

 */
}

String? textValidator(String? val) {
  if (val == null || val.length == 0) {
    return '값을 입력해주세요';
  }
  return null;
}
