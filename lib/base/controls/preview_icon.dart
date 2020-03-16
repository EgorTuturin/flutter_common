import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PreviewIcon extends StatelessWidget {
  final String link;
  final double height;
  final double width;
  final int type;

  PreviewIcon.live(this.link, {this.height, this.width}) : this.type = 0;

  PreviewIcon.vod(this.link, {this.height, this.width}) : this.type = 1;

  String assetsLink() {
    switch (type) {
      case 0:
        return 'install/assets/unknown_channel.png';
        break;
      case 1:
        return 'install/assets/unknown_preview.png';
        break;
      default:
        return 'install/assets/unknown_channel.png';
    }
  }

  Widget defaultIcon() {
    return Image.asset(assetsLink(), height: height, width: width);
  }

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
        imageUrl: link,
        placeholder: (context, url) => defaultIcon(),
        errorWidget: (context, url, error) => defaultIcon(),
        height: height,
        width: width);
    return ClipRect(child: image);
  }
}
