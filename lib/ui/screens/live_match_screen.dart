import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/ui/widgets/match_card.dart';
import 'package:test/ui/widgets/sport_filter_bar.dart';
import '../../../blocs/match_bloc.dart';
import '../../../blocs/match_state.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({super.key});

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  String selectedSport = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Matches'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          SportFilterBar(
            selectedSport: selectedSport,
            onSportSelected: (sport) {
              setState(() {
                selectedSport = sport;
              });
            },
          ),
          Expanded(
            child: BlocBuilder<MatchBloc, MatchState>(
              builder: (context, state) {
                final matches =
                    state.matches.where((m) {
                      if (selectedSport == 'All') return true;
                      return m.sport == selectedSport;
                    }).toList();

                return ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return MatchCard(match: match);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
