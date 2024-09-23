import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Liverate extends StatefulWidget {
  const Liverate({super.key});

  @override
  State<Liverate> createState() => _LiverateState();
}

class _LiverateState extends State<Liverate> with AutomaticKeepAliveClientMixin {
  double _progress = 0;
  final uri = Uri.parse("https://aurifyae.github.io/Radiagold-app/");
  late InAppWebViewController inAppWebViewController;

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri.uri(uri),
              ),
              onWebViewCreated: (controller) {
                inAppWebViewController = controller;
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
            ),
            _progress < 1
                ? LinearProgressIndicator(value: _progress)
                : Container(),
          ],
        ),
      ),
    );
  }
}

