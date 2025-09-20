import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/Data/Models/high_score.dart';

class HighScoreRepository {
  static const String _key = 'high_scores';

  Future<List<HighScore>> getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList
        .map((json) => HighScore.fromJson(jsonDecode(json)))
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  Future<void> saveHighScore(HighScore highScore) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getHighScores();
    scores.add(highScore);
    scores.sort((a, b) => b.score.compareTo(a.score));
    final topScores = scores.take(10).map((score) => jsonEncode(score.toJson())).toList();
    await prefs.setStringList(_key, topScores);
  }
}