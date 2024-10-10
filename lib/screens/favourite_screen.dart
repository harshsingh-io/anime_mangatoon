import 'package:flutter/material.dart';
import 'package:anime_mangatoon/models/webtoonModel.dart';
import 'package:anime_mangatoon/screens/detail_screen.dart';
import 'package:anime_mangatoon/services/data_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DataService dataService = DataService();
  List<String> favoriteTitles = [];
  List<Webtoon> favoriteWebtoons = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteTitles = prefs.getStringList('favorites') ?? [];
    final allWebtoons = await dataService.loadWebtoons();

    setState(() {
      favoriteWebtoons = allWebtoons
          .where((webtoon) => favoriteTitles.contains(webtoon.title))
          .toList();
    });
  }

  void navigateToDetailScreen(String title) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(title: title),
      ),
    );

    if (result == true) {
      _loadFavorites();
    }
  }

  void _removeFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    favoriteTitles.remove(title);
    await prefs.setStringList('favorites', favoriteTitles);
    _loadFavorites(); 
  }

  void _confirmRemoveFavorite(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Favorite'),
          content: Text(
              'Are you sure you want to remove $title from your favorites?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: Text('Remove'),
              onPressed: () {
                _removeFavorite(title);
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: favoriteWebtoons.isEmpty
          ? Center(child: Text('No favorites added'))
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.width / 2) / 260,
              ),
              itemCount: favoriteWebtoons.length,
              itemBuilder: (context, index) {
                final webtoon = favoriteWebtoons[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(title: webtoon.title),
                      ),
                    );
                  },
                  onLongPress: () => _confirmRemoveFavorite(webtoon.title),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              webtoon.imageLink,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            webtoon.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              webtoon.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.lightGreenAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              webtoon.genre,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
