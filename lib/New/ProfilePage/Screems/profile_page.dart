import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radia/Core/CommenWidgets/custom_image_view.dart';
import 'package:radia/Core/CommenWidgets/space.dart';
import 'package:radia/New/BankDetails%20Screen/bank_details.dart';
import 'package:radia/New/NewsScreen/Screen/news_screen.dart';
import 'package:radia/New/ProfilePage/Screems/2_profile_screen.dart';

import '../../../Core/app_export.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstants.logo,
          width: 90.h,
        ),
        CustomImageView(
          imagePath: ImageConstants.logoText,
        ),
        space(),
        Expanded(
          flex: 0,
          // height: SizeUtils.height * 0.22,
          // width: SizeUtils.width,
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              mainAxisSpacing: 15.v, // Spacing between rows
              crossAxisSpacing: 15.h, // Spacing between columns
              childAspectRatio: 1.5.v, // Aspect ratio of each item
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              // final data = category[index];
              return GestureDetector(
                onTap: () {},
                child: Card(
                  elevation: 3,
                  color: Colors.amber.shade200,
                  surfaceTintColor: appTheme.whiteA700,
                  // decoration: BoxDecoration(
                  //     color: appTheme.gray300,
                  //     borderRadius: BorderRadius.circular(55.h)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomImageView(
                          border: Border.all(color: appTheme.mainWhite),
                          imagePath: ImageConstants.logo,
                          height: 40.adaptSize,
                          width: 40.adaptSize,
                          radius: BorderRadius.circular(
                            17.h,
                          ),
                        ),
                        // Image.network(
                        //   data.iconImage,
                        //   height: 40.v,
                        //   width: 40.h,
                        //   fit: BoxFit.cover,
                        // ),
                        // // Icon(
                        // //   CupertinoIcons.square_split_2x2_fill,
                        // //   color: appTheme.blueGray900,
                        // // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

Widget showBottomSheetScreen({required BuildContext context}) {
  return SizedBox(
    height: SizeUtils.height * 0.2,
    width: SizeUtils.width,
    child: ListView(
      padding: EdgeInsets.all(10),
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen2(),
                ));
          },
          child: Row(
            children: [
              CustomImageView(
                imagePath: ImageConstants.personIcon,
                width: 30.v,
                color: appTheme.gray800,
              ),
              Text(
                "  Profile",
                style: GoogleFonts.poppins(
                    // fontFamily: marine,
                    color: appTheme.gray800,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.fSize),
              )
            ],
          ),
        ),
        space(),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsScreen(),
                ));
          },
          child: Row(
            children: [
              CustomImageView(
                imagePath: ImageConstants.newsIcon,
                width: 30.v,
                color: appTheme.gray800,
              ),
              Text(
                "  News",
                style: GoogleFonts.poppins(
                    // fontFamily: marine,
                    color: appTheme.gray800,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.fSize),
              )
            ],
          ),
        ),
        space(),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const Details();
              },
            ));
          },
          child: Row(
            children: [
              CustomImageView(
                imagePath: ImageConstants.bankIcon,
                width: 30.v,
                color: appTheme.gray800,
              ),
              Text(
                "  Bank Details",
                style: GoogleFonts.poppins(
                    // fontFamily: marine,
                    color: appTheme.gray800,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.fSize),
              )
            ],
          ),
        ),
        space(),
      ],
    ),
  );
}
