import 'package:equatable/equatable.dart';
import '../models/live_match.dart';

class MatchState extends Equatable {
  final List<LiveMatch> matches;
  final Map<int, String> selectedOdds;
  final Map<int, Map<String, String>> highlightedOdds;

  const MatchState({
    required this.matches,
    required this.selectedOdds,
    required this.highlightedOdds,
  });

  factory MatchState.initial() =>
      const MatchState(matches: [], selectedOdds: {}, highlightedOdds: {});

  MatchState copyWith({
    List<LiveMatch>? matches,
    Map<int, String>? selectedOdds,
    Map<int, Map<String, String>>? highlightedOdds,
  }) {
    return MatchState(
      matches: matches ?? this.matches,
      selectedOdds: selectedOdds ?? this.selectedOdds,
      highlightedOdds: highlightedOdds ?? this.highlightedOdds,
    );
  }

  @override
  List<Object?> get props => [matches, selectedOdds, highlightedOdds];
}
