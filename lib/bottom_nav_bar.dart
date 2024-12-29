import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color selectedColor;
  final Color unselectedColor;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.selectedColor = Colors.teal,
    this.unselectedColor = Colors.grey,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<IconData> _icons = [
    Icons.calculate,
    Icons.sync,
    Icons.home,
    Icons.animation,
    Icons.person,
  ];

  final List<String> _labels = [
    'Calculator',
    'Converter',
    'Home',
    'Patient',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _icons[index],
              color: isSelected ? widget.selectedColor : widget.unselectedColor,
              size: isSelected ? 28 : 24, // Animate icon size
            ),
            const SizedBox(height: 4),
            Text(
              _labels[index],
              style: TextStyle(
                color:
                    isSelected ? widget.selectedColor : widget.unselectedColor,
                fontSize: isSelected ? 12 : 11, // Animate font size
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
