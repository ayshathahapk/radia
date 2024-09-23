import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radia/features/Screens/profile.dart';
import '../../main.dart';
import 'bankdetails.dart';
import 'news.dart';

class ShowRadiaextrapage extends StatefulWidget {
  const ShowRadiaextrapage({super.key});

  @override
  State<ShowRadiaextrapage> createState() => _ShowpageState();
}

class _ShowpageState extends State<ShowRadiaextrapage> {
  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: height * 0.25,
        width: width,
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person_pin), // Icon for 'Bank Details'
              title: Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(),));
              },
            ),
            ListTile(
              leading: Icon(Icons.newspaper_outlined), // Icon for 'Bank Details'
              title: Text('News'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => News(),));
              },
            ),
            ListTile(
              leading: Icon(Icons.comment_bank), // Icon for 'Bank Details'
              title: Text('Bank Details'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Bankdetails(),));
              },
            ),
          ],
        ),

      );
  }
}
