import 'package:flutter/material.dart';
import 'package:flutter_common/tv/tv_controls.dart';

typedef FavoriteCallback = void Function(bool favorite);

class FavoriteStarButton extends StatefulWidget {
  final Color selectedColor;
  final Color unselectedColor;
  final FavoriteCallback onFavoriteChanged;
  final bool initFavorite;
  final FocusNode focusNode;

  FavoriteStarButton(this.initFavorite, {this.selectedColor, this.unselectedColor, this.onFavoriteChanged, this.focusNode});

  @override
  _FavoriteStarButtonState createState() {
    return _FavoriteStarButtonState();
  }
}

class _FavoriteStarButtonState extends State<FavoriteStarButton> with BaseTVControls {
  bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initFavorite;
  }

  void setFavorite(bool favorite) {
    setState(() {
      _isFavorite = favorite;
      if (widget.onFavoriteChanged != null) {
        widget.onFavoriteChanged(favorite);
      }
    });
  }

  @override
  void didUpdateWidget(FavoriteStarButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isFavorite = widget.initFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = widget.selectedColor ?? Theme.of(context).accentColor;
    final unselectedColor = widget.unselectedColor ?? Theme.of(context).primaryIconTheme.color;
    return IconButton(
        focusNode: FocusNode(onKey: (node, event) {
          return nodeAction(FocusScope.of(context), node, event, () {
            setFavorite(!_isFavorite);
          });
        }),
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          setFavorite(!_isFavorite);
        },
        icon: Icon(_isFavorite ? Icons.star : Icons.star_border),
        color: _isFavorite ? selectedColor : unselectedColor);
  }
}
