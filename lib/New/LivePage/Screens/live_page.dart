import 'dart:async';
import 'package:country_flags/country_flags.dart';
import 'package:radia/Core/CommenWidgets/custom_image_view.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:radia/Core/CommenWidgets/space.dart';

import '../../../Core/app_export.dart';

class LivePage extends ConsumerStatefulWidget {
  const LivePage({super.key});

  @override
  ConsumerState createState() => _LivePageState();
}

class _LivePageState extends ConsumerState<LivePage> {
  late Timer _timer;
  String formattedTime = DateFormat('h:mm:ss a').format(DateTime.now());
  final formattedTimeProvider = StateProvider(
    (ref) => DateFormat('h:mm a').format(DateTime.now()),
  );
  final bdTimeProvider = StateProvider(
    (ref) => "",
  );
  final uaeTimeProvider = StateProvider(
    (ref) => "",
  );
  final usTimeProvider = StateProvider(
    (ref) => "",
  );
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _updateTime(timer);
        convertTimes(timer);
      },
    );
  }

  void _updateTime(Timer timer) {
    ref.read(formattedTimeProvider.notifier).update(
          (state) => DateFormat('h:mm a').format(DateTime.now()),
        );

    // setState(() {
    //   formattedTime = DateFormat('h:mm:ss a').format(DateTime.now());
    // });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  DateTime convertToTimeZone(DateTime dateTime, String timeZone) {
    final location = tz.getLocation(timeZone);
    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(dateTime, location);
    return tzDateTime;
  }

  String ukTimeString = "";
  String bdTimeString = "";
  String inTimeString = "";
  String uaeTimeString = "";
  void convertTimes(Timer timer) {
    // Example timezones
    const String ukTimeZone = 'America/New_York';
    const String bdTimeZone = 'Asia/Dhaka';
    const String currentTimeZone = 'Asia/Kolkata';
    const String uaeTimeZone = 'Asia/Dubai';

    // Current time in your local timezone
    DateTime now = DateTime.now();

    // Convert to UK and Bangladesh time
    DateTime ukTime = convertToTimeZone(now, ukTimeZone);
    DateTime bdTime = convertToTimeZone(now, bdTimeZone);
    DateTime localTime = convertToTimeZone(now, currentTimeZone);
    DateTime uaeTime = convertToTimeZone(now, uaeTimeZone);
    // Format the time as needed
    ukTimeString = DateFormat('h:mm:ss a\nEEEE').format(ukTime);
    bdTimeString = DateFormat('h:mm:ss a\nEEEE').format(bdTime);
    inTimeString = DateFormat('h:mm:ss a\nEEEE').format(localTime);
    uaeTimeString = DateFormat('h:mm:ss a\nEEEE').format(uaeTime);
    ref.read(bdTimeProvider.notifier).update(
          (state) => bdTimeString,
        );
    ref.read(usTimeProvider.notifier).update(
          (state) => ukTimeString,
        );
    ref.read(uaeTimeProvider.notifier).update(
          (state) => uaeTimeString,
        );
    // print('UK Time: $ukTimeString');
    // print('Bangladesh Time: $bdTimeString');
    // print('Ind Time: $inTimeString');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    color: appTheme.whiteA700,
                  ),
                  Text(
                    DateFormat("MMM dd yyyy").format(DateTime.now()),
                    style: CustomPoppinsTextStyles.bodyText,
                  ),
                  Text(DateFormat("EEEE").format(DateTime.now()),
                      style: CustomPoppinsTextStyles.bodyText)
                ],
              ),
              CustomImageView(
                imagePath: ImageConstants.logo,
                width: 90.h,
              ),
              Column(
                children: [
                  Icon(
                    CupertinoIcons.time,
                    color: appTheme.whiteA700,
                  ),
                  Consumer(
                    builder: (context, ref, child) => Text(
                      ref.watch(formattedTimeProvider),
                      style: CustomPoppinsTextStyles.bodyText,
                    ),
                  )
                ],
              )
            ],
          ),
          CustomImageView(
            imagePath: ImageConstants.logoText,
          ),
          space(),
          Consumer(
            builder: (context, refTime, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CountryFlag.fromCountryCode(
                        shape: RoundedRectangle(20.h),
                        "AE",
                        width: 35.h,
                        height: 35.v,
                      ),
                      Text(
                        refTime.watch(uaeTimeProvider),
                        style: CustomPoppinsTextStyles.bodyText,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CountryFlag.fromCountryCode(
                        shape: RoundedRectangle(20.h),
                        "BD",
                        width: 35.h,
                        height: 35.v,
                      ),
                      Text(
                        refTime.watch(bdTimeProvider),
                        style: CustomPoppinsTextStyles.bodyText,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CountryFlag.fromCountryCode(
                        shape: RoundedRectangle(20.h),
                        "US",
                        width: 35.h,
                        height: 35.v,
                      ),
                      Text(
                        refTime.watch(usTimeProvider),
                        style: CustomPoppinsTextStyles.bodyText,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ],
              );
            },
          ),

          space(),

          ///First Table Live Rate of GOLD and SILVER.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: SizeUtils.width * 0.47,
                height: SizeUtils.height * 0.2,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    border: Border.all(color: Colors.orangeAccent)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "GOLD BID(SELL)",
                      style: CustomPoppinsTextStyles.bodyText1White,
                    ),
                    Container(
                      height: 50.v,
                      width: 120.v,
                      decoration: BoxDecoration(
                          color: appTheme.mainWhite,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: appTheme.gray500)),
                      child: Center(
                        child: Text(
                          "2509.01",
                          style: CustomPoppinsTextStyles.bodyText2,
                        ),
                      ),
                    ),
                    RichText(
                        softWrap: true, // Wraps text within the available width
                        overflow: TextOverflow.visible,
                        text: TextSpan(children: [
                          TextSpan(
                              style: CustomPoppinsTextStyles.bodyTextRed,
                              text: "LOW "),
                          TextSpan(
                              style: CustomPoppinsTextStyles.bodyTextSemiBold,
                              text: " 2507.41"),
                        ])),
                  ],
                ),
              ),
              Container(
                width: SizeUtils.width * 0.47,
                height: SizeUtils.height * 0.2,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    border: Border(
                        bottom: BorderSide(color: Colors.orangeAccent),
                        right: BorderSide(color: Colors.orangeAccent),
                        top: BorderSide(color: Colors.orangeAccent))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "GOLD ASK(BUY)",
                      style: CustomPoppinsTextStyles.bodyText1White,
                    ),
                    Container(
                      height: 50.v,
                      width: 120.v,
                      decoration: BoxDecoration(
                          color: appTheme.mainWhite,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: appTheme.gray500)),
                      child: Center(
                        child: Text(
                          "2509.01",
                          style: CustomPoppinsTextStyles.bodyText2,
                        ),
                      ),
                    ),
                    RichText(
                        softWrap: true, // Wraps text within the available width
                        overflow: TextOverflow.visible,
                        text: TextSpan(children: [
                          TextSpan(
                              style: CustomPoppinsTextStyles.bodyTextGreen,
                              text: "HIGH "),
                          TextSpan(
                              style: CustomPoppinsTextStyles.bodyTextSemiBold,
                              text: " 2507.41"),
                        ])),
                  ],
                ),
              )
            ],
          ),
          space(),
          Container(
            width: SizeUtils.width,
            height: SizeUtils.height * 0.05,
            decoration: BoxDecoration(
              // border: Border.all(),
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Spacer(),
                Text(
                  "COMMODITY",
                  style: CustomPoppinsTextStyles.bodyText1,
                ),
                Spacer(),
                Text(
                  "WEIGHT",
                  style: CustomPoppinsTextStyles.bodyText1,
                ),
                Spacer(),
                // VerticalDivider(
                //   color: appTheme.gray700,
                // ),
                Text(
                  "PRICE(AED)",
                  style: CustomPoppinsTextStyles.bodyText1,
                ),
                Spacer(),
              ],
            ),
          ),
          Expanded(
              flex: 0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0.v),
                    child: Container(
                      width: SizeUtils.width,
                      height: SizeUtils.height * 0.05,
                      decoration: BoxDecoration(
                        // border: Border.all(),
                        color: appTheme.whiteA700,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Spacer(),
                          Text(
                            "Gold999",
                            style: CustomPoppinsTextStyles.bodyText1,
                          ),
                          Spacer(),
                          Text(
                            "1 GM",
                            style: CustomPoppinsTextStyles.bodyText1,
                          ),
                          Spacer(),
                          // VerticalDivider(
                          //   color: appTheme.gray700,
                          // ),
                          Text(
                            "296.19",
                            style: CustomPoppinsTextStyles.bodyText1,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  );
                },
              )),
          AutoScrollText(
            delayBefore: Duration(seconds: 3),
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
            style: CustomPoppinsTextStyles.bodyText,
          ),
          // Center(
          //   child: Container(
          //     height: 50,
          //     child: Marquee(
          //       text:
          //           'This text will move from right to left continuously.',
          //       style: TextStyle(fontSize: 24),
          //       scrollAxis: Axis.horizontal,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       blankSpace: 20.0,
          //       velocity: 100.0,
          //       pauseAfterRound: Duration(seconds: 1),
          //       startPadding: 10.0,
          //       accelerationDuration: Duration(seconds: 1),
          //       accelerationCurve: Curves.linear,
          //       decelerationDuration: Duration(milliseconds: 500),
          //       decelerationCurve: Curves.easeOut,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
