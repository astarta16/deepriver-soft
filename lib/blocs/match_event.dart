import 'package:equatable/equatable.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object?> get props => [];
}

class LoadMatches extends MatchEvent {}

class UpdateOdds extends MatchEvent {
  final int matchId;
  final Map<String, double> newOdds;

  const UpdateOdds({required this.matchId, required this.newOdds});

  @override
  List<Object?> get props => [matchId, newOdds];
}

class SelectOdd extends MatchEvent {
  final int matchId;
  final String betType;

  const SelectOdd({required this.matchId, required this.betType});

  @override
  List<Object?> get props => [matchId, betType];
}
