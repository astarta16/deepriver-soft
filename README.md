# Live Betting App

This Flutter mobile application simulates a real-time sports betting dashboard with **10,000+ live matches**, odds updates, animations, and local state persistence.

---

## Architecture

- **Flutter**: Latest stable version used for modern features and wide device compatibility.
- **State Management**: `flutter_bloc` is used for event-driven, predictable state transitions.

---

## UI Structure

- **LiveMatchScreen** – Main screen rendering the filtered list of matches.
- **MatchCard** – Visual representation of each match and its odds.
- **SportFilterBar** – Horizontal filter bar to select sport type.

---

## Model

- `LiveMatch`: Data class representing a match, score, odds, and metadata.

---

## WebSocket Simulation

- `MockWebSocketService`: Generates random odds updates at a predefined interval using `Timer`.

---

## Key Decisions & Optimizations

### Why BLoC?
- Clear separation of UI and business logic
- Fine-grained control over UI updates
- Scalable and easily testable structure

### Performance
- Uses `ListView.builder` to efficiently render 10,000+ items
- Only updates the UI for affected matches
- Odds changes are highlighted temporarily (1 second) with color transitions

### Persistence
- `SharedPreferences` stores selected odds across app restarts
- Restores saved state during `MatchBloc` initialization

---

## 🎲 Odds Simulation (Mock WebSocket)

Every 2 seconds, a random match is picked and one or more of its odds are either increased or decreased slightly.

- 🟢 Green = odds increased  
- 🔴 Red = odds decreased  
- Highlight effect lasts for 1 second

### 💡 Testing Tip

By default, updates affect all matches.  
To **limit updates to a few visible matches**, go to `mock_websocket_service.dart` and:

```dart
// Uncomment this line to simulate only 5 matches
final matchIndex = _rand.nextInt(5);

// Comment this line if above is enabled
final matchIndex = _rand.nextInt(totalMatches);



