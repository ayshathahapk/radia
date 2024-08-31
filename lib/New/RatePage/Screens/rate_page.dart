import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radia/Core/Utils/snackbar_dialogs.dart';
import 'package:radia/Core/app_export.dart';
import 'package:radia/Models/alertValue_model.dart';
import 'package:radia/New/LivePage/Controller/live_controller.dart';
import 'package:radia/New/NavigationBar/navigation_bar.dart';
import 'package:radia/New/RatePage/Controller/rate_controller.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../Core/CommenWidgets/CustomElevatedButton/custom_elevated_button.dart';
import '../../../Core/CommenWidgets/space.dart';
import '../../../Core/Utils/notification service.dart';
import '../../LivePage/Repository/live_repository.dart';
import '../../LivePage/Screens/live_page.dart';

class RatePage extends ConsumerStatefulWidget {
  const RatePage({super.key});

  @override
  ConsumerState createState() => _RatePageState();
}

class _RatePageState extends ConsumerState<RatePage> {
  List<String> lists = ["data", "cata", "fata"];
  int _counter = 0;
  int count = 0;
  final countProvider = StateProvider<double>(
    (ref) => 0,
  );
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(countProvider.notifier).update(
              (state) => ref.watch(rateBidValue),
            );
      },
    );
  }

  final NotificationService _notificationService = NotificationService();
  final incrementCount = StateProvider<double>(
    (ref) {
      return 0;
    },
  );

  final decrementCount = StateProvider<double>(
    (ref) {
      return 0;
    },
  );
  final alertAmount = StateProvider(
    (ref) {
      return 0.0;
    },
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          space(h: SizeUtils.height * 0.2),
          SizedBox(
            height: SizeUtils.height * 0.15,
            width: SizeUtils.height * 0.15,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: SizeUtils.height * 0.055,
                    backgroundColor: appTheme.gray800,
                    child: CircleAvatar(
                      backgroundColor: appTheme.gold,
                      radius: SizeUtils.height * 0.05,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer(
                            builder: (context, ref1, child) {
                              final spreadNow = ref1.watch(spreadDataProvider2);
                              final liveRateData = ref1.watch(liveRateProvider);
                              ref1.watch(rateBidValue);
                              final res = ref1.watch(rateBidValue);
                              return Text(
                                "\$${liveRateData!.gold.bid + (spreadNow?.editedBidSpreadValue ?? 0)}",
                                style: CustomPoppinsTextStyles.bodyText,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          space(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomElevatedButton(
                onPressed: () {
                  ref.read(countProvider.notifier).update(
                    (state) {
                      double res = state - 1;
                      return res;
                    },
                  );
                },
                // onPressed: () async {
                //   BookingModel res = widget.bookingModel;
                //   if (widget.bookingModel.driver ==
                //       "Dummy Driver") {
                //     res = res.copyWith(
                //         status: "Order Received",
                //         selectedDriver: ref.watch(dId),
                //         driver: ref
                //             .watch(userDataProvider)
                //             ?.driverName ??
                //             "");
                //   } else {
                //     res = res.copyWith(status: "Order Received");
                //   }
                //   ref
                //       .read(homeContProvider)
                //       .statusUpdate(model: res, context: context);
                //   // Navigator.push(
                //   //     context,
                //   //     MaterialPageRoute(
                //   //       builder: (context) => PickupDetails(
                //   //         bookingModel: res,
                //   //       ),
                //   //     ));
                // },
                height: 40.v,
                width: 90.h,
                text: "-50",
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      appTheme.gold), // Set background color to red
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.h),
                    ),
                  ),
                ),
                buttonTextStyle: theme.textTheme.titleMedium!,
              ),
              space(w: 55.h),
              Consumer(
                builder: (context, ref1, child) {
                  return Text(
                    ref1.watch(countProvider).toStringAsFixed(0),
                    style: CustomPoppinsTextStyles.bodyText1White,
                  );
                },
              ),
              space(w: 55.h),
              CustomElevatedButton(
                onPressed: () {
                  // NotificationService.showInstantNotification(
                  //     "Alert", "2562", "high_importance_channel");
                  if (ref.watch(incrementCount) < 50) {
                    ref.read(incrementCount.notifier).update(
                          (state) => state++,
                        );
                    ref.read(countProvider.notifier).update(
                      (state) {
                        double res = state + 1;
                        return res;
                      },
                    );
                  }
                },
                // onPressed: () async {
                //   final res = widget.bookingModel
                //       .copyWith(status: "Rejected");
                //   final out = await alert(
                //       context, "Do you want to Reject?");
                //   if (out == true) {
                //     ref.read(homeContProvider).statusUpdate(
                //         model: res, context: context);
                //   }
                // },
                height: 40.v,
                width: 90.h,
                text: "+50",
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      appTheme.gold), // Set background color to red
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.h),
                    ),
                  ),
                ),
                buttonTextStyle: theme.textTheme.titleMedium!,
              ),
            ],
          ),
          // SleekCircularSlider(
          //     initialValue: 50,
          //     innerWidget: (percentage) {
          //       WidgetsBinding.instance.addPostFrameCallback(
          //         (timeStamp) {
          //           if (percentage == 50) {
          //             ref.read(countProvider.notifier).update(
          //                   (state) => percentage.toInt(),
          //                 );
          //           } else if (percentage < 50) {
          //             count = percentage.toInt();
          //             ref.read(countProvider.notifier).update(
          //                   (state) => percentage.toInt(),
          //                 );
          //             print(percentage);
          //             print(
          //                 "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-$count-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
          //           } else {
          //             count = percentage.toInt();
          //             ref.read(countProvider.notifier).update(
          //                   (state) => percentage.toInt(),
          //                 );
          //
          //             print(percentage);
          //             print(
          //                 "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-$count-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
          //           }
          //         },
          //       );
          //       return const SizedBox();
          //     },
          //     appearance: CircularSliderAppearance(
          //         customWidths: CustomSliderWidths(
          //             handlerSize: 15, progressBarWidth: 15, trackWidth: 15),
          //         size: 200,
          //         spinnerMode: false,
          //         customColors: CustomSliderColors(
          //             trackColor: appTheme.gold,
          //             dynamicGradient: false,
          //             progressBarColor: Colors.transparent,
          //             hideShadow: true)),
          //     onChange: (double value) {
          //       print(value);
          //     })
          space(h: 30.v),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 8,
            ),
            child: SwipeButton(
              inactiveTrackColor: appTheme.gray800,
              activeTrackColor: appTheme.gold,
              thumbPadding: const EdgeInsets.all(3),
              thumb: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              elevationThumb: 2,
              elevationTrack: 2,
              child: Text(
                "Set Alert".toUpperCase(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onSwipe: () {
                AlertValueModel model = AlertValueModel(
                    alertValue: ref.watch(countProvider).roundToDouble(),
                    fcm: ref.watch(fcmToken),
                    uniqueId: ref.watch(diviceID),
                    docId: '');
                ref
                    .read(rateController)
                    .setAlert(model: model, context: context);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text("Swipped"),
                //     backgroundColor: Colors.green,
                //   ),
                // );
              },
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              return ref.watch(allAlertStream(ref.watch(diviceID))).when(
                data: (data) {
                  return Expanded(
                      flex: 0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                              endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        ref.read(rateController).deleteAlert(
                                            model: data[index],
                                            context: context);
                                        // final okk = await alert(
                                        //     context, "Are You Sure?");
                                        // if (okk == true) {
                                        //   ref.read(rateController).deleteAlert(
                                        //       model: data[index],
                                        //       context: context);
                                        // }
                                      },
                                      backgroundColor: appTheme.red700,
                                      icon: CupertinoIcons.delete_simple,
                                    )
                                  ]),
                              child: Card(
                                elevation: 0,
                                color: appTheme.gold,
                                child: ListTile(
                                  trailing: Icon(CupertinoIcons.alarm),
                                  leading: Text((index + 1).toString()),
                                  title: Text(
                                    "${data[index].alertValue}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18.fSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ));
                },
                error: (error, stackTrace) {
                  print(error.toString());
                  print(stackTrace);
                  return SizedBox();
                },
                loading: () {
                  return SizedBox();
                },
              );
            },
          )
        ],
      ),
    );
  }
}
