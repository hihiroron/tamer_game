import 'package:flutter/material.dart';

class MultiMenu extends StatelessWidget {
  const MultiMenu({super.key, required this.title, required this.itemList});
  final Widget title;
  final List<Widget> itemList;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: title,
      backgroundColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.white,
      ),
      children: itemList,
    );
  }
}
