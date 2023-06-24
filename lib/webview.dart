// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewWidget extends StatefulWidget {
  final String url;
  const WebViewWidget({super.key, required this.url});

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  List<Permission> statuses = [
    Permission.location,
    Permission.camera,
    Permission.storage,
    Permission.microphone,
    Permission.manageExternalStorage,
    Permission.accessMediaLocation
  ];

  Future<void> requestPermissions() async {
    for (var element in statuses) {
      final status = await element.request();
    }
  }

  bool isLoading = true;

  @override
  void initState() {
    requestPermissions();
    super.initState();
    // print(widget.url);
  }

  InAppWebViewController? webViewController;
  double progres = 0;

  void _launchPlayStore() async {
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.sync.now';
    if (await canLaunch(playStoreUrl)) {
      await launch(playStoreUrl);
    } else {
      throw 'Could not launch $playStoreUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await webViewController!.canGoBack()) {
          webViewController!.goBack();
          return false;
        } else {
          return false;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(children: [
            Positioned.fill(
              child: InAppWebView(
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    progress = (progres / 100) as int;
                  });
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    isLoading = true;
                  });
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    isLoading = false;
                  });
                },
                androidOnPermissionRequest: (InAppWebViewController controller,
                    String origin, List<String> resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                onLoadError: (controller, url, code, message) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          actionsPadding: EdgeInsets.all(10),
                          backgroundColor: Colors.black87,
                          elevation: 25,
                          title: Text(
                            'Page Under Maintenance',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                letterSpacing: 0.6,
                                color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          content: Container(
                            height: 450,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/maintenance.png")),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  _launchPlayStore();
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.cyan),
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.black54),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.cyanAccent)),
                                child: Text("Check For Update",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white)))
                          ],
                        );
                      });
                },
                initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
