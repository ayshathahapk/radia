import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFD3AF37)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/rrrr.jpg'), // Ensure this image exists in your assets folder
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Image.asset('assets/images/Radia logo.png',
                      height:
                      100), // Ensure this image exists in your assets folder
                  SizedBox(height: 15),
                  Text(
                    'Customer Support',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '24 / 7 Support',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 11,
                      crossAxisSpacing: 11,
                      children: [
                        _buildCard(
                          context,
                          FontAwesomeIcons.whatsapp,
                          'WhatsApp',
                          '+971542471894',
                          _launchWhatsApp,
                        ),
                        _buildCard(
                          context,
                          FontAwesomeIcons.envelope,
                          'Mail',
                          'Reach us at',
                          _launchMail,
                        ),
                        _buildCard(
                          context,
                          FontAwesomeIcons.phone,
                          'Call Us',
                          '+97145468443',
                          _showCallBottomSheet,
                        ),
                        _buildCard(
                          context,
                          FontAwesomeIcons.mapLocationDot,
                          'Our Address',
                          'Reach us at',
                          _launchMap,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title,
      String subtitle, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(250, 250, 250, 0.2), // Gold background color
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFdbbd75), // White background for the icon
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
      ),
    );
  }

  void _launchWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/+971542471894'); // Replace with your WhatsApp link
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  void _launchMail() async {
    final Uri url = Uri.parse('mailto:radiamohammedjewelleryllc@gmail.com'); // Replace with your mail link
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  void _showCallBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration:BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(FontAwesomeIcons.phone, color: Color(0xFFD3AF37)),
                title: Text(
                  '+971542471894',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _launchContact('+971542471894');
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.phone, color: Color(0xFFD3AF37)),
                title: Text(
                  '+97145468443',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _launchContact('+97145468443');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchContact(String phoneNumber) async {
    final Uri url = Uri.parse('tel:+97145468443'); // Replace with your contact number
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  void _launchMap() async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=25.2737112,55.2999215'); // Replace with your map link
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  bool get wantKeepAlive => true;
}