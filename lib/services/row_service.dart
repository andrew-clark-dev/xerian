import 'package:flutter/material.dart';

class RowService {
  static Row buildRow(List<String?> cellNames, TextStyle? style) {
    List<Widget> children = [];
    for (final cellName in cellNames) {
      children.add(Expanded(
        child: Text(
          cellName ?? "",
          textAlign: TextAlign.left,
          style: style,
        ),
      ));
    }
    return Row(children: children);
  }
}
