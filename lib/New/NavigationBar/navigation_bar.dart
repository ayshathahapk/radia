import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:radia/Core/Utils/firebase_constants.dart';
import 'package:radia/Core/custom_app_bar.dart';
import 'package:radia/New/ProfilePage/Screems/profile_page.dart';
import 'package:radia/New/RatePage/Screens/rate_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Core/CommenWidgets/custom_image_view.dart';
import '../../Core/CommenWidgets/noNetworkScreen.dart';
import '../../Core/Utils/notification service.dart';
import '../../Core/app_export.dart';
import '../LivePage/Screens/live_page.dart';
import '../ProfilePage/Screems/2_profile_screen.dart';

final diviceID = StateProvider(
  (ref) => "",
);
final fcmToken = StateProvider(
  (ref) => "",
);
final isConnectedToInternet = StateProvider<bool>((ref) => false);

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
    // ProfileScreen2(),
  ];
  // final isConnectedToInternet = StateProvider<bool>((ref) => false);
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

  bool isValueMatching(double alertValue) {
    print("Bid value${ref.watch(rateBidValue).roundToDouble()}");
    print("alertvalue$alertValue");
    // Implement your logic to compare the alert value with your app's value
    // For example:
    // return myAppValue == alertValue;
    if (alertValue == (ref.watch(rateBidValue)).roundToDouble()) {
      return true;
    } else {
      return false;
    }
    // Placeholder
  }

  void listenToFirebase() {
    Timer.periodic(
      Duration(seconds: 10),
      (timer) {
        FirebaseFirestore.instance
            .collection(FirebaseConstants.user)
            .doc(FirebaseConstants.userDoc)
            .collection(FirebaseConstants.alert)
            .where("uniqueId", isEqualTo: ref.watch(diviceID))
            .snapshots()
            .listen((snapshot) {
          for (var doc in snapshot.docs) {
            double alertValue = doc['alertValue'].toDouble();
            // Compare with your app's value here
            if (isValueMatching(alertValue)) {
              NotificationService.showInstantNotification(
                  "Alert", "$alertValue", "channelId");
            }
          }
        });
      },
    );
  }

  final NotificationService _notificationService = NotificationService();
  @override
  void initState() {
    internetChecking();
    listenToFirebase();
    _notificationService.initNotifications();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _getDeviceId();
        // posttokentoserver();
      },
    );
  }

  posttokentoserver() async {
    await FirebaseMessaging.instance.getToken().then(
      (token) async {
        if (kDebugMode) {
          print("FCM TOKEN ########${token!}");
        }
        ref.read(fcmToken.notifier).update(
              (state) => token!,
            );
      },
    );
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) {
        ref.read(fcmToken.notifier).update(
              (state) => token,
            );
      },
    );
  }

  void _launchWhatsApp() async {
    final Uri url = Uri.parse(
        'https://wa.me/+971542471894'); // Replace with your WhatsApp link
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Future<void> _getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        ref.read(diviceID.notifier).update(
              (state) => androidInfo.id ?? 'Unknown',
            );
        // _deviceId = androidInfo.id ?? 'Unknown';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        ref.read(diviceID.notifier).update(
              (state) => iosInfo.identifierForVendor ?? 'Unknown',
            );
        // _deviceId = iosInfo.identifierForVendor ?? 'Unknown';
      }
    } catch (e) {
      print('Failed to get device ID: $e');
    }
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
              CustomImageView(
                color: appTheme.whiteA700,
                width: 30.adaptSize,
                imagePath: ImageConstants.whatsapp,
              ),
            ],
            color: appTheme.gray800,
            buttonBackgroundColor: appTheme.gray800,
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 500),
            onTap: (index) {
              if (index == 2) {
                // _onItemTapped(index);
                showModalBottomSheet(
                  backgroundColor: appTheme.whiteA700,
                  context: context,
                  builder: (BuildContext context) {
                    return showBottomSheetScreen(context: context);
                  },
                );
              } else if (index == 3) {
                _launchWhatsApp();
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
