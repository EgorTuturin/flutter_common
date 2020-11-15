import 'package:flutter/material.dart';

class CommonActionIcon extends IconButton {
  final void Function() onTap;

  CommonActionIcon.addProvider(this.onTap)
      : super(icon: Icon(Icons.wifi_tethering), tooltip: 'Add provider', onPressed: () => onTap());

  CommonActionIcon.removeProvider(this.onTap)
      : super(icon: Icon(Icons.portable_wifi_off), tooltip: 'Remove provider', onPressed: () => onTap());

  CommonActionIcon.details(this.onTap) : super(icon: Icon(Icons.list), tooltip: 'Details', onPressed: () => onTap());

  CommonActionIcon.edit(this.onTap) : super(icon: Icon(Icons.edit), tooltip: 'Edit', onPressed: () => onTap());

  CommonActionIcon.copy(this.onTap)
      : super(icon: Icon(Icons.control_point_duplicate), tooltip: 'Copy', onPressed: () => onTap());

  CommonActionIcon.remove(this.onTap) : super(icon: Icon(Icons.delete), tooltip: 'Remove', onPressed: () => onTap());
}
