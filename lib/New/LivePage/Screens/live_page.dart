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
import '../Repository/live_repository.dart';

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

final spreadDataProvider2 = StateProvider<SpreadDocumentModel?>(
  (ref) {
    return null;
  },
);

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
  final goldBidProvider = StateProvider<double>(
    (ref) => 0.0,
  );
  final goldLowProvider = StateProvider<double>(
    (ref) => 0.0,
  );
  // double godBid = 0;

  void spreadData() {
    ref.watch(liveControllerProvider).getSpread().then(
      (value) {
        ref.read(spreadDataProvider2.notifier).update(
              (state) => value,
            );
      },
    );
  }

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
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        spreadData();
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

  // double goldValue = 0; // You need to set this value
  // double askSpread = 0; // You need to set this value
  // double bidSpread = 0;
  CommoditiesModel updateValuesPeriodically(
      CommoditiesModel data, double goldAsk, double goldBuy) {
    // Timer.periodic(Duration(milliseconds: 500), (timer) {
    // setState(() {
    // for (var data in tableData) {
    String weight = data.weight;
    double unit = double.tryParse(data.unit) ?? 0;
    double unitMultiplier = getUnitMultiplier(data.unit);
    double sellPremium = double.tryParse(data.sellPremiumAED) ?? 0;
    double buyPremium = double.tryParse(data.buyPremiumAED) ?? 0;
    print("////////");
    print(unit);
    print(unitMultiplier);
    print(sellPremium);
    print("////////");
    // double askSpreadValue = double.tryParse(data.) ?? 0;
    // double bidSpreadValue = data['bidSpread'] ?? 0;
    // double goldValue = 0; // Replace with actual goldValue

    double sellAED = calculateSellAED(
        goldAsk, sellPremium, unit, unitMultiplier, data.purity);
    // double buyAED = calculateBuyAED(
    //     goldBuy, buyPremium, unit, unitMultiplier, data['purity']);

    data.copyWith(sellAED: sellAED.toString());
    // data['buyAED'] = buyAED;
    // print(sellAED);
    // print(sellAED);
    // print(sellAED);
    // print(sellAED);
    // print("------------------------------------");
    // print(data.sellAED);
    // print(data.sellAED);
    // print(data.sellAED);
    // print(data.sellAED);
    // print(data.sellAED);
    // print(data.sellAED);
    // }
    return data;
    // });
    // });
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

  double calculateSellAED(
      double goldValueAsk,
      double sellPremium,
      // double askSpreadValue,
      double weight,
      double unitMultiplier,
      String purity) {
    // print(
    //     "*********************####################**********************************");
    // print(goldValueAsk);
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

  // double getUnitMultiplier(String unit) {
  //   switch (unit) {
  //     case "GM":
  //       return 1;
  //     case "KG":
  //       return 1000;
  //     case "TTB":
  //       return 116.6400;
  //     case "TOLA":
  //       return 11.664;
  //     case "OZ":
  //       return 31.1034768;
  //     default:
  //       return 1;
  //   }
  // }
  final goldAskPrice = StateProvider.autoDispose<double>(
    (ref) => 0,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  Text(DateFormat("EEEE").format(DateTime.now()).toUpperCase(),
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
              final spreadNow = ref1.watch(spreadDataProvider2);
              final liveRateData = ref1.watch(liveRateProvider);
              final godBid = ref1.watch(goldBidProvider);
              final godLow = ref1.watch(goldLowProvider);

              Color color = appTheme.mainWhite;
              if (liveRateData != null) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) {
                    ref1.read(rateBidValue.notifier).update(
                      (state) {
                        return liveRateData.gold.bid +
                            (spreadNow?.editedBidSpreadValue ?? 0);
                      },
                    );
                    ref1.read(goldAskPrice.notifier).update(
                      (state) {
                        final res = liveRateData.gold.bid +
                            (spreadNow?.editedBidSpreadValue ?? 0) +
                            (spreadNow?.editedAskSpreadValue ?? 0) +
                            0.5;
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
                          border:
                              Border.all(color: Colors.orangeAccent, width: 2)),
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
                              value: (liveRateData.gold.bid +
                                  (spreadNow?.editedBidSpreadValue ?? 0))),
                          space(h: 7.v),
                          // Container(
                          //   height: 50.v,
                          //   width: 120.v,
                          //   decoration: BoxDecoration(
                          //       color: color,
                          //       // color: godLow == godBid
                          //       //     ? appTheme.mainWhite
                          //       //     : godLow < godBid
                          //       //         ? appTheme.red700
                          //       //         : appTheme.mainGreen,
                          //       borderRadius: BorderRadius.circular(10),
                          //       border: Border.all(color: appTheme.gray500)),
                          //   child: Center(
                          //     child: Text(
                          //       liveRateData != null
                          //           ? (liveRateData.gold.bid +
                          //                   (spreadNow?.editedBidSpreadValue ??
                          //                       0))
                          //               .toString()
                          //           : "0.0",
                          //       style: CustomPoppinsTextStyles.bodyText2,
                          //     ),
                          //   ),
                          // ),
                          RichText(
                              softWrap:
                                  true, // Wraps text within the available width
                              overflow: TextOverflow.visible,
                              text: TextSpan(children: [
                                TextSpan(
                                    style: CustomPoppinsTextStyles.bodyTextRed,
                                    text: "LOW "),
                                TextSpan(
                                    style: CustomPoppinsTextStyles
                                        .bodyTextSemiBoldWhite,
                                    text: liveRateData != null
                                        ? ' ${liveRateData.gold.low}'
                                        : "0.0"),
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
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.orangeAccent, width: 2),
                              right: BorderSide(
                                  color: Colors.orangeAccent, width: 2),
                              top: BorderSide(
                                  color: Colors.orangeAccent, width: 2))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "GOLD ASK(BUY)",
                            style: CustomPoppinsTextStyles.bodyText4,
                          ),
                          space(h: 7.v),
                          ValueDisplayWidget2(
                              value: (liveRateData.gold.bid +
                                  (spreadNow?.editedBidSpreadValue ?? 0) +
                                  (spreadNow?.editedAskSpreadValue ?? 0) +
                                  0.5)),
                          space(h: 7.v),
                          // Container(
                          //   height: 50.v,
                          //   width: 120.v,
                          //   decoration: BoxDecoration(
                          //       color: color,
                          //       // color: appTheme.mainWhite,
                          //       borderRadius: BorderRadius.circular(10),
                          //       border: Border.all(color: appTheme.gray500)),
                          //   child: Center(
                          //     child: Text(
                          //       liveRateData != null
                          //           ? (liveRateData.gold.bid +
                          //                   (spreadNow?.editedBidSpreadValue ??
                          //                       0) +
                          //                   (spreadNow?.editedAskSpreadValue ??
                          //                       0) +
                          //                   0.5)
                          //               .toString()
                          //           : "0.0",
                          //       style: CustomPoppinsTextStyles.bodyText2,
                          //     ),
                          //   ),
                          // ),
                          RichText(
                              softWrap:
                                  true, // Wraps text within the available width
                              overflow: TextOverflow.visible,
                              text: TextSpan(children: [
                                TextSpan(
                                    style:
                                        CustomPoppinsTextStyles.bodyTextGreen,
                                    text: "HIGH "),
                                TextSpan(
                                    style: CustomPoppinsTextStyles
                                        .bodyTextSemiBoldWhite,
                                    text: liveRateData != null
                                        ? " ${liveRateData.gold.high}"
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
                      width: SizeUtils.width * 0.4,
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
                                "0.0",
                                style: CustomPoppinsTextStyles.bodyText2,
                              ),
                            ),
                          ),
                          RichText(
                              softWrap:
                                  true, // Wraps text within the available width
                              overflow: TextOverflow.visible,
                              text: TextSpan(children: [
                                TextSpan(
                                    style: CustomPoppinsTextStyles.bodyTextRed,
                                    text: "LOW "),
                                TextSpan(
                                    style: CustomPoppinsTextStyles
                                        .bodyTextSemiBold,
                                    text: " 0.0"),
                              ])),
                        ],
                      ),
                    ),
                    Container(
                      width: SizeUtils.width * 0.4,
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
                                "0.0",
                                style: CustomPoppinsTextStyles.bodyText2,
                              ),
                            ),
                          ),
                          RichText(
                              softWrap:
                                  true, // Wraps text within the available width
                              overflow: TextOverflow.visible,
                              text: TextSpan(children: [
                                TextSpan(
                                    style:
                                        CustomPoppinsTextStyles.bodyTextGreen,
                                    text: "HIGH "),
                                TextSpan(
                                    style: CustomPoppinsTextStyles
                                        .bodyTextSemiBold,
                                    text: " 0.0"),
                              ])),
                        ],
                      ),
                    )
                  ],
                );
              }
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
          ref.watch(commoditiesStream).when(
            data: (data) {
              return Consumer(
                builder: (context, ref2, child) {
                  print("Consumer is rebulding");

                  return Expanded(
                      flex: 0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final commodities = data[index];
                          // final commodities = updateValuesPeriodically(
                          //     data[index], ref2.watch(goldAskPrice), 0);
                          if (commodities.weight == "GM") {
                            return Padding(
                              padding:
                                  EdgeInsets.only(top: 8.0.v, bottom: 8.0.v),
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
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: commodities.metal.toUpperCase(),
                                          style: CustomPoppinsTextStyles
                                              .bodyText1),
                                      TextSpan(
                                          text: commodities.purity,
                                          style: GoogleFonts.poppins(
                                              // fontFamily: marine,
                                              color: appTheme.black900,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.fSize))
                                    ])),
                                    // Text(
                                    //   commodities.metal + commodities.purity,
                                    //   style: CustomPoppinsTextStyles.bodyText1,
                                    // ),
                                    Spacer(),
                                    Text(
                                      commodities.unit + commodities.weight,
                                      style: CustomPoppinsTextStyles.bodyText1,
                                    ),
                                    Spacer(),
                                    // VerticalDivider(
                                    //   color: appTheme.gray700,
                                    // ),
                                    Consumer(
                                      builder: (context, refSell, child) {
                                        final askNow =
                                            (refSell.watch(goldAskPrice) /
                                                    31.103) *
                                                3.674;
                                        // print(askNow);
                                        // print("unit ${commodities.unit}");
                                        // print(
                                        //     "Multiplier ${getUnitMultiplier(commodities.weight)}");
                                        // print(
                                        //     "Purity${(double.parse(commodities.purity) / Math.pow(10, commodities.purity.length))}");
                                        final rateNow = askNow *
                                            double.parse(commodities.unit) *
                                            getUnitMultiplier(
                                                commodities.weight) *
                                            (double.parse(commodities.purity) /
                                                Math.pow(10,
                                                    commodities.purity.length));
                                        return Text(
                                          rateNow.toStringAsFixed(2),
                                          style:
                                              CustomPoppinsTextStyles.bodyText1,
                                        );
                                      },
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            );
                          } else if (commodities.weight == "TTB") {
                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: 8.0.v, top: 8.0.v),
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
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "TEN TOLA",
                                          style: CustomPoppinsTextStyles
                                              .bodyText1),
                                      // TextSpan(
                                      //     text: commodities.purity,
                                      //     style: GoogleFonts.poppins(
                                      //       // fontFamily: marine,
                                      //         color: appTheme.black900,
                                      //         fontWeight: FontWeight.w500,
                                      //         fontSize: 10.fSize))
                                    ])),
                                    // Text(
                                    //   commodities.metal + commodities.purity,
                                    //   style: CustomPoppinsTextStyles.bodyText1,
                                    // ),
                                    Spacer(),
                                    Text(
                                      commodities.unit + commodities.weight,
                                      style: CustomPoppinsTextStyles.bodyText1,
                                    ),
                                    Spacer(),
                                    // VerticalDivider(
                                    //   color: appTheme.gray700,
                                    // ),
                                    Consumer(
                                      builder: (context, refSell, child) {
                                        final askNow =
                                            (refSell.watch(goldAskPrice) /
                                                    31.103) *
                                                3.674;
                                        // print(askNow);
                                        // print("unit ${commodities.unit}");
                                        // print(
                                        //     "Multiplier ${getUnitMultiplier(commodities.weight)}");
                                        // print(
                                        //     "Purity${(double.parse(commodities.purity) / Math.pow(10, commodities.purity.length))}");
                                        final rateNow = askNow *
                                            double.parse(commodities.unit) *
                                            getUnitMultiplier(
                                                commodities.weight) *
                                            (double.parse(commodities.purity) /
                                                Math.pow(10,
                                                    commodities.purity.length));
                                        return Text(
                                          rateNow.toStringAsFixed(0),
                                          style:
                                              CustomPoppinsTextStyles.bodyText1,
                                        );
                                      },
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: 8.0.v, top: 8.0.v),
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
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "KILOBAR",
                                          style: CustomPoppinsTextStyles
                                              .bodyText1),
                                      // TextSpan(
                                      //     text: commodities.purity,
                                      //     style: GoogleFonts.poppins(
                                      //       // fontFamily: marine,
                                      //         color: appTheme.black900,
                                      //         fontWeight: FontWeight.w500,
                                      //         fontSize: 10.fSize))
                                    ])),
                                    // Text(
                                    //   commodities.metal + commodities.purity,
                                    //   style: CustomPoppinsTextStyles.bodyText1,
                                    // ),
                                    Spacer(),
                                    Text(
                                      commodities.unit + commodities.weight,
                                      style: CustomPoppinsTextStyles.bodyText1,
                                    ),
                                    Spacer(),
                                    // VerticalDivider(
                                    //   color: appTheme.gray700,
                                    // ),
                                    Consumer(
                                      builder: (context, refSell, child) {
                                        final askNow =
                                            (refSell.watch(goldAskPrice) /
                                                    31.103) *
                                                3.674;
                                        // print(askNow);
                                        // print("unit ${commodities.unit}");
                                        // print(
                                        //     "Multiplier ${getUnitMultiplier(commodities.weight)}");
                                        // print(
                                        //     "Purity${(double.parse(commodities.purity) / Math.pow(10, commodities.purity.length))}");
                                        final rateNow = askNow *
                                            double.parse(commodities.unit) *
                                            getUnitMultiplier(
                                                commodities.weight) *
                                            (double.parse(commodities.purity) /
                                                Math.pow(10,
                                                    commodities.purity.length));
                                        return Text(
                                          rateNow.toStringAsFixed(0),
                                          style:
                                              CustomPoppinsTextStyles.bodyText1,
                                        );
                                      },
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ));
                },
              );
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
          ),
          ref.watch(newsStream).when(
            data: (data) {
              print("Newwwwssssssssssssssssssssssssssss");
              print(data.newsContent);
              return AutoScrollText(
                delayBefore: Duration(seconds: 3),
                data.newsContent + "                             ",
                style: CustomPoppinsTextStyles.bodyText,
              );
            },
            error: (error, stackTrace) {
              print(error);
              print(stackTrace);
              return SizedBox();
            },
            loading: () {
              return SizedBox();
            },
          )

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

Map a = {
  "editedAskSilverSpreadValue": 0,
  "editedAskSpreadValue": 0.5,
  "editedBidSilverSpreadValue": 0.2,
  "editedBidSpreadValue": -0.5
};

class ValueDisplayWidget extends StatefulWidget {
  final double value;

  const ValueDisplayWidget({Key? key, required this.value}) : super(key: key);

  @override
  _ValueDisplayWidgetState createState() => _ValueDisplayWidgetState();
}

class _ValueDisplayWidgetState extends State<ValueDisplayWidget> {
  Color _containerColor = Colors.white;
  Timer? _debounceTimer;
  double _lastValue = 0;

  @override
  void initState() {
    super.initState();
    _lastValue = widget.value;
  }

  @override
  void didUpdateWidget(ValueDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _updateColor();
    }
  }

  void _updateColor() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      setState(() {
        if (widget.value > _lastValue) {
          _containerColor = appTheme.mainGreen;
        } else if (widget.value < _lastValue) {
          _containerColor = appTheme.red700;
        } else {
          _containerColor = appTheme.mainWhite;
        }
        _lastValue = widget.value;
      });
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // color: _containerColor,
      height: 50.v,
      width: 120.v,
      decoration: BoxDecoration(
          color: _containerColor,
          // color: godLow == godBid
          //     ? appTheme.mainWhite
          //     : godLow < godBid
          //         ? appTheme.red700
          //         : appTheme.mainGreen,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: appTheme.gray500)),
      child: Center(
        child: Text(
          widget.value.toStringAsFixed(2),
          style: CustomPoppinsTextStyles.bodyText2,
        ),
      ),
    );
  }
}

class ValueDisplayWidget2 extends StatefulWidget {
  final double value;

  const ValueDisplayWidget2({Key? key, required this.value}) : super(key: key);

  @override
  _ValueDisplayWidget2State createState() => _ValueDisplayWidget2State();
}

class _ValueDisplayWidget2State extends State<ValueDisplayWidget2> {
  Color _containerColor = Colors.white;
  Timer? _debounceTimer;
  double _lastValue = 0;

  @override
  void initState() {
    super.initState();
    _lastValue = widget.value;
  }

  @override
  void didUpdateWidget(ValueDisplayWidget2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _updateColor();
    }
  }

  void _updateColor() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      setState(() {
        if (widget.value > _lastValue) {
          _containerColor = appTheme.mainGreen;
        } else if (widget.value < _lastValue) {
          _containerColor = appTheme.red700;
        } else {
          _containerColor = appTheme.mainWhite;
        }
        _lastValue = widget.value;
      });
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // color: _containerColor,
      height: 50.v,
      width: 120.v,
      decoration: BoxDecoration(
          color: _containerColor,
          // color: godLow == godBid
          //     ? appTheme.mainWhite
          //     : godLow < godBid
          //         ? appTheme.red700
          //         : appTheme.mainGreen,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: appTheme.gray500)),
      child: Center(
        child: Text(
          widget.value.toStringAsFixed(2),
          style: CustomPoppinsTextStyles.bodyText2,
        ),
      ),
    );
  }
}
