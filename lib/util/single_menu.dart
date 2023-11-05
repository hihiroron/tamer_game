import 'package:flutter/material.dart';

class SingleMenu extends StatelessWidget {
  const SingleMenu({
    super.key,
    required this.title,
    required this.child,
    this.onPressed,
  });
  final Widget title;
  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      // backgroundColor: Colors.black.withOpacity(0.5),
      title: title,
      children: [
        SimpleDialogOption(
          onPressed: onPressed,
          child: child,
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "もどる",
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
