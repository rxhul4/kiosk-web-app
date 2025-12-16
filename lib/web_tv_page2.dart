import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class TvWebViewApp extends StatelessWidget {
  const TvWebViewApp({super.key});

  static const String targetUrl = 'https://tv.piprahwaexhibition.com';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV WebView',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _error = null;
            });
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (err) {
            setState(() {
              _isLoading = false;
              _error =
              'Failed to load:\n${TvWebViewApp.targetUrl}\n\n${err.errorType} (${err.errorCode})\n${err.description}';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(TvWebViewApp.targetUrl));
  }

  @override
  Widget build(BuildContext context) {
    // 1) Base platform params
    PlatformWebViewWidgetCreationParams params =
    PlatformWebViewWidgetCreationParams(
      controller: _controller.platform,
      layoutDirection: TextDirection.ltr,
      gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
    );

    // 2) Wrap with Android-specific params and force Hybrid Composition
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewWidgetCreationParams
          .fromPlatformWebViewWidgetCreationParams(
        params,
        displayWithHybridComposition: true, // 👈 THIS is the important bit
      );
    }

    // 3) Build the final widget from creation params
    final webView = WebViewWidget.fromPlatformCreationParams(
      params: params,
    );

    return Scaffold(
      body: Stack(
        children: [
          webView,
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          if (_error != null && !_isLoading)
            Container(
              color: Colors.black.withOpacity(0.8),
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
