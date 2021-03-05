import 'package:flutter/material.dart';
import 'package:jewtubefirestore/utils/custom_colors.dart';

class BottomNavBarWidget extends StatelessWidget {
  final void Function(int index) onItemTap;
  final int selectedIndex;
  const BottomNavBarWidget({
    @required this.onItemTap,
    @required this.selectedIndex,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: getColor(1),
              size: 32,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
              color: getColor(2),
              size: 23,
            ),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.subscriptions,
              color: getColor(2),
              size: 23,
            ),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.file_download,
              color: getColor(2),
              size: 23,
            ),
            label: 'Downloads',
          ),
        ],
        currentIndex: selectedIndex,
        elevation: 20.0,
        // selectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        onTap: (index) => onItemTap(index),
      ),
    );
  }

  getColor(int index) {
    if (index == selectedIndex) {
      return CustomColor.primaryColor;
    } else {
      return CustomColor.grayColor;
    }
  }
}
