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

        return Card(
          color: const Color(0xFF1E1E2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_sportIcon(match.sport), color: Colors.amberAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${match.teamA} vs ${match.teamB}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat.Hm().format(match.startTime),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Score: ${match.scoreA} - ${match.scoreB}',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Row(
                  children:
                      match.odds.entries.map((entry) {
                        final betType = entry.key;
                        final oddsValue = entry.value;
                        final isSelected = selected == betType;
                        final highlight = matchHighlights[betType];

                        Color? backgroundColor;
                        if (isSelected) {
                          backgroundColor = const Color(0xFF394867);
                        } else if (highlight == 'up') {
                          backgroundColor = const Color(0xFF1F3F2E);
                        } else if (highlight == 'down') {
                          backgroundColor = const Color(0xFF3A1F1F);
                        } else {
                          backgroundColor = const Color(0xFF2A2A3D);
                        }

                        return GestureDetector(
                          onTap: () {
                            bloc.add(
                              SelectOdd(matchId: match.id, betType: betType),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  isSelected
                                      ? Border.all(
                                        color: Colors.amber,
                                        width: 1.2,
                                      )
                                      : null,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  betType,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.amber
                                            : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  oddsValue.toStringAsFixed(2),
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.amber
                                            : Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (highlight != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      highlight == 'up' ? '↑' : '↓',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color:
                                            highlight == 'up'
                                                ? Colors.greenAccent
                                                : Colors.redAccent,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
