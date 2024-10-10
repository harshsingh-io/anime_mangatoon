import 'dart:convert';
import 'package:anime_mangatoon/models/webtoonDetailModel.dart';
import 'package:anime_mangatoon/models/webtoonModel.dart';
import 'package:flutter/services.dart';

class DataService {
  Future<List<Webtoon>> loadWebtoons() async {
    try {
      final dataString = await rootBundle.loadString('lib/data/webtoons.json');
      final Map<String, dynamic> jsonData = jsonDecode(dataString);
      final List<dynamic> webtoonsJson = jsonData['webtoons'];
      return webtoonsJson.map((json) => Webtoon.fromJson(json)).toList();
    } catch (e) {
      print('Error loading webtoons: $e');
      rethrow;
    }
  }

  Future<WebtoonDetail> loadWebtoonDetail(String title) async {
    final dataString =
        await rootBundle.loadString('lib/data/lore_olympus.json');
    final jsonData = jsonDecode(dataString)['detailScreen'];
    return WebtoonDetail.fromJson(jsonData);
  }
}
