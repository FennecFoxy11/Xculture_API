import 'menu/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:xculturetestapi/pages/search_page.dart';
import 'package:xculturetestapi/pages/event/event_page.dart';
import 'package:xculturetestapi/pages/forum/forum_home.dart';
import 'package:xculturetestapi/pages/community/commu_page.dart';


class NavBar extends StatefulWidget{
  const NavBar({ Key? key }) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
  
}

class _NavBarState extends State<NavBar> {
  
  List pages = [
    const EventPage(),
    const SearchPage(),
    const ForumPage(),
    const CommuPage(),
    const MenuPage()
  ];
  int currentIndex = 2;
  void onTap(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.yellow[700],
        unselectedItemColor: Colors.grey.withOpacity(0.4),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(title: Text("Event"), icon: Icon(Icons.room)),
          BottomNavigationBarItem(title: Text("Search"), icon: Icon(Icons.search)),
          BottomNavigationBarItem(title: Text("Home"), icon: Icon(Icons.home)),
          BottomNavigationBarItem(title: Text("Community"), icon: Icon(Icons.groups)),
          BottomNavigationBarItem(title: Text("Menu"), icon: Icon(Icons.menu)),
        ],
      ),
    );
  }
}