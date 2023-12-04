import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/screen/buildings_screen.dart';
import 'package:jejunu_lost_property/screen/map_screen.dart';

import '../const/building_list.dart';

class PositionScreen extends StatefulWidget {
  const PositionScreen({Key? key}) : super(key: key);

  @override
  State<PositionScreen> createState() => _PositionScreenState();
}

class _PositionScreenState extends State<PositionScreen> {
  BuildingsScreen buildingscreen = BuildingsScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // debug banner 안보이게
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const TabBar(
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontSize: 20,
              ),
              indicatorColor: Colors.grey,
              tabs: [
                Tab(
                  text: '지도로 보기',
                ),
                Tab(
                  text: '건물별로 보기',
                )
              ],
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black, //색변경
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              MapScreen(),
              BuildingsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
