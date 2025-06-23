
import 'package:flutter/material.dart';

class SportFilterBar extends StatelessWidget {
  final String selectedSport;
  final Function(String) onSportSelected;

  const SportFilterBar({
    super.key,
    required this.selectedSport,
    required this.onSportSelected,
  });

  static const List<String> sports = [
    'All',
    'Football',
    'Tennis',
    'Basketball',
    'Hockey',
    'Volleyball',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final sport = sports[index];
          final isSelected = sport == selectedSport;

          return GestureDetector(
            onTap: () => onSportSelected(sport),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepPurple : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  sport,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
