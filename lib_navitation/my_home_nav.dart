import 'package:flutter/material.dart';
import 'screens/detail_pg.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/profile_screen.dart';

class MyHomeNav extends StatefulWidget {
  const MyHomeNav({super.key});

  @override
  State<MyHomeNav> createState() => _MyHomeNavState();
}

class _MyHomeNavState extends State<MyHomeNav> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeScreen(),
          SearchScreen(),
          SettingScreen(),
          ProfileScreen(),
          DetailPg(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
