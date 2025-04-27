// vertical_divider.dart
import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey[300],
    );
  }
}