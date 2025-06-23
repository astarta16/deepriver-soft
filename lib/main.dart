import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/match_bloc.dart';
import 'blocs/match_event.dart';
import 'services/mock_websocket.dart';
import 'storage/odds_storage.dart';
import 'ui/screens/live_match_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final matchBloc = MatchBloc();

  final storedOdds = await OddsStorage.loadSelectedOdds();
  for (var entry in storedOdds.entries) {
    matchBloc.add(SelectOdd(matchId: entry.key, betType: entry.value));
  }

  matchBloc.add(LoadMatches());

  final websocket = MockWebSocketService(matchBloc: matchBloc);
  websocket.start();

  runApp(MyApp(matchBloc: matchBloc));
}

class MyApp extends StatelessWidget {
  final MatchBloc matchBloc;

  const MyApp({super.key, required this.matchBloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Matches',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: BlocProvider.value(
        value: matchBloc,
        child: const LiveMatchScreen(),
      ),
    );
  }
}
