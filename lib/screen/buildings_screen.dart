import 'package:flutter/material.dart';
import '../const/building_list.dart';
import 'building_list_screen.dart';

class BuildingsScreen extends StatefulWidget {
  const BuildingsScreen({Key? key}) : super(key: key);

  @override
  State<BuildingsScreen> createState() => _BuildingsScreenState();
}

class _BuildingsScreenState extends State<BuildingsScreen> {
  final TextEditingController buildingSearchController =
      TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late List<String> searchBuildingLists = buildings;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        searchFocusNode.unfocus(); // 키보드가 아닌 화면을 클릭하면 키보드가 사라지도록
      },
      child: SafeArea(
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 18,
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
            ),
            child: TextField(
              controller: buildingSearchController,
              focusNode: searchFocusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.none,
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    searchBuildingLists = buildings
                        .where((element) => element.contains(value))
                        .toList();
                  } else {
                    searchBuildingLists = buildings;
                  }
                });
              },
              decoration: InputDecoration(
                  hintText: '건물을 검색하세요.',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFaaaaaa))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF111111))),
                  isDense: true,
                  contentPadding: EdgeInsets.all(10)),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: searchBuildingLists.length,
              itemBuilder: (BuildContext context, int index) {
                final building = searchBuildingLists[index];
                return ListTile(
                  title: Text(building),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    searchFocusNode.unfocus();
                    // 클릭하면 목록화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuildingListScreen(
                                buildingName: building,
                              )),
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
        ]),
      ),
    );
  }
}
