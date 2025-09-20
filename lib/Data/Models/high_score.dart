import 'package:equatable/equatable.dart';

class HighScore extends Equatable {
  final int score;
  final DateTime date;

  const HighScore({required this.score, required this.date});

  Map<String, dynamic> toJson() => {'score': score, 'date': date.toIso8601String()};

  factory HighScore.fromJson(Map<String, dynamic> json) {
    return HighScore(
      score: json['score'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  @override
  List<Object> get props => [score, date];
}