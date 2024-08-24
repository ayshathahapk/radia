import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radia/Core/CommenWidgets/custom_image_view.dart';
import 'package:radia/Core/CommenWidgets/space.dart';

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
    height: SizeUtils.height * 0.25,
    width: SizeUtils.width,
    child: ListView(
      children: <Widget>[
        CustomImageView(
          imagePath: ImageConstants.personIcon,
        ),
        CustomImageView(
          imagePath: ImageConstants.newsIcon,
        ),
        CustomImageView(
          imagePath: ImageConstants.bankIcon,
        ),
        ListTile(
          leading: Icon(Icons.person_pin), // Icon for 'Bank Details'
          title: Text('Profile'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(),
                ));
          },
        ),
        ListTile(
          leading: Icon(Icons.newspaper_outlined), // Icon for 'Bank Details'
          title: Text('News'),
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => News(),
            //     ));
          },
        ),
        ListTile(
          leading: Icon(Icons.comment_bank), // Icon for 'Bank Details'
          title: Text('Bank Details'),
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => Bankdetails(),
            //     ));
          },
        ),
      ],
    ),
  );
}
