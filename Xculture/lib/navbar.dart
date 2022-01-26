import 'package:flutter/material.dart';
import 'package:xculturetestapi/pages/menu/menu_page.dart';
import 'package:xculturetestapi/pages/search_page.dart';
import 'package:xculturetestapi/pages/event/event_page.dart';
import 'package:xculturetestapi/pages/forum/forum_home.dart';
import 'package:xculturetestapi/pages/community/commu_page.dart';

class Navbar {
  static List pages = [
    const EventPage(),
    const SearchPage(),
    const ForumPage(),
    const CommuPage(),
    const MenuPage()
  ];

  static Widget navbar(context, int pageIndex) {
    int currentIndex = pageIndex; 

    return BottomNavigationBar(
      items: const [
          BottomNavigationBarItem(label: "Event", icon: Icon(Icons.room)),
          BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Community", icon: Icon(Icons.groups)),
          BottomNavigationBarItem(label: "Menu", icon: Icon(Icons.menu)),
      ],
      onTap: (index) {
        currentIndex = index;
        Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
      },
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.yellow[700],
      unselectedItemColor: Colors.grey.withOpacity(0.4),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
    );
  }
}