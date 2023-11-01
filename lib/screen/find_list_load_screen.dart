import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:jejunu_lost_property/component/text_field.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:jejunu_lost_property/component/auth_service.dart';
import 'package:image_picker/image_picker.dart';


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
  //final TextEditingController controller = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String? title;
  //DateTime? createdTime;
  //String? placeAddress;
  //LatLng? placeLatLng;
  String? content = '';
  String? picUrl = '';

  final picker = ImagePicker();
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러 장의 사진을 선택해서 저장할 변수
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RenderAppBar(
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
                          apiKey: "",
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
                          apiKey: "",
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
                    child: GridView.builder(padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: images.length, //보여줄 item 개수. images 리스트 변수에 담겨있는 사진 수 만큼.
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //1 개의 행에 보여줄 사진 개수
                        childAspectRatio:
                        1 / 1, //사진 의 가로 세로의 비율
                        mainAxisSpacing: 10, //수평 Padding
                        crossAxisSpacing: 10, //수직 Padding
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        // 사진 오른 쪽 위 삭제 버튼을 표시하기 위해 Stack을 사용함
                        index = 0;
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image:
                                  DecorationImage(
                                      fit: BoxFit.cover,  //사진 크기를 Container 크기에 맞게 조절
                                      image: FileImage(File(images[index]!.path   // images 리스트 변수 안에 있는 사진들을 순서대로 표시함
                                      ))
                                  )
                              ),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                  BorderRadius.circular(5),
                                ),
                                //삭제 버튼
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.close,
                                      color: Colors.white,
                                      size: 15),
                                  onPressed: () {
                                    //버튼을 누르면 해당 이미지가 삭제됨
                                    setState(() {
                                      images.remove(images[index]);
                                    });
                                  },
                                )
                            )
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



// 등록버튼을 누르면 데이터가 저장되는 함수
  void submitInformation() async {
    // 폼 검증
    //if (formKey.currentState!.validate()) {
    //formKey.currentState!.save(); // 폼 저장
    User? user = AuthService().currentUser();
    String? userEmail = user?.email;
    //User? user = context.read<AuthService>().currentUser();
    //String? userEmail = user?.email;
    DateTime now = DateTime.now();
    Image image = Image.network("");

    ImagePicker _picker = ImagePicker();
    XFile? _pick = await _picker.pickImage(source: ImageSource.gallery);
    if (_pick != null) {
      File file = File(_pick.path);
      FirebaseStorage.instance
          .ref("test/picker/test_image")
          .putFile(file);
    }

    print("테스트");
    final findList = FindListModel(
        id: Uuid().v4(),
        userEmail: userEmail,
        title: '5',
        //createdTime: now,
        placeAddress: '장소',
        latitude: 30.0,
        longitude: 30.0,
        content: '테스트',
        picUrl: images[0]!.path
     );

    // findList 모델을 파이어스토어 findlist 컬렉션 문서에 추가
    await FirebaseFirestore.instance
        .collection(
      'findlist1',
    )
        .doc(findList.id)
        .set(findList.toJson());
  }

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
            title: const Text("사진 추가", style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text('카메라로 촬영하기', style: TextStyle(color: Colors.black),),
                onPressed: () async {
                  image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      images.add(image);
                    });
                  }
                },
              ),
              SimpleDialogOption(
                child: const Text('사진첩에서 사진 고르기', style: TextStyle(color: Colors.black),),
                onPressed: () async {multiImage = await picker.pickMultiImage();
                  setState(() {
                    images.addAll(multiImage);
                  }
                  
                );
                 () => Navigator.pop(context);} // TODO 사진을 선택하고 창이 없어지도록 해야 함
              ),
              SimpleDialogOption(
                child: const Text('취소', style: TextStyle(color: Colors.grey),),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }



  //-----------2

/*

  final ImagePicker _picker = ImagePicker();
  PickedFile? file;


  pickImageFromGallery() async {
    Navigator.pop(context as BuildContext);
    PickedFile? imageFile = (await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    )) as PickedFile?;
    setState(() {
      file = imageFile;
    });
  }


// 업로드/저장 총괄 메소드
  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    await compressingPhoto(); // 업로드 전 사진 준비
    String downloadUrl = await uploadPhoto(imgFile);  // 업로드 후 url 저장
    savePostInfoToFireStore(url: downloadUrl, location: locationTextEditingController.text, desc:
    descTextEditingController.text);
    clearPostInfo();
  }

// 업로드 전 사진 준비
  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(imgFile.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 90));
    setState(() {
      imgFile = compressedImageFile;
    });
  }

// 업로드 후 url 저장
  Future<String> uploadPhoto(mImgFile) async {
    StorageUploadTask storageUploadTask = strageReference.child('post_$postId.jpg').putFile(mImgFile);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
    return await storageTaskSnapshot.ref.getDownloadURL();
  }

// DB에 게시글 관련 정보 저장
  savePostInfoToFireStore({required String url, required String location, required String desc}) {
    postsReference.doc(widget.gCurrentUser.id).collection('usersPosts').doc(postId).set( {
      'postId': postId,
      'ownerId': widget.gCurrentUser.id,
      'timestamp': timestamp,
      'username': widget.gCurrentUser.username,
      'description': desc,
      'location': location,
      'url': url
    });
  }

// 업로드/저장 완료 후 uploading flag, postId, controller 등 초기화하기
  clearPostInfo() {
    uploading = false;
    postId = Uuid().v4();
    descTextEditingController.clear();
    locationTextEditingController.clear();
    setState(() {
      imgFile = null;
    });
  }
*/

  //-----------2/
  //-------------3
 /*
  ImagePicker image_picker = ImagePicker();
  XFile? _pick = await image_picker.pickImage(source: ImageSource.gallery);
  if (image_pick != null) {
  File _file = File(_pick.path);
  FirebaseStorage.instance
      .ref("test/picker/test_image")
      .putFile(_file);
  }
  */
//--------------3/
}









