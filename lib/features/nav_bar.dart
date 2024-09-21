import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'Screens/bottomsheetpage_radia.dart';
import 'Screens/live_alert.dart';
import 'Screens/profile.dart';
import 'Screens/ratealert.dart';

class Navpage extends ConsumerStatefulWidget {
  const Navpage({Key? key});

  @override
  ConsumerState<Navpage> createState() => _NavpageState();
}

int _currentIndex = 0;



class _NavpageState extends ConsumerState<Navpage> {

  List<Widget> _pages = [
    Liverate(),
    Ratealert(),
    Profile(),
  ];

  final isConnectedToInternet = StateProvider<bool>((ref) => false);
  final _selectedIndex = StateProvider(
        (ref) => 0,
  );
  StreamSubscription? _internetConnectionStreamSubscription;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  void _onItemTapped(int index) {
    ref.read(_selectedIndex.notifier).update(
          (state) => index,
    );
  }

  void internetChecking() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _internetConnectionStreamSubscription =
          InternetConnection().onStatusChange.listen((event) {
            switch (event) {
              case InternetStatus.connected:
                ref.read(isConnectedToInternet.notifier).update((state) => true);
                break;
              case InternetStatus.disconnected:
                ref.read(isConnectedToInternet.notifier).update((state) => false);
                break;
              default:
                ref.read(isConnectedToInternet.notifier).update((state) => true);
                break;
            }
          });
    });
  }

  @override
  void initState() {
    internetChecking();
    super.initState();
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
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
            bodySmall: TextStyle(color: Colors.yellow),
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
              icon: Icon(Icons.notifications_none_rounded,
                  color: Color(0xFFBFA13A)),
              label: 'Rate alert',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return ShowRadiaextrapage();
                      },
                    );
                  },
                  child: Icon(Icons.more, color: Color(0xFFBFA13A))),
              label: 'More',
            ),

          ],
        ),
      ),
    );
  }
}

