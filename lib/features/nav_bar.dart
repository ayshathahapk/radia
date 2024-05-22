import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Screens/live_alert.dart';
import 'Screens/profile.dart';
import 'Screens/ratealert.dart';

class Navpage extends StatefulWidget {
  const Navpage({Key? key});

  @override
  State<Navpage> createState() => _NavpageState();
}

int _currentIndex = 0;

List<Widget> _pages = [
  Liverate(),
  Ratealert(),
  Profile(),
];

class _NavpageState extends State<Navpage> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
          primaryColor: Colors.red,
          textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.yellow),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          showSelectedLabels: true,
          selectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(
            color: Colors.orangeAccent,
          ),
          unselectedItemColor: Colors.green,
          showUnselectedLabels: false,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard, color: Color(0xFFBFA13A)),
              label: 'Live rate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_rounded, color: Color(0xFFBFA13A)),
              label: 'Rate alert',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Color(0xFFBFA13A)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

