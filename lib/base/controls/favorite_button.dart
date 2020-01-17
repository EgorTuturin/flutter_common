import 'package:flutter/material.dart';

typedef FavoriteCallback = void Function(bool favorite);

class FavoriteStarButton extends StatefulWidget {
  final Color selectedColor;
  final Color unselectedColor;
  final FavoriteCallback onFavoriteChanged;
  final bool initFavorite;

  FavoriteStarButton(this.initFavorite,
      {this.selectedColor, this.unselectedColor, this.onFavoriteChanged});

  @override
  _FavoriteStarButtonState createState() {
    return _FavoriteStarButtonState();
  }
}

class _FavoriteStarButtonState extends State<FavoriteStarButton> {
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
    final unselectedColor =
        widget.unselectedColor ?? Theme.of(context).unselectedWidgetColor;
    return IconButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          setFavorite(!_isFavorite);
        },
        icon: Icon(_isFavorite ? Icons.star : Icons.star_border),
        color: _isFavorite ? selectedColor : unselectedColor);
  }
}
