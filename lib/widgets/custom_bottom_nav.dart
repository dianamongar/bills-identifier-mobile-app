import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final Color primaryColor = const Color(0xFF0D47A1); // Azul rey

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.mic,
            label: 'Asistente',
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.camera_alt,
            label: 'Cámara',
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.attach_money,
            label: 'Modo contador',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 34, // 👁️ más grande para accesibilidad
                color: isSelected ? primaryColor : Colors.white,
              ),
              const SizedBox(height: 4),
              // Text(
              //   label,
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: isSelected ? primaryColor : Colors.white,
              //     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
