import 'package:flutter/material.dart';
import 'package:fastotv_flutter_common/colors.dart';

class PlayerButtons extends StatelessWidget {
  final void Function() onPressed;
  final Color color;
  final int type;

  PlayerButtons.previous({@required this.onPressed, this.color}) : type = 0;
  PlayerButtons.next({@required this.onPressed, this.color}) : type = 1;
  PlayerButtons.seekBackward({@required this.onPressed, this.color}) : type = 2;
  PlayerButtons.seekForward({@required this.onPressed, this.color}) : type = 3;

  IconData icon() {
    switch (type) {
      case 0: return Icons.skip_previous;
      case 1: return Icons.skip_next;
      case 2: return Icons.replay_5;
      case 3: return Icons.forward_5;
      default: return Icons.all_inclusive;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _color = color ?? CustomColor().backGroundColorBrightness(Theme.of(context).primaryColor);
    return IconButton(icon: Icon(icon()), color: _color, onPressed: () => onPressed());
  }
}