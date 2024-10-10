import 'package:flutter/material.dart';
import 'package:anime_mangatoon/models/webtoonModel.dart';
import 'package:anime_mangatoon/screens/detail_screen.dart';
import 'package:anime_mangatoon/services/data_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// FavoritesScreen displays a list of favorite webtoons saved by the user.
/// It allows users to view, remove, or add to their list of favorites.
class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DataService dataService = DataService();
  List<String> favoriteTitles =
      []; // Holds the titles of the favorite webtoons.
  List<Webtoon> favoriteWebtoons =
      []; // Holds the list of favorite webtoon objects.

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Load favorites when the screen initializes.
  }

  /// Loads the favorite webtoons from SharedPreferences and filters them from all webtoons.
  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteTitles = prefs.getStringList('favorites') ?? [];
    final allWebtoons = await dataService.loadWebtoons();

    setState(() {
      // Filter the list of all webtoons to only include those that are favorites.
      favoriteWebtoons = allWebtoons
          .where((webtoon) => favoriteTitles.contains(webtoon.title))
          .toList();
    });
  }

  /// Navigates to the DetailScreen of a selected webtoon and refreshes favorites upon return if changes were made.
  void navigateToDetailScreen(String title) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(title: title),
      ),
    );

    // If the DetailScreen returned true (meaning favorites were updated), reload favorites.
    if (result == true) {
      _loadFavorites();
    }
  }

  /// Removes a webtoon from the favorites list.
  void _removeFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    favoriteTitles.remove(title);
    await prefs.setStringList('favorites', favoriteTitles);
    _loadFavorites(); // Refresh the list to reflect the change.
  }

  /// Confirms with the user before removing a webtoon from favorites.
  void _confirmRemoveFavorite(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Favorite'),
          content: Text(
              'Are you sure you want to remove $title from your favorites?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without doing anything.
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                _removeFavorite(title);
                Navigator.of(context)
                    .pop(); // Close the dialog after removing the favorite.
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
      appBar: AppBar(title: const Text('Favorites')),
      body: favoriteWebtoons.isEmpty
          ? const Center(
              child: Text(
                  'No favorites added')) // Display a message if no favorites are added.
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                    260, // Set aspect ratio for grid items.
              ),
              itemCount: favoriteWebtoons.length,
              itemBuilder: (context, index) {
                final webtoon = favoriteWebtoons[index];
                return GestureDetector(
                  onTap: () {
                    navigateToDetailScreen(
                        webtoon.title); // Go to detail screen on tap.
                  },
                  onLongPress: () => _confirmRemoveFavorite(
                      webtoon.title), // Confirm removal on long press.
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
                          const SizedBox(height: 8),
                          Text(
                            webtoon.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Text(
                              webtoon.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
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
