import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/live_match.dart';
import 'match_event.dart';
import 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchBloc() : super(MatchState.initial()) {
    on<LoadMatches>(_onLoadMatches);
    on<UpdateOdds>(_onUpdateOdds);
    on<SelectOdd>(_onSelectOdd);
  }

  Future<void> _onLoadMatches(
    LoadMatches event,
    Emitter<MatchState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_matches');
    final cachedOddsRaw = prefs.getString('selected_odds');

    List<LiveMatch> matches;

    if (cachedData != null) {
      final List<dynamic> decodedList = jsonDecode(cachedData);
      matches =
          decodedList
              .map((e) => LiveMatch.fromJson(e as Map<String, dynamic>))
              .toList();
      debugPrint('✅ Loaded cached matches: ${matches.length}');
    } else {
      final faker = Faker();
      final sports = [
        'Football',
        'Tennis',
        'Basketball',
        'Hockey',
        'Volleyball',
      ];

      matches = List.generate(10000, (index) {
        return LiveMatch(
          id: index,
          sport: sports[index % sports.length],
          teamA: faker.sport.name(),
          teamB: faker.sport.name(),
          startTime: DateTime.now().add(Duration(minutes: index % 60)),
          scoreA: 0,
          scoreB: 0,
          odds: {
            '1': faker.randomGenerator.decimal(min: 1.5, scale: 2.0),
            'X': faker.randomGenerator.decimal(min: 2.5, scale: 3.0),
            '2': faker.randomGenerator.decimal(min: 1.8, scale: 2.5),
          },
        );
      });

      final jsonEncoded = jsonEncode(matches.map((e) => e.toJson()).toList());
      await prefs.setString('cached_matches', jsonEncoded);
    }

    Map<int, String> restoredOdds = {};
    if (cachedOddsRaw != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(cachedOddsRaw);
      for (var entry in jsonMap.entries) {
        final matchId = int.tryParse(entry.key);
        final value = entry.value;
        if (matchId != null && matches.any((m) => m.id == matchId)) {
          restoredOdds[matchId] = value;
          debugPrint('🔁 Restored selected odd: matchId=$matchId, bet=$value');
        }
      }
    }

    debugPrint('✅ Fully restored selected odds: $restoredOdds');
    emit(
      state.copyWith(
        matches: matches,
        selectedOdds: restoredOdds,
        highlightedOdds: {},
      ),
    );
  }

  Future<void> _onUpdateOdds(UpdateOdds event, Emitter<MatchState> emit) async {
    debugPrint('📈 Updating odds for match ${event.matchId}');

    final oldMatch = state.matches.firstWhere((m) => m.id == event.matchId);
    final highlights = <String, String>{};

    event.newOdds.forEach((key, newVal) {
      final oldVal = oldMatch.odds[key] ?? 0.0;
      if (newVal > oldVal) {
        highlights[key] = 'up';
      } else if (newVal < oldVal) {
        highlights[key] = 'down';
      }
    });

    debugPrint(
      '🔥 Highlight triggered for match ${event.matchId}: $highlights',
    );

    final updatedMatches =
        state.matches.map((match) {
          if (match.id == event.matchId) {
            debugPrint(
              '🔄 Updating match ${match.id} odds to ${event.newOdds}',
            );
            return match.copyWith(odds: event.newOdds);
          }
          return match;
        }).toList();

    final newHighlightedOdds = Map<int, Map<String, String>>.from(
      state.highlightedOdds,
    );
    newHighlightedOdds[event.matchId] = highlights;

    emit(
      state.copyWith(
        matches: updatedMatches,
        highlightedOdds: newHighlightedOdds,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (!emit.isDone) {
      final currentState = state;
      final cleaned = Map<int, Map<String, String>>.from(
        currentState.highlightedOdds,
      )..remove(event.matchId);
      debugPrint('🧹 Removing highlight for match ${event.matchId}');
      emit(state.copyWith(highlightedOdds: cleaned));
    }
  }

  Timer? _saveDebounce;

  void _onSelectOdd(SelectOdd event, Emitter<MatchState> emit) {
    final currentSelected = Map<int, String>.from(state.selectedOdds);
    currentSelected[event.matchId] = event.betType;

    emit(state.copyWith(selectedOdds: currentSelected));

    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 300), () async {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, String> converted = currentSelected.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      await prefs.setString('selected_odds', jsonEncode(converted));
      debugPrint('✅ Debounced save: $converted');
    });
  }
}
