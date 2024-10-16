import 'package:anime_mangatoon/widgets/brand_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anime_mangatoon/models/webtoonDetailModel.dart';
import 'package:anime_mangatoon/services/data_services.dart';

/// DetailScreen displays detailed information about a specific webtoon.
/// It includes the webtoon's image, description, creator details, publish date,
/// and interactive elements like favorite button and rating bar.
class DetailScreen extends StatefulWidget {
  final String title;

  /// Constructs a DetailScreen that displays the details of a webtoon identified by [title].
  DetailScreen({required this.title});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  final DataService dataService = DataService();
  late Future<WebtoonDetail> webtoonDetail;
  double _userRating = 0.0;
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    // Load the details of the webtoon from the data service.
    webtoonDetail = dataService.loadWebtoonDetail(widget.title);
    _loadRating();
    _checkFavoriteStatus();
  }

  /// Checks if the webtoon is already marked as favorite.
  void _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      isFavorite = favorites.contains(widget.title);
    });
  }

  /// Updates the favorite status of the webtoon.
  void _updateFavorite(bool favorite) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    if (favorite) {
      if (!favorites.contains(widget.title)) {
        favorites.add(widget.title);
      }
    } else {
      favorites.remove(widget.title);
    }
    await prefs.setStringList('favorites', favorites);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(favorite ? 'Added to Favorites' : 'Removed from Favorites')),
    );
  }

  /// Loads the current user rating for the webtoon.
  void _loadRating() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRating = prefs.getDouble('${widget.title}_rating') ?? 0.0;
      _averageRating = _userRating;
    });
  }

  /// Saves the new rating given by the user.
  void _saveRating(double rating) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${widget.title}_rating', rating);
    setState(() {
      _userRating = rating;
      _averageRating = rating;
    });
  }

  /// Displays a dialog with detailed information about the character.
  void showCharacterDetailDialog(Character character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            padding: EdgeInsets.only(right: 10, left: 10, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(character.image,
                      width: double.infinity, fit: BoxFit.cover),
                ),
                Text(character.name,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(character.description),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds a ListTile card for a character that can be tapped to show more details.
  Widget buildCharacterCard(Character character) {
    return GestureDetector(
      onTap: () => showCharacterDetailDialog(character),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            width: 58,
            height: 58,
            child: Image.network(character.image, fit: BoxFit.cover),
          ),
        ),
        title: Text(character.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(character.description,
            maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<WebtoonDetail>(
        future: webtoonDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final webtoon = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(webtoon.imageLink),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Created by: ${webtoon.creator}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Published on: ${webtoon.publishDate}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(webtoon.description),
                      ],
                    ),
                  ),
                  AnimatedFavoriteButton(
                    initialIsFavorite: isFavorite,
                    onFavoriteChanged: _updateFavorite,
                  ),
                  Text('Rate this Webtoon'),
                  RatingBar.builder(
                    initialRating: _userRating,
                    minRating: 1,
                    itemCount: 5,
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: _saveRating,
                  ),
                  Text('Average Rating: $_averageRating'),
                  Text('Main Characters',
                      style: Theme.of(context).textTheme.headlineMedium),
                  Column(
                      children: webtoon.mainCharacters
                          .map(buildCharacterCard)
                          .toList()),
                  Text('Minor Characters',
                      style: Theme.of(context).textTheme.headlineMedium),
                  Column(
                      children: webtoon.minorCharacters
                          .map(buildCharacterCard)
                          .toList()),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading details'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
