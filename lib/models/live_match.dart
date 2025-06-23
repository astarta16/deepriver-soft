class LiveMatch {
  final int id;
  final String sport;
  final String teamA;
  final String teamB;
  final DateTime startTime;
  final int scoreA;
  final int scoreB;
  final Map<String, double> odds;

  LiveMatch({
    required this.id,
    required this.sport,
    required this.teamA,
    required this.teamB,
    required this.startTime,
    required this.scoreA,
    required this.scoreB,
    required this.odds,
  });

  LiveMatch copyWith({
    int? id,
    String? sport,
    String? teamA,
    String? teamB,
    DateTime? startTime,
    int? scoreA,
    int? scoreB,
    Map<String, double>? odds,
  }) {
    return LiveMatch(
      id: id ?? this.id,
      sport: sport ?? this.sport,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      startTime: startTime ?? this.startTime,
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      odds: odds ?? this.odds,
    );
  }

  factory LiveMatch.fromJson(Map<String, dynamic> json) {
    return LiveMatch(
      id: json['id'],
      sport: json['sport'],
      teamA: json['teamA'],
      teamB: json['teamB'],
      startTime: DateTime.parse(json['startTime']),
      scoreA: json['scoreA'],
      scoreB: json['scoreB'],
      odds: Map<String, double>.from(json['odds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sport': sport,
      'teamA': teamA,
      'teamB': teamB,
      'startTime': startTime.toIso8601String(),
      'scoreA': scoreA,
      'scoreB': scoreB,
      'odds': odds,
    };
  }

  factory LiveMatch.empty() {
    return LiveMatch(
      id: -1,
      sport: '',
      teamA: '',
      teamB: '',
      startTime: DateTime.now(),
      scoreA: 0,
      scoreB: 0,
      odds: {},
    );
  }
}
