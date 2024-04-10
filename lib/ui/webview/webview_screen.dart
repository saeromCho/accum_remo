import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setBackgroundColor(Colors.black)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://www.google.com'),
      )
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          return NavigationDecision.navigate;
        },
        onUrlChange: (UrlChange change) {
          debugPrint('url change to ${change.url}');
        },
        onPageFinished: (String url) {
          debugPrint('page finished loading: $url');
        },
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
