import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jejunu_lost_property/const/building_list.dart';

import '../model/find_list_model.dart';
import 'detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static final LatLng userPosition = LatLng(
    33.4537936,
    126.5628594,
  );

  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('findlist3')
            //.where('placeAddress', isEqualTo: "102")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Stream을 가져오는 동안 에러가 나면 보여줄 화면
          if (snapshot.hasError) {
            return const Center(
              child: Text('데이터를 가져오지 못했습니다.'),
            );
          }

          // 로딩 중일 때 보여줄 화면
          if (snapshot.connectionState == ConnectionState.waiting) {
            const CircularProgressIndicator();
          }

          // 성공적으로 가져온 경우 실행
          // 컬렉션에 문서가 있는 경우
          if (snapshot!.hasData && snapshot.data!.docs.isNotEmpty) {
            final markerlists = snapshot.data!.docs
                .map(
                  (QueryDocumentSnapshot e) => FindListModel.fromJson(
                      json: (e.data() as Map<String, dynamic>)),
                )
                .toList();
            List<FindListModel> markerlist = markerlists
                .where((element) =>
                    element.placeAddress.contains("제주대학로 102") ||
                    element.placeAddress.contains("제주시"))
                .toList();
            for (var element in markerlist) {
              markers.add(
                Marker(
                  markerId: MarkerId(element.id),
                  position: LatLng(element.latitude, element.longitude),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        clipBehavior: Clip.hardEdge,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (_) => SafeArea(
                              child: GestureDetector(
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          //color: Colors.black,
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Wrap(children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // 작성시간
                                                    Text(DateFormat(
                                                            'yyyy/MM/dd  HH:ss')
                                                        .format(element
                                                            .createdTime)),
                                                    SizedBox(height: 5),
                                                    // 제목
                                                    Text(element.title,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black)),
                                                    SizedBox(height: 10),
                                                    Text(element.content,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.black)),
                                                    SizedBox(height: 10),
                                                    if (element.picUrl != null)
                                                      Image.network(
                                                        element.picUrl!,
                                                        width: 150,
                                                        height: 150,
                                                        fit: BoxFit.cover,
                                                      ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    )),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailScreen(lists: element)),
                                  );
                                },
                              ),
                            ));
                  },
                ),
              );
            }
          } else {
            markers = {};
          }

          return GoogleMap(
            //myLocationEnabled: true,
            //myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: userPosition,
              zoom: 16,
            ),
            // 축소, 확대 경계
            minMaxZoomPreference: const MinMaxZoomPreference(13, 20),
            zoomGesturesEnabled: true,
            markers: markers,
          );
        });
  }
}
