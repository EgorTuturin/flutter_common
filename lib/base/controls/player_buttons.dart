import 'package:flutter_common/colors.dart';
import 'package:flutter/material.dart';

class PlayerButtons extends StatelessWidget {
  final void Function() onPressed;
  final Color color;
  final IconData icon;

  PlayerButtons.play({@required this.onPressed, this.color}) : icon = Icons.play_arrow;

  PlayerButtons.pause({@required this.onPressed, this.color}) : icon = Icons.pause;

  PlayerButtons.previous({@required this.onPressed, this.color}) : icon = Icons.skip_previous;

  PlayerButtons.next({@required this.onPressed, this.color}) : icon = Icons.skip_next;

  PlayerButtons.seekBackward({@required this.onPressed, this.color}) : icon = Icons.replay_5;

  PlayerButtons.seekForward({@required this.onPressed, this.color}) : icon = Icons.forward_5;

  @override
  Widget build(BuildContext context) {
    final _color = color ?? CustomColor().backGroundColorBrightness(Theme.of(context).primaryColor);
    return IconButton(
        icon: Icon(icon),
        color: _color,
        onPressed: () {
          onPressed();
        });
  }
}
