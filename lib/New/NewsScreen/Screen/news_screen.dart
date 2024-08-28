import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:radia/Core/app_export.dart';

import '../../../Core/CommenWidgets/space.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: SizeUtils.height,
          width: SizeUtils.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstants.logoBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Image.asset(
                  ImageConstants.logo,
                  width: SizeUtils.width * 0.30,
                ),
                Image.asset(ImageConstants.logoText),
                Text(
                  DateFormat('MMM/dd/yyyy-h:mm:ss a').format(DateTime.now()),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: SizeUtils.height * 0.02,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Latest News",
                      style: CustomPoppinsTextStyles.bodyText1White,
                    )),
                Container(
                  color: const Color(0xFFBFA13A),
                  width: SizeUtils.width * 0.93,
                  // decoration: BoxDecoration(borderRadius: BorderRadius.all()),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        space(),
                        Text(
                          "text..............................",
                          style: TextStyle(color: Colors.black),
                        ),
                        space(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
