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
    return Container(
      color: const Color(0xFF1A1A2F),
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.amber[700] : const Color(0xFF2A2A3D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.amber : Colors.grey.shade700,
                  width: 1.2,
                ),
              ),
              child: Center(
                child: Text(
                  sport,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
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
