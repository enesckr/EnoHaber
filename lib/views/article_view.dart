import 'dart:async';

import "package:flutter/material.dart";
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  final String blogUrl;
  final String title;

  ArticleView({this.blogUrl, this.title});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Eno",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Haber",
              style: TextStyle(color: Colors.orangeAccent),
            )
          ],
        ),
        actions: [
          Container(
            child: IconButton(
              icon: Icon(
                Icons.share_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Share.share('Check out: ${widget.blogUrl}',
                    subject: widget.title);
              },
            ),
          )
        ],
        centerTitle: true,
        elevation: 15,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: widget.blogUrl,
          onWebViewCreated: ((WebViewController webViewController) {
            _completer.complete(webViewController);
          }),
        ),
      ),
    );
  }
}
