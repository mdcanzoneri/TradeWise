import 'package:flutter/material.dart';
import 'package:tradewise/constants/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: AppColors.darkGray,
      selectedItemColor: AppColors.electricBlue,
      unselectedItemColor: Colors.white54,
      selectedIconTheme: const IconThemeData(size: 32),
      unselectedIconTheme: const IconThemeData(size: 32),
      selectedLabelStyle: const TextStyle(height: 1.0),
      unselectedLabelStyle: const TextStyle(height: 1.0),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      iconSize: 32,
      items: const [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.mic),
          ),
          label: 'Record',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.work),
          ),
          label: 'Jobs',
        ),
      ],
    );
  }
}
