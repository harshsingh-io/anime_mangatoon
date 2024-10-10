import 'package:flutter/material.dart';
import 'package:anime_mangatoon/models/webtoonModel.dart';
import 'package:anime_mangatoon/screens/detail_screen.dart';
import 'package:anime_mangatoon/services/data_services.dart';

/// The HomeScreen StatefulWidget provides a UI to display a list of popular webtoons.
/// It fetches webtoon data asynchronously and displays it in a grid format.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// Private State class for HomeScreen managing the state of the webtoons list.
class _HomeScreenState extends State<HomeScreen> {
  /// Instance of DataService to load webtoon data.
  final DataService dataService = DataService();

  /// Future to hold a list of webtoons once the asynchronous operation of loading webtoons is complete.
  late Future<List<Webtoon>> webtoons;

  @override
  void initState() {
    super.initState();
    // Asynchronously load webtoons when the widget is initialized.
    webtoons = dataService.loadWebtoons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Popular Webtoons')),
      // FutureBuilder widget used to build the UI based on the state of the Future<List<Webtoon>>.
      body: FutureBuilder<List<Webtoon>>(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Builds a GridView of webtoons if data is present.
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid.
                childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                    250, // Aspect ratio of each grid cell.
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final webtoon = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the DetailScreen when a webtoon is tapped.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(title: webtoon.title),
                      ),
                    );
                  },
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
                          Text(
                            webtoon.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
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
            );
          } else if (snapshot.hasError) {
            // Displays an error message if the future encounters an error.
            return const Center(child: Text('Error loading webtoons'));
          }
          // Displays a loading spinner while waiting for the data.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
