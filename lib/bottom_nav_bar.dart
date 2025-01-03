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
          padding: const EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: 8.0), // Adjust padding for better centering
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Ensures equal spacing
            children:
                List.generate(_icons.length, (index) => _buildNavItem(index)),
          ),
        ),
      ),
    );
  }

    Widget _buildNavItem(int index) {
    final bool isSelected = index == widget.currentIndex;
    return Expanded(
      // Ensures equal space for each item
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              MainAxisAlignment.center, // Aligns items vertically
          children: [
            Icon(
              _icons[index],
              color: isSelected ? widget.selectedColor : widget.unselectedColor,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              _labels[index],
              style: TextStyle(
                color:
                    isSelected ? widget.selectedColor : widget.unselectedColor,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
