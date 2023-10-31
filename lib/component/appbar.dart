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
      // AppBar 제목
      title: Text('${title}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          )),
      // AppBar 배경색
      backgroundColor: Colors.grey[400],
      elevation: 4,
    );
  }

  // AppBar 높이 설정
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
/*
class RenderAppBarwithIcons extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const RenderAppBarwithIcons({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // AppBar 제목
      title: Text('${title}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          )),
      // AppBar 배경색
      backgroundColor: Colors.grey[400],
      elevation: 4,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FindListScreen()),
              );
            },
            icon: Icon(
              Icons.search,
            )),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FindListScreen()),
              );
            },
            icon: Icon(
              Icons.search,
            )),
      ],
    );
  }

  // AppBar 높이 설정
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
 */
