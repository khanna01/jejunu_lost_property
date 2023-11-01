import 'package:flutter/material.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:jejunu_lost_property/component/appbar.dart';
import 'package:flutter/src/painting/edge_insets.dart';
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

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(widget.lists.title,
          textAlign: TextAlign.left,
            style: TextStyle(
                fontSize:22,
                fontWeight: FontWeight.bold,
                color:Colors.black
            )
          ),

          SizedBox(height:10),
          Text("습득 장소: ${widget.lists.placeAddress}",
            textAlign:TextAlign.left,
              style: TextStyle(
                  fontSize:18,
                  //fontWeight: FontWeight.bold,
                  color:Colors.black
              )

          ),

          SizedBox(height:10),
          Text(widget.lists.content,
            textAlign:TextAlign.left,
              style: TextStyle(
                  fontSize:18,
                  //fontWeight: FontWeight.bold,
                  color:Colors.black
              )
          ),


          SizedBox(height:10),
          if (widget.lists.picUrl != null)
            Image.network(
              widget.lists.picUrl!,
              width: 400,
              height: 400,
              fit: BoxFit.cover,)
        ]
      ),
       ));
  }
}
