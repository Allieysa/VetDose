// ignore_for_file: use_super_parameters, library_private_types_in_public_api, prefer_const_constructors

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
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(113, 164, 252, 237),
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)), // Rounded corners
      ),
      child: BottomAppBar(
        color: Colors.transparent, // Keep the BottomAppBar transparent
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            return _buildNavItem(index);
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = index == widget.currentIndex;

    return GestureDetector(
      onTap: () {
        widget.onTap(index);
        setState(() {}); // Refresh to show updated state
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            vertical: 4), // Adjust vertical padding to reduce height
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0, // Scale up the selected icon
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _getIconForIndex(index),
                color: isSelected
                    ? const Color.fromARGB(222, 108, 159, 150)
                    : Colors.grey, // Change color based on selection
              ),
            ),
            const SizedBox(height: 2), // Space between icon and label
            Text(
              _getLabelForIndex(index),
              style: TextStyle(
                color: isSelected
                    ? const Color.fromARGB(222, 108, 159, 150)
                    : Colors.grey, // Change label color based on selection
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.medical_services;
      case 1:
        return Icons.sync;
      case 2:
        return Icons.home;
      case 3:
        return Icons.calculate;
      case 4:
        return Icons.person;
      default:
        return Icons.error; // Default icon if needed
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Drugs';
      case 1:
        return 'Converter';
      case 2:
        return 'Home';
      case 3:
        return 'Calculator';
      case 4:
        return 'Profile';
      default:
        return '';
    }
  }
}
