
import 'dart:async';
import 'dart:math';
import '../blocs/match_bloc.dart';
import '../blocs/match_event.dart';

class MockWebSocketService {
  final MatchBloc matchBloc;
  Timer? _timer;
  final _rand = Random();

  MockWebSocketService({required this.matchBloc});

  void start({Duration interval = const Duration(seconds: 2)}) {
    _timer = Timer.periodic(interval, (_) {
      final totalMatches = matchBloc.state.matches.length;
      if (totalMatches == 0) return;

      final matchIndex = _rand.nextInt(totalMatches);
      final match = matchBloc.state.matches[matchIndex];

      final updatedOdds = <String, double>{};

      match.odds.forEach((key, value) {
        final change = _rand.nextBool() ? 0.2 : -0.2;
        final newValue = double.parse(
          (value + change).clamp(1.0, 10.0).toStringAsFixed(2),
        );

        if (newValue != value) {
          updatedOdds[key] = newValue;
        }
      });

      if (updatedOdds.isNotEmpty) {
        matchBloc.add(UpdateOdds(matchId: match.id, newOdds: updatedOdds));
        print('🟢 Odds updated for Match ${match.id}: $updatedOdds');
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }
}
