import 'package:flutter/material.dart';

class CommonActionIcon extends IconButton {
  final void Function() onTap;

  CommonActionIcon.details(this.onTap) : super(icon: Icon(Icons.list), tooltip: 'Details', onPressed: onTap);

  CommonActionIcon.edit(this.onTap) : super(icon: Icon(Icons.edit), tooltip: 'Edit', onPressed: onTap);

  CommonActionIcon.remove(this.onTap) : super(icon: Icon(Icons.delete), tooltip: 'Remove', onPressed: onTap);
}
