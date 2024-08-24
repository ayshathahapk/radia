import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radia/Core/app_export.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../Core/CommenWidgets/CustomElevatedButton/custom_elevated_button.dart';
import '../../../Core/CommenWidgets/space.dart';

class RatePage extends ConsumerStatefulWidget {
  const RatePage({super.key});

  @override
  ConsumerState createState() => _RatePageState();
}

class _RatePageState extends ConsumerState<RatePage> {
  int _counter = 0;
  int count = 0;
  final countProvider = StateProvider(
    (ref) => 500,
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: appTheme.gold,
          elevation: 5,
          surfaceTintColor: appTheme.gold,
          child: SizedBox(
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
                              return Text(
                                "\$5265.20",
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
        ),
        space(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomElevatedButton(
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
                  ref1.watch(countProvider).toString(),
                  style: CustomPoppinsTextStyles.bodyText1White,
                );
              },
            ),
            space(w: 55.h),
            CustomElevatedButton(
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
        )
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
      ],
    );
  }
}
