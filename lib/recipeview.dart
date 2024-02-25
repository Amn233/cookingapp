import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Recipeview extends StatefulWidget {
  String url;
  Recipeview(this.url);

  @override
  State<Recipeview> createState() => _RecipeviewState();
}

class _RecipeviewState extends State<Recipeview> {
  bool isloading = true;
  late String finalurl;
  final Completer<WebViewController> controller = Completer<WebViewController>();

  @override
  void initState() {
    if(widget.url.toString().contains("http://")){
      finalurl=widget.url.toString().replaceAll("http://", "https://");
    }
    else {
      finalurl=widget.url;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipe App',
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade100,
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: finalurl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webviewcontroller) {
              setState(() {
                controller.complete(webviewcontroller);
              });
            },
            onPageStarted: (String url) {
              setState(() {
                isloading = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                isloading = false;
              });
            },
          ),
          // Add CircularProgressIndicator based on the loading state
          if (isloading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
