import 'package:flutter/material.dart';

import 'package:anime_mangatoon/models/webtoonModel.dart';
import 'package:anime_mangatoon/screens/detail_screen.dart';
import 'package:anime_mangatoon/services/data_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataService dataService = DataService();
  late Future<List<Webtoon>> webtoons;

  @override
  void initState() {
    super.initState();
    webtoons = dataService.loadWebtoons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Popular Webtoons')),
      body: FutureBuilder<List<Webtoon>>(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    2, 
                childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                    250, 
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final webtoon = snapshot.data![index];
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
            return const Center(child: Text('Error loading webtoons'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
