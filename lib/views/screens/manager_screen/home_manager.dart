import 'package:busmate/views/screens/manager_screen/main_screen_manager.dart';
import 'package:flutter/material.dart';
import 'package:busmate/views/screens/register_screen.dart';

import '../../../models/user_model.dart';
import '../info_account.dart';
import '../parent_screen/main_screen_parent.dart';
import '../parent_screen/view_map_of_parent.dart';

class HomeManager extends StatefulWidget {
  final User? user;
  const HomeManager({super.key, this.user});

  @override
  State<HomeManager> createState() => _HomeManagerState();
}

class _HomeManagerState extends State<HomeManager> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      MainScreenManager(),
      ViewMapOfParent(
        user: widget.user!,
      ),
      InfoAccount(
        user: widget.user,
      ),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Color(0xFF58952D),

        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Tracking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedFontSize: 16,
        unselectedFontSize: 12,
        selectedItemColor: Color(0xFFECAB33),
        onTap: _onItemTapped,
      ),
    );
  }
}
