import 'package:barcode_scanner/components/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  final List<String> labels;
  final int numberOfTabs;
  final List<IconData> icons;  // Add this

  MyBottomNavBar({super.key, required this.onTabChange, required this.labels, this.numberOfTabs = 3, required this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: GNav(
        onTabChange: (value) => onTabChange!(value),
        color: AppColors.text,
        mainAxisAlignment: MainAxisAlignment.center,
        activeColor: AppColors.icon,
        tabBackgroundColor: AppColors.background,
        tabBorderRadius: 24,
        tabActiveBorder: Border.all(color: AppColors.text),
        tabs: List.generate(
            numberOfTabs,
                (index) => GButton(
                icon: icons[index],  // Use icons from the list
                text: labels[index]
            )
        ),
      ),
    );
  }
}
