import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/match_bloc.dart';
import '../../blocs/match_event.dart';
import '../../blocs/match_state.dart';
import '../../models/live_match.dart';

class MatchCard extends StatelessWidget {
  final LiveMatch match;

  const MatchCard({super.key, required this.match});

  IconData _sportIcon(String sport) {
    switch (sport) {
      case 'Football':
        return Icons.sports_soccer;
      case 'Tennis':
        return Icons.sports_tennis;
      case 'Basketball':
        return Icons.sports_basketball;
      case 'Hockey':
        return Icons.sports_hockey;
      case 'Volleyball':
        return Icons.sports_volleyball;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) {
        final bloc = context.read<MatchBloc>();
        final selected = state.selectedOdds[match.id];
        final matchHighlights = state.highlightedOdds[match.id] ?? {};

        debugPrint('💡 Match ID: ${match.id}');
        debugPrint('➡️ Selected: $selected, Highlights: $matchHighlights');

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_sportIcon(match.sport), color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${match.teamA} vs ${match.teamB}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      DateFormat.Hm().format(match.startTime),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Score: ${match.scoreA} - ${match.scoreB}'),
                const SizedBox(height: 8),
                Row(
                  children:
                      match.odds.entries.map((entry) {
                        final betType = entry.key;
                        final oddsValue = entry.value;
                        final isSelected = selected == betType;
                        final highlight = matchHighlights[betType];

                        debugPrint(
                          '🎯 Match ${match.id}, Bet=$betType, Odds=$oddsValue, Selected=$isSelected, Highlight=$highlight',
                        );

                        Color? backgroundColor;
                        if (isSelected) {
                          backgroundColor = Colors.deepPurple;
                        } else if (highlight == 'up') {
                          backgroundColor = Colors.green[100];
                        } else if (highlight == 'down') {
                          backgroundColor = Colors.red[100];
                        } else {
                          backgroundColor = Colors.grey[200];
                        }

                        return GestureDetector(
                          onTap: () {
                            debugPrint(
                              '🟣 Tapped: Match=${match.id}, Bet=$betType',
                            );
                            bloc.add(
                              SelectOdd(matchId: match.id, betType: betType),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  betType,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  oddsValue.toStringAsFixed(2),
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                  ),
                                ),
                                if (highlight != null)
                                  Text(
                                    highlight == 'up' ? '↑' : '↓',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          highlight == 'up'
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 4),
                Text(
                  '⏱ Last build: ${DateTime.now().toIso8601String().substring(11, 19)}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
