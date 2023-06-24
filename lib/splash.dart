// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview/webview.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  late final finalUrl, textContent;
  String url =
      "https://api.github.com/repos/nexstreamuser/syncnow/contents/main.txt";
  // String url = "https://google.com";
  Future<void> getLink(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final res = response.body;
        var apiResponse = json.decode(res);
        String base64Content = apiResponse['content'];
        // print(base64Content);
        String cleanedText = (base64Content.replaceAll('\n', ''));

        textContent = utf8.decode(base64.decode(cleanedText));
      }
    } catch (e) {
      print('Error: $e');
    }
    finalUrl = textContent
            .toString()
            .substring(0, textContent.toString().length - 1) ??
        "https://google.com";
    // print(finalUrl);
    // print(finalUrl.toString().length);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewWidget(url: finalUrl.toString())));
  }

  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      getLink(url);
    });
    // getLink(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            color: Colors.blue[400],
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Image.asset("assets/img2.png", width: 250),
                Text(
                  "We Provide Best and Trusted Public and",
                  style: TextStyle(
                      fontSize: 18, fontFamily: "Poppins", color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Private Chat Rooms",
                  style: TextStyle(
                      fontSize: 18, fontFamily: "Poppins", color: Colors.white),
                ),
                SizedBox(
                  height: 200,
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      letterSpacing: 0.5),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Made With Love',
                          speed: Duration(milliseconds: 200)),
                    ],
                    repeatForever: true,
                  ),
                ),
              ],
            )));
  }
}
