import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radia/Core/CommenWidgets/custom_image_view.dart';
import 'package:radia/Core/CommenWidgets/noNetworkScreen.dart';
import 'package:radia/Core/CommenWidgets/space.dart';
import 'package:radia/Core/app_export.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen2 extends ConsumerStatefulWidget {
  const ProfileScreen2({super.key});

  @override
  ConsumerState createState() => _ProfileScreen2State();
}

class _ProfileScreen2State extends ConsumerState<ProfileScreen2> {
  Widget _buildCard(BuildContext context, IconData icon, String title,
      String subtitle, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        color: appTheme.gold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(250, 250, 250, 0.2), // Gold background color
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: appTheme.gray800,
                  // color: appTheme.gold, // White background for the icon
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(15),
                child: Icon(
                  icon,
                  size: 30.h,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: CustomPoppinsTextStyles.bodyText1,
              ),
              SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchWhatsApp() async {
    final Uri url = Uri.parse(
        'https://wa.me/+971542172259'); // Replace with your WhatsApp link
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  void _launchMail() async {
    final Uri url = Uri.parse(
        'mailto:pulparambilgold@gmail.com'); // Replace with your mail link
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  void _launchContact() async {
    final Uri url =
        Uri.parse('tel:+971542172259'); // Replace with your contact number
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  void _launchMap() async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=25.2737112,55.2999215'); // Replace with your map link
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

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
        ), // Ensure this image exists in your assets folder
        space(),
        Text(
          'Customer Support',
          style: CustomPoppinsTextStyles.bodyText3White,
        ),
        Text(
          '24 / 7 Support',
          style: CustomPoppinsTextStyles.bodyText1White,
        ),
        SizedBox(height: 20),
        Expanded(
          flex: 0,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 11,
            crossAxisSpacing: 11,
            children: [
              _buildCard(
                context,
                FontAwesomeIcons.whatsapp,
                'WhatsApp',
                '+971542172259',
                _launchWhatsApp,
              ),
              _buildCard(
                context,
                FontAwesomeIcons.envelope,
                'Mail',
                'Drop us a line',
                _launchMail,
              ),
              _buildCard(
                context,
                FontAwesomeIcons.phone,
                'Call Us',
                '+971542172259',
                _launchContact,
              ),
              _buildCard(
                context,
                FontAwesomeIcons.mapLocationDot,
                'Our Adress',
                'React us at',
                _launchMap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// class AboutUsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color(0xFF1F0B0A),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Color(0xFFD3AF37)),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(
//                   'assets/images/background.png'), // Ensure this image exists in your assets folder
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(22.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                  space(),
//                   Image.asset('assets/images/logo.png',
//                       height:
//                       150), // Ensure this image exists in your assets folder
//                   SizedBox(height: 10),
//                   Text(
//                     'Customer Support',
//                     style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     '24 / 7 Support',
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                   SizedBox(height: 20),
//                   Expanded(
//                     child: GridView.count(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 11,
//                       crossAxisSpacing: 11,
//                       children: [
//                         _buildCard(
//                           context,
//                           FontAwesomeIcons.whatsapp,
//                           'WhatsApp',
//                           '+971542172259',
//                           _launchWhatsApp,
//                         ),
//                         _buildCard(
//                           context,
//                           FontAwesomeIcons.envelope,
//                           'Mail',
//                           'Drop us a line',
//                           _launchMail,
//                         ),
//                         _buildCard(
//                           context,
//                           FontAwesomeIcons.phone,
//                           'Call Us',
//                           '+971542172259',
//                           _launchContact,
//                         ),
//                         _buildCard(
//                           context,
//                           FontAwesomeIcons.mapLocationDot,
//                           'Our Adress',
//                           'React us at',
//                           _launchMap,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
// }