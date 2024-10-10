import 'dart:convert';
import 'package:anime_mangatoon/models/webtoonDetailModel.dart';
import 'package:anime_mangatoon/models/webtoonModel.dart';
import 'package:flutter/services.dart';

/// DataService class handles loading and decoding webtoon data from local JSON files.
class DataService {
  /// Loads a list of webtoons from a local JSON file.
  ///
  /// Returns a list of [Webtoon] objects after parsing the JSON data.
  /// Throws an exception if there is an issue loading or parsing the data.
  Future<List<Webtoon>> loadWebtoons() async {
    try {
      // Load the JSON string from the local file system.
      final dataString = await rootBundle.loadString('lib/data/webtoons.json');
      // Decode the JSON string into a dynamic object.
      final Map<String, dynamic> jsonData = jsonDecode(dataString);
      // Extract the list of webtoons from the JSON object.
      final List<dynamic> webtoonsJson = jsonData['webtoons'];
      // Map the dynamic list to a list of Webtoon objects.
      return webtoonsJson.map((json) => Webtoon.fromJson(json)).toList();
    } catch (e) {
      // Print the error and rethrow it for handling by the caller.
      print('Error loading webtoons: $e');
      rethrow;
    }
  }

  /// Loads the details of a specific webtoon by title from a local JSON file.
  ///
  /// The [title] parameter is used to fetch the corresponding webtoon detail data.
  /// Returns a [WebtoonDetail] object for the specified webtoon.
  Future<WebtoonDetail> loadWebtoonDetail(String title) async {
    try {
      // Load the JSON string from the local file system based on the webtoon title.
      final dataString =
          await rootBundle.loadString('lib/data/lore_olympus.json');
      // Decode the JSON string into a dynamic object.
      final jsonData = jsonDecode(dataString)['detailScreen'];
      // Convert the dynamic data into a WebtoonDetail object using a factory constructor.
      return WebtoonDetail.fromJson(jsonData);
    } catch (e) {
      // Print the error and rethrow it for handling by the caller.
      print('Error loading webtoon details for $title: $e');
      rethrow;
    }
  }
}
