import 'package:flutter/material.dart';

class CommonActionIcon extends IconButton {
  final void Function() onTap;

  const CommonActionIcon.addProvider(this.onTap)
      : super(icon: const Icon(Icons.wifi_tethering), tooltip: 'Add provider', onPressed: onTap);

  const CommonActionIcon.removeProvider(this.onTap)
      : super(
            icon: const Icon(Icons.portable_wifi_off),
            tooltip: 'Remove provider',
            onPressed: onTap);

  const CommonActionIcon.details(this.onTap)
      : super(icon: const Icon(Icons.list), tooltip: 'Details', onPressed: onTap);

  const CommonActionIcon.edit(this.onTap)
      : super(icon: const Icon(Icons.edit), tooltip: 'Edit', onPressed: onTap);

  const CommonActionIcon.copy(this.onTap)
      : super(icon: const Icon(Icons.content_copy), tooltip: 'Copy', onPressed: onTap);

  const CommonActionIcon.remove(this.onTap)
      : super(icon: const Icon(Icons.delete), tooltip: 'Remove', onPressed: onTap);
}
