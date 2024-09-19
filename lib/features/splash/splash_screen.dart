import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:radia/Core/Utils/image_constant.dart';
import 'package:radia/main.dart';
import '../../New/LivePage/Repository/live_repository.dart';
import '../../New/NavigationBar/navigation_bar.dart';
import '../nav_bar.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {
  @override
  void initState() {
    super.initState();
    internetChecking();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 4), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationBarScreen()),
        );
      });
    });
  }

  StreamSubscription? _internetConnectionStreamSubscription;
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
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(liveRateProvider.notifier).refreshData();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: height * 0.3,
          width: width * 0.3,
          child: Image.asset(
            ImageConstants.logo,
          ),
        ),
      ),
    );
  }
}
