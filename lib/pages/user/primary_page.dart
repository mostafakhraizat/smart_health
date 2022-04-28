import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:smart_health/pages/user/home_user.dart';
import 'package:smart_health/pages/user/settings_page.dart';
class PrimaryPage extends StatefulWidget {
  const PrimaryPage({Key? key}) : super(key: key);

  @override
  _PrimaryPageState createState() => _PrimaryPageState();
}

class _PrimaryPageState extends State<PrimaryPage> {
  int _currentIndex=0;
  Color primary = const Color(0xff41d9a5);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        body: _currentIndex==0?const UserHomePage():_currentIndex==1?const Text('2'):_currentIndex==2?const Center(
          child: Text('No Notifications for the moment!',style: TextStyle(
              fontWeight: FontWeight.bold,fontFamily: 'Mulish'
          ),),
        ):const SettingsPage(),
        appBar: null,
        bottomNavigationBar: ClipRRect(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SalomonBottomBar(
                  unselectedItemColor: primary,
                  currentIndex: _currentIndex,
                  selectedItemColor: primary,
                  onTap: (i) => setState(() => _currentIndex = i),
                  items: barItems()),
            ),
            margin: const EdgeInsets.only(top: 6.0),
            //Same as `blurRadius` i guess
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)),
              color: Color(0xfffafafa),
            ),
          ),
        )
    ));
  }
  List<SalomonBottomBarItem> barItems() {
    List<SalomonBottomBarItem> items = [];
    items.add(SalomonBottomBarItem(
        icon: Icon(
          _currentIndex == 0 ? Icons.home : Icons.home_outlined,

          color:primary,
          semanticLabel: 'Home',
          size: 20,
        ),
        title: const Text('Home', style: TextStyle(fontSize: 12,fontFamily: 'Mulish'))));
    items.add(SalomonBottomBarItem(
        icon: Icon(
          _currentIndex == 1
              ? Icons.favorite
              : Icons.favorite_outline,
          semanticLabel: 'Favorites',
          color:primary,),
        title: const Text('Favorites', style: TextStyle(fontSize: 12,fontFamily: 'Mulish'))));
    items.add(SalomonBottomBarItem(
        icon: Badge(
          child: Icon(_currentIndex == 2
              ? Icons.notifications
              : Icons.notifications_outlined,
            color:primary,),
          elevation: 0,
          badgeColor:
          primary,
          badgeContent: const Text(''
          ),
        ),
        title: const Text(
          '  Notifications',
          style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
        )));
    items.add(SalomonBottomBarItem(
        icon: Icon(_currentIndex == 3
            ? Icons.settings_outlined
            : Icons.settings_outlined,
          color:primary,),
        title: const Text(
          '  Notifications',
          style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
        )));

    return items;
  }

}
