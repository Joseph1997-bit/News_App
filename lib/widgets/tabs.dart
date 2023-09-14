import 'package:flutter/material.dart';


class TabsWidget extends StatelessWidget {
  const TabsWidget(
      {Key? key,
        required this.title,
        required this.color,
        required this.function,
        required this.fontSize})
      : super(key: key);
  final String title;
  final Color color;
  final Function function;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: color),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}