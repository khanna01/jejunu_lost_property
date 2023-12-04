import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/appbar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RenderAppBar(title: '지도'),
      body: Center(
        child: Text('지도 화면'),
      ),
    );
  }
}
