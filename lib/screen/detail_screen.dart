import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:jejunu_lost_property/component/appbar.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RenderAppBar(
        title: '상세화면',
      ),
      body: Center(
        child: Text(widget.lists.placeAddress),
      ),
    );
  }
}
