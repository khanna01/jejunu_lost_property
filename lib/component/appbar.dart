import 'package:flutter/material.dart';

class RenderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const RenderAppBar({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // 앱바 제목
      title: Text('${title}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          )),
      // 앱바 배경색
      backgroundColor: Colors.grey[400],
      elevation: 4,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); // default:kToolbarHeight
}
