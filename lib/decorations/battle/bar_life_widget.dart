import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:tamer_game/decorations/battle/bar_life_controller.dart';

///
/// Created by
///
/// ─▄▀─▄▀
/// ──▀──▀
/// █▀▀▀▀▀█▄
/// █░░░░░█─█
/// ▀▄▄▄▄▄▀▀
///
/// Rafaelbarbosatec
/// on 04/03/22
class BarLifeWidget extends StatelessWidget {
  const BarLifeWidget({Key? key, required this.left, required this.top})
      : super(key: key);

  final double left;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: StateControllerConsumer<BarLifeController>(
        builder: (context, controller) {
          return Padding(
            padding: EdgeInsets.only(left: left, top: top),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      controller.life.toString(),
                      style: const TextStyle(color: Colors.green),
                    ),
                    const Text(
                      ' / ',
                      style: TextStyle(color: Colors.green),
                    ),
                    Text(
                      controller.maxLife.toString(),
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      controller.stamina.toString(),
                      style: const TextStyle(color: Colors.yellowAccent),
                    ),
                    const Text(
                      ' / ',
                      style: TextStyle(color: Colors.yellowAccent),
                    ),
                    Text(
                      controller.maxStamina.toString(),
                      style: const TextStyle(color: Colors.yellowAccent),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
