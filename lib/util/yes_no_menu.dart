import 'package:flutter/material.dart';
import 'package:tamer_game/util/multi_menu.dart';

class YesNoMenu extends StatelessWidget {
  const YesNoMenu({
    super.key,
    required this.title,
    required this.onPressedYes,
    this.onPressedNo,
  });
  final String title;
  final void Function()? onPressedYes;
  final void Function()? onPressedNo;

  @override
  Widget build(BuildContext context) {
    return MultiMenu(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      itemList: [
        SimpleDialogOption(
          onPressed: onPressedYes,
          child: const Text(
            'はい',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: onPressedNo,
          child: const Text(
            'いいえ',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
