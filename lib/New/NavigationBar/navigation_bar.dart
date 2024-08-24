import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:radia/Core/custom_app_bar.dart';
import 'package:radia/New/ProfilePage/Screems/profile_page.dart';
import 'package:radia/New/RatePage/Screens/rate_page.dart';

import '../../Core/CommenWidgets/custom_image_view.dart';
import '../../Core/CommenWidgets/noNetworkScreen.dart';
import '../../Core/app_export.dart';
import '../LivePage/Screens/live_page.dart';
import '../ProfilePage/Screems/2_profile_screen.dart';

class NavigationBarScreen extends ConsumerStatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  ConsumerState createState() => _NavigationBarState();
}

class _NavigationBarState extends ConsumerState<NavigationBarScreen> {
  List<Widget> pages = [
    LivePage(),
    RatePage(),
    // RatePage(),
    ProfileScreen2(),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.black900,
        body: Container(
          padding: EdgeInsets.all(10.h),
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImageConstants.logoBg), fit: BoxFit.cover)),
          child: Consumer(
            builder: (context, refNet, child) {
              return refNet.watch(isConnectedToInternet)
                  ? pages[refNet.watch(_selectedIndex)]
                  : const NoNetworkScreen();
            },
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       activeIcon: CircleAvatar(
        //         backgroundColor: appTheme.red700,
        //         child: CustomImageView(
        //           color: appTheme.whiteA700,
        //           width: 30.adaptSize,
        //           imagePath: ImageConstants.homeIcon,
        //         ),
        //       ),
        //       icon: CustomImageView(
        //         width: 30.adaptSize,
        //         imagePath: ImageConstants.homeIcon,
        //       ),
        //       label: '',
        //     ),
        //     BottomNavigationBarItem(
        //       activeIcon: CircleAvatar(
        //         backgroundColor: appTheme.red700,
        //         child: CustomImageView(
        //           color: appTheme.whiteA700,
        //           width: 30.adaptSize,
        //           imagePath: ImageConstants.bookingIcon,
        //         ),
        //       ),
        //       icon: CustomImageView(
        //         width: 30.adaptSize,
        //         imagePath: ImageConstants.bookingIcon,
        //       ),
        //       label: '',
        //     ),
        //     BottomNavigationBarItem(
        //       activeIcon: CircleAvatar(
        //         backgroundColor: appTheme.red700,
        //         child: CustomImageView(
        //           color: appTheme.whiteA700,
        //           width: 30.adaptSize,
        //           imagePath: ImageConstants.userLogo,
        //         ),
        //       ),
        //       icon: CustomImageView(
        //         width: 30.adaptSize,
        //         imagePath: ImageConstants.userLogo,
        //       ),
        //       label: '',
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: Colors.blue,
        //   onTap: _onItemTapped,
        // ),
        // appBar: CustomAppBar(),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImageConstants.logoBg), fit: BoxFit.cover)),
          child: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: 0,
            items: <Widget>[
              CustomImageView(
                color: appTheme.whiteA700,
                width: 30.adaptSize,
                imagePath: ImageConstants.chartLogo,
              ),
              CustomImageView(
                color: appTheme.whiteA700,
                width: 30.adaptSize,
                imagePath: ImageConstants.notificationLogo,
              ),
              CustomImageView(
                color: appTheme.whiteA700,
                width: 30.adaptSize,
                imagePath: ImageConstants.userLogo,
              ),
            ],
            color: appTheme.gray800,
            buttonBackgroundColor: appTheme.gray800,
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 500),
            onTap: (index) {
              if (index == 2) {
                _onItemTapped(index);
                // showModalBottomSheet(
                //   backgroundColor: appTheme.whiteA700,
                //   context: context,
                //   builder: (BuildContext context) {
                //     return showBottomSheetScreen(context: context);
                //   },
                // );
              } else {
                _onItemTapped(index);
              }
            },
            letIndexChange: (index) => true,
          ),
        ),
      ),
    );
  }
}
