import 'package:flutter/material.dart';

class PlayerButtons extends StatelessWidget {
  final void Function() onPressed;
  final Color color;
  final IconData icon;

  const PlayerButtons.play({@required this.onPressed, this.color}) : icon = Icons.play_arrow;

  const PlayerButtons.pause({@required this.onPressed, this.color}) : icon = Icons.pause;

  const PlayerButtons.previous({@required this.onPressed, this.color}) : icon = Icons.skip_previous;

  const PlayerButtons.next({@required this.onPressed, this.color}) : icon = Icons.skip_next;

  const PlayerButtons.seekBackward({@required this.onPressed, this.color}) : icon = Icons.replay_5;

  const PlayerButtons.seekForward({@required this.onPressed, this.color}) : icon = Icons.forward_5;

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(icon), color: color, onPressed: onPressed);
  }
}
