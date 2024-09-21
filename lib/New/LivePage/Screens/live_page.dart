import 'dart:async';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radia/Core/CommenWidgets/custom_image_view.dart';
import 'package:radia/Models/commodities_model.dart';
import 'package:radia/Models/spread_document_model.dart';
import 'package:radia/New/LivePage/Controller/live_controller.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:radia/Core/CommenWidgets/space.dart';
import 'dart:math' as Math;
import '../../../Core/app_export.dart';
import '../../NewsScreen/Controller/news_controller.dart';
import '../Repository/live_repository.dart';
import 'live_rate_widget.dart';

final rateBidValue = StateProvider(
  (ref) {
    return 0.0;
  },
);

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

  final bannerBool = StateProvider.autoDispose(
    (ref) => false,
  );
  final goldAskPrice = StateProvider.autoDispose<double>(
    (ref) => 0,
  );
  final silverAskPrice = StateProvider.autoDispose<double>(
    (ref) => 0,
  );
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
  }

  double getUnitMultiplier(String weight) {
    switch (weight) {
      case "GM":
        return 1;
      case "KG":
        return 1000;
      case "TTB":
        return 116.6400;
      case "TOLA":
        return 11.664;
      case "OZ":
        return 31.1034768;
      default:
        return 1;
    }
  }

  double calculateSellAED(double goldValueAsk, double sellPremium,
      double weight, double unitMultiplier, String purity) {
    return ((goldValueAsk / 31.103) *
                3.674 *
                weight *
                unitMultiplier *
                (double.parse(purity) / (10 * purity.length)) +
            sellPremium)
        .toDouble();
  }

  double calculateBuyAED(
      double goldValueBuy,
      double buyPremium,
      // double bidSpreadValue,
      double weight,
      double unitMultiplier,
      String purity) {
    return ((goldValueBuy / 31.103) *
                3.674 *
                weight *
                unitMultiplier *
                (double.parse(purity) / (10 * purity.length)) +
            buyPremium)
        .toDouble();
  }

  String getMarketStatus() {
    DateTime now = DateTime.now();
    int currentDay = now.weekday;

    DateTime nextOpeningTime;
    if (currentDay >= DateTime.monday && currentDay <= DateTime.friday) {
      if (now.hour == 0 && now.minute == 0) {
        return 'Market is open.';
      } else {
        // Next opening time is tomorrow at midnight
        nextOpeningTime =
            DateTime(now.year, now.month, now.day).add(Duration(days: 1));
      }
    } else {
      // It's weekend, next opening is on Monday
      int daysUntilMonday = (DateTime.monday - currentDay + 7) % 7;
      nextOpeningTime = DateTime(now.year, now.month, now.day)
          .add(Duration(days: daysUntilMonday));
    }

    Duration timeUntilOpen = nextOpeningTime.difference(now);
    int days = timeUntilOpen.inDays;
    int hours = timeUntilOpen.inHours % 24;
    int minutes = timeUntilOpen.inMinutes % 60;

    List<String> parts = [];
    if (days > 0) parts.add('$days d${days > 1 ? 's' : ''}');
    if (hours > 0) parts.add('$hours h${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes m${minutes > 1 ? 's' : ''}');

    String countdownText = parts.join(', ');

    return 'Market is closed. It will open in $countdownText.';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0.v, right: 8.0.v),
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
                      Text(
                          DateFormat("EEEE")
                              .format(DateTime.now())
                              .toUpperCase(),
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
                            refTime.watch(uaeTimeProvider).toUpperCase(),
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
                            refTime.watch(bdTimeProvider).toUpperCase(),
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
                            refTime.watch(usTimeProvider).toUpperCase(),
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
              Consumer(
                builder: (context, ref1, child) {
                  return ref1.watch(spotRateProvider).when(
                    data: (spotRate) {
                      if (spotRate != null) {
                        final liveRateData = ref1.watch(liveRateProvider);
                        if (liveRateData != null) {
                          final spreadNow = spotRate.info;
                          WidgetsBinding.instance.addPostFrameCallback(
                            (timeStamp) {
                              ref1.read(bannerBool.notifier).update(
                                (state) {
                                  return liveRateData.gold!.marketStatus !=
                                          "TRADEABLE"
                                      ? true
                                      : false;
                                },
                              );
                              ref1.read(rateBidValue.notifier).update(
                                (state) {
                                  return liveRateData.gold!.bid +
                                      (spreadNow.goldBidSpread);
                                },
                              );
                              ref1.read(goldAskPrice.notifier).update(
                                (state) {
                                  final res = (liveRateData.gold!.bid +
                                      (spreadNow.goldAskSpread));
                                  return res;
                                },
                              );
                              ref1.read(silverAskPrice.notifier).update(
                                (state) {
                                  final res = (liveRateData.gold!.bid +
                                      (spreadNow.goldAskSpread) +
                                      (spreadNow.goldBidSpread) +
                                      0.5);
                                  return res;
                                },
                              );
                            },
                          );
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: SizeUtils.width * 0.45,
                                height: SizeUtils.height * 0.15,
                                decoration: BoxDecoration(
                                    color: appTheme.whiteA700,
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        topLeft: Radius.circular(20)),
                                    border: Border.all(
                                        color: Colors.orangeAccent, width: 2)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "GOLD BID(SELL)",
                                      style: CustomPoppinsTextStyles.bodyText4,
                                    ),
                                    space(h: 7.v),

                                    ///sell
                                    ValueDisplayWidget(
                                        value: (liveRateData.gold!.bid +
                                            (spreadNow.goldAskSpread))),
                                    space(h: 7.v),
                                    RichText(
                                        softWrap:
                                            true, // Wraps text within the available width
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(children: [
                                          TextSpan(
                                              style: CustomPoppinsTextStyles
                                                  .bodyTextRed,
                                              text: "LOW "),
                                          TextSpan(
                                            style: CustomPoppinsTextStyles
                                                .bodyTextSemiBoldWhite,
                                            text:
                                                "${liveRateData.gold!.low + (spreadNow.goldLowMargin)}",
                                          )
                                        ])),
                                  ],
                                ),
                              ),
                              Container(
                                width: SizeUtils.width * 0.45,
                                height: SizeUtils.height * 0.15,
                                decoration: BoxDecoration(
                                    color: appTheme.mainWhite,
                                    borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    border: const Border(
                                        bottom: BorderSide(
                                            color: Colors.orangeAccent,
                                            width: 2),
                                        right: BorderSide(
                                            color: Colors.orangeAccent,
                                            width: 2),
                                        top: BorderSide(
                                            color: Colors.orangeAccent,
                                            width: 2))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "GOLD ASK(BUY)",
                                      style: CustomPoppinsTextStyles.bodyText4,
                                    ),
                                    space(h: 7.v),
                                    ValueDisplayWidget2(
                                      value: liveRateData.gold!.bid +
                                          spreadNow.goldBidSpread +
                                          spreadNow.goldAskSpread +
                                          0.5,
                                    ),
                                    space(h: 7.v),
                                    RichText(
                                        softWrap:
                                            true, // Wraps text within the available width
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(children: [
                                          TextSpan(
                                              style: CustomPoppinsTextStyles
                                                  .bodyTextGreen,
                                              text: "HIGH "),
                                          TextSpan(
                                              style: CustomPoppinsTextStyles
                                                  .bodyTextSemiBoldWhite,
                                              text: liveRateData.gold != null
                                                  ? " ${liveRateData.gold?.high}"
                                                  : "0.0"),
                                        ])),
                                  ],
                                ),
                              )
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: SizeUtils.width * 0.45,
                                height: SizeUtils.height * 0.15,
                                decoration: BoxDecoration(
                                    color: appTheme.whiteA700,
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        topLeft: Radius.circular(20)),
                                    border: Border.all(
                                        color: Colors.orangeAccent, width: 2)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "GOLD BID(SELL)",
                                      style: CustomPoppinsTextStyles.bodyText4,
                                    ),
                                    space(h: 7.v),

                                    ///sell
                                    const ValueDisplayWidget(value: 0),
                                    space(h: 7.v),

                                    RichText(
                                        softWrap:
                                            true, // Wraps text within the available width
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(children: [
                                          TextSpan(
                                              style: CustomPoppinsTextStyles
                                                  .bodyTextRed,
                                              text: "LOW "),
                                          TextSpan(
                                            style: CustomPoppinsTextStyles
                                                .bodyTextSemiBoldWhite,
                                            text: "0.0",
                                          )
                                        ])),
                                  ],
                                ),
                              ),
                              Container(
                                width: SizeUtils.width * 0.45,
                                height: SizeUtils.height * 0.15,
                                decoration: BoxDecoration(
                                    color: appTheme.mainWhite,
                                    borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    border: const Border(
                                        bottom: BorderSide(
                                            color: Colors.orangeAccent,
                                            width: 2),
                                        right: BorderSide(
                                            color: Colors.orangeAccent,
                                            width: 2),
                                        top: BorderSide(
                                            color: Colors.orangeAccent,
                                            width: 2))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "GOLD ASK(BUY)",
                                      style: CustomPoppinsTextStyles.bodyText4,
                                    ),
                                    space(h: 7.v),
                                    ValueDisplayWidget2(
                                      value: 0,
                                    ),
                                    space(h: 7.v),
                                    RichText(
                                        softWrap:
                                            true, // Wraps text within the available width
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(children: [
                                          TextSpan(
                                              style: CustomPoppinsTextStyles
                                                  .bodyTextGreen,
                                              text: "HIGH "),
                                          TextSpan(
                                              style: CustomPoppinsTextStyles
                                                  .bodyTextSemiBoldWhite,
                                              text: "0.0"),
                                        ])),
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: SizeUtils.width * 0.45,
                              height: SizeUtils.height * 0.15,
                              decoration: BoxDecoration(
                                  color: appTheme.whiteA700,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(20)),
                                  border: Border.all(
                                      color: Colors.orangeAccent, width: 2)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "GOLD BID(SELL)",
                                    style: CustomPoppinsTextStyles.bodyText4,
                                  ),
                                  space(h: 7.v),

                                  ///sell
                                  const ValueDisplayWidget(value: 0),
                                  space(h: 7.v),
                                  RichText(
                                      softWrap:
                                          true, // Wraps text within the available width
                                      overflow: TextOverflow.visible,
                                      text: TextSpan(children: [
                                        TextSpan(
                                            style: CustomPoppinsTextStyles
                                                .bodyTextRed,
                                            text: "LOW "),
                                        TextSpan(
                                          style: CustomPoppinsTextStyles
                                              .bodyTextSemiBoldWhite,
                                          text: "0.0",
                                        )
                                      ])),
                                ],
                              ),
                            ),
                            Container(
                              width: SizeUtils.width * 0.45,
                              height: SizeUtils.height * 0.15,
                              decoration: BoxDecoration(
                                  color: appTheme.mainWhite,
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  border: const Border(
                                      bottom: BorderSide(
                                          color: Colors.orangeAccent, width: 2),
                                      right: BorderSide(
                                          color: Colors.orangeAccent, width: 2),
                                      top: BorderSide(
                                          color: Colors.orangeAccent,
                                          width: 2))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "GOLD ASK(BUY)",
                                    style: CustomPoppinsTextStyles.bodyText4,
                                  ),
                                  space(h: 7.v),
                                  ValueDisplayWidget2(
                                    value: 0,
                                  ),
                                  space(h: 7.v),
                                  RichText(
                                      softWrap:
                                          true, // Wraps text within the available width
                                      overflow: TextOverflow.visible,
                                      text: TextSpan(children: [
                                        TextSpan(
                                            style: CustomPoppinsTextStyles
                                                .bodyTextGreen,
                                            text: "HIGH "),
                                        TextSpan(
                                            style: CustomPoppinsTextStyles
                                                .bodyTextSemiBoldWhite,
                                            text: "0.0"),
                                      ])),
                                ],
                              ),
                            )
                          ],
                        );
                      }
                    },
                    error: (error, stackTrace) {
                      print("###ERROR###");
                      print(error.toString());
                      print(stackTrace);
                      return const Center(
                        child: Text("Something Went Wrong"),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
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
              Consumer(
                builder: (context, ref2, child) {
                  print("Consumer is rebulding");

                  return ref2.watch(spotRateProvider).when(
                    data: (data) {
                      if (data != null) {
                        final commodity = data.info.commodities;
                        return Expanded(
                            flex: 0,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: commodity.length,
                              itemBuilder: (context, index) {
                                final commodities = commodity[index];
                                // final commodities = updateValuesPeriodically(
                                //     data[index], ref2.watch(goldAskPrice), 0);
                                if (commodities.weight == "GM") {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: 8.0.v, bottom: 8.0.v),
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
                                          SizedBox(
                                            width: 120.h,
                                            child: Center(
                                              child: RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                    text: commodities.metal
                                                        .toUpperCase(),
                                                    style:
                                                        CustomPoppinsTextStyles
                                                            .bodyText1),
                                                TextSpan(
                                                    text: commodities.purity
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                        // fontFamily: marine,
                                                        color:
                                                            appTheme.black900,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15.fSize))
                                              ])),
                                            ),
                                          ),

                                          SizedBox(
                                            width: 125.h,
                                            child: Center(
                                              child: Text(
                                                commodities.unit.toString() +
                                                    commodities.weight,
                                                style: CustomPoppinsTextStyles
                                                    .bodyText1,
                                              ),
                                            ),
                                          ),

                                          // VerticalDivider(
                                          //   color: appTheme.gray700,
                                          // ),
                                          Consumer(
                                            builder: (context, refSell, child) {
                                              final askNow =
                                                  (refSell.watch(goldAskPrice) /
                                                          31.103) *
                                                      3.674;
                                              final rateNow = askNow *
                                                  double.parse(commodities.unit
                                                      .toString()) *
                                                  getUnitMultiplier(
                                                      commodities.weight) *
                                                  (double.parse(commodities
                                                          .purity
                                                          .toString()) /
                                                      Math.pow(
                                                          10,
                                                          commodities.purity
                                                              .toString()
                                                              .length));
                                              return SizedBox(
                                                width: 120.h,
                                                child: Center(
                                                  child: Text(
                                                    rateNow.toStringAsFixed(2),
                                                    style:
                                                        CustomPoppinsTextStyles
                                                            .bodyText1,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (commodities.weight == "TTB") {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 8.0.v, top: 8.0.v),
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
                                          SizedBox(
                                            width: 120.h,
                                            child: Center(
                                              child: RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                    text: "TEN TOLA",
                                                    style:
                                                        CustomPoppinsTextStyles
                                                            .bodyText1),
                                              ])),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 125.h,
                                            child: Center(
                                              child: Text(
                                                commodities.unit.toString() +
                                                    commodities.weight,
                                                style: CustomPoppinsTextStyles
                                                    .bodyText1,
                                              ),
                                            ),
                                          ),
                                          Consumer(
                                            builder: (context, refSell, child) {
                                              final askNow =
                                                  (refSell.watch(goldAskPrice) /
                                                          31.103) *
                                                      3.674;
                                              final rateNow = askNow *
                                                  double.parse(commodities.unit
                                                      .toString()) *
                                                  getUnitMultiplier(
                                                      commodities.weight) *
                                                  (double.parse(commodities
                                                          .purity
                                                          .toString()) /
                                                      Math.pow(
                                                          10,
                                                          commodities.purity
                                                              .toString()
                                                              .length));
                                              return SizedBox(
                                                width: 120.h,
                                                child: Center(
                                                  child: Text(
                                                    rateNow.toStringAsFixed(0),
                                                    style:
                                                        CustomPoppinsTextStyles
                                                            .bodyText1,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 8.0.v, top: 8.0.v),
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
                                          SizedBox(
                                            width: 120.h,
                                            child: Center(
                                              child: RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                    text: "KILOBAR",
                                                    style:
                                                        CustomPoppinsTextStyles
                                                            .bodyText1),
                                              ])),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 125.h,
                                            child: Center(
                                              child: Text(
                                                commodities.unit.toString() +
                                                    commodities.weight,
                                                style: CustomPoppinsTextStyles
                                                    .bodyText1,
                                              ),
                                            ),
                                          ),
                                          Consumer(
                                            builder: (context, refSell, child) {
                                              final askNow =
                                                  (refSell.watch(goldAskPrice) /
                                                          31.103) *
                                                      3.674;
                                              final rateNow = askNow *
                                                  double.parse(commodities.unit
                                                      .toString()) *
                                                  getUnitMultiplier(
                                                      commodities.weight) *
                                                  (double.parse(commodities
                                                          .purity
                                                          .toString()) /
                                                      Math.pow(
                                                          10,
                                                          commodities.purity
                                                              .toString()
                                                              .length));
                                              return SizedBox(
                                                width: 120.h,
                                                child: Center(
                                                  child: Text(
                                                    rateNow.toStringAsFixed(0),
                                                    style:
                                                        CustomPoppinsTextStyles
                                                            .bodyText1,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ));
                      } else {
                        return SizedBox();
                      }
                    },
                    error: (error, stackTrace) {
                      if (kDebugMode) {
                        print(error.toString());
                        print(stackTrace);
                      }
                      return Center(
                        child: Text("Something Went Worng"),
                      );
                    },
                    loading: () {
                      return SizedBox();
                    },
                  );
                },
              ),
              Consumer(
                builder: (context, ref1, child) {
                  return ref1.watch(newsProvider).when(
                        data: (data123) {
                          if (data123 != null && data123.news.news.isNotEmpty) {
                            print("here is the News");
                            print(data123.toMap());
                            return AutoScrollText(
                              delayBefore: const Duration(seconds: 3),
                              "${data123.news.news[0].description}                             ",
                              style: CustomPoppinsTextStyles.bodyText,
                            );
                          } else {
                            return Text(
                              "NO News",
                              style: CustomPoppinsTextStyles.bodyText,
                            );
                          }
                        },
                        error: (error, stackTrace) {
                          print(stackTrace);
                          print(error.toString());
                          return SizedBox();
                        },
                        loading: () => SizedBox(),
                      );
                },
              ),
            ],
          ),
        ),
        Positioned(
          top: 15.v,
          right: 50.h,
          child: Transform.rotate(
            angle: -Math.pi / 4,
            child: Consumer(
              builder: (context, refBanner, child) {
                return Visibility(
                  visible: refBanner.watch(bannerBool),
                  child: Container(
                    width: SizeUtils.width,
                    height: 30.h,
                    color: Colors.red,
                    child: Center(
                      child: AutoScrollText(
                        delayBefore: const Duration(seconds: 3),
                        getMarketStatus(),
                        style: CustomPoppinsTextStyles.buttonText,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
