import 'package:flutter/material.dart';

class AnimatedFavoriteButton extends StatefulWidget {
  final bool initialIsFavorite;
  final Function(bool) onFavoriteChanged;

  AnimatedFavoriteButton(
      {this.initialIsFavorite = false, required this.onFavoriteChanged});

  @override
  _AnimatedFavoriteButtonState createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton> {
  late bool isFavorite;
  double iconSize = 24;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialIsFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isFavorite ? Colors.red : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: toggleFavorite,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.favorite,
                color: isFavorite ? Colors.white : Colors.grey, size: iconSize),
            SizedBox(width: 8),
            Text(
              isFavorite ? 'Added to Favorites' : 'Add to Favorites',
              style: TextStyle(
                color: isFavorite ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      iconSize =
          isFavorite ? 28 : 24; 
    });

    widget.onFavoriteChanged(isFavorite);

    Future.delayed(Duration(milliseconds: 150), () {
      setState(() {
        iconSize = 24;
      });
    });
  }
}
