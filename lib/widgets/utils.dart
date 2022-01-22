import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/utils/global_variables.dart';

Column buildStatColumn(String label, int number) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        number.toString(),
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4.0),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ],
  );
}

List<QuiltedGridTile> buildQuiltedGrid(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  List<QuiltedGridTile> list = [
    const QuiltedGridTile(2, 2),
    const QuiltedGridTile(1, 1),
    const QuiltedGridTile(1, 1),
    const QuiltedGridTile(1, 2),
  ];

  if (width > webScreenSize) {
    list.removeLast();
    return list;
  }
  return list;
}
