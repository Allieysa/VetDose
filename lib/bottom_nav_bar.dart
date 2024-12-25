import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color.fromARGB(113, 164, 252, 237),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) => _buildNavItem(index)),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = index == widget.currentIndex;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconForIndex(index),
            color: isSelected
                ? const Color.fromARGB(222, 108, 159, 150)
                : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            _getLabelForIndex(index),
            style: TextStyle(
              color: isSelected
                  ? const Color.fromARGB(222, 108, 159, 150)
                  : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.calculate;
      case 1:
        return Icons.sync;
      case 2:
        return Icons.home;
      case 3:
        return Icons.animation;
      case 4:
        return Icons.person;
      default:
        return Icons.error;
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Calculator';
      case 1:
        return 'Converter';
      case 2:
        return 'Home';
      case 3:
        return 'Patient';
      case 4:
        return 'Profile';
      default:
        return '';
    }
  }
}
