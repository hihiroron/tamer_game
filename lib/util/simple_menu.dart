import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

class SimpleMenu extends StatelessWidget {
  const SimpleMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      // backgroundColor: Colors.black.withOpacity(0.5),
      title: const Text("行動メニュー"),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: const Text("もどる"),
        ),
        SimpleDialogOption(
          onPressed: () {
            TalkDialog.show(
              context,
              [
                Say(
                  text: [const TextSpan(text: '召喚するモンスターを選択してね')],
                )
              ],
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            );
            // watchしといてここでdatabase変更する（fieldのtrue/false）
          },
          child: const Text("召喚"),
        ),
      ],
    );
  }
}
