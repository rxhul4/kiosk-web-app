// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// //
// // class WebTvPage extends StatefulWidget {
// //   const WebTvPage({super.key});
// //
// //   @override
// //   State<WebTvPage> createState() => _WebTvPageState();
// // }
// //
// // class _WebTvPageState extends State<WebTvPage> {
// //   final GlobalKey webViewKey = GlobalKey();
// //   InAppWebViewController? _webViewController;
// //   bool _isLoading = true;
// //   final String initialUrl = 'https://tv.piprahwaexhibition.com/';
// //   PullToRefreshController? pullToRefreshController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     // InAppWebView uses platform views (hybrid composition) by default.
// //
// //     // Optional: Configure Pull-to-Refresh if you want that functionality
// //     pullToRefreshController = PullToRefreshController(
// //       options: PullToRefreshOptions(
// //         color: Colors.blue,
// //       ),
// //       onRefresh: () async {
// //         if (Platform.isAndroid) {
// //           _webViewController?.reload();
// //         } else if (Platform.isIOS) {
// //           _webViewController?.loadUrl(urlRequest: URLRequest(url: await _webViewController?.getUrl()));
// //         }
// //       },
// //     );
// //   }
// //
// //   Future<bool> _onWillPop() async {
// //     // If the webview can go back, go back instead of closing the app
// //     if (_webViewController != null && await _webViewController!.canGoBack()) {
// //       _webViewController!.goBack();
// //       return false; // don't pop the app
// //     }
// //     // otherwise allow the app to be popped (exit)
// //     return true;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: _onWillPop,
// //       child: Scaffold(
// //         body: Stack(
// //           children: [
// //             SafeArea(
// //               top: false,
// //               bottom: false,
// //               child: InAppWebView(
// //                 key: webViewKey,
// //                 initialUrlRequest: URLRequest(url: Uri.parse(initialUrl)),
// //                 // Set initial options for better TV compatibility
// //                 initialOptions: InAppWebViewGroupOptions(
// //                   crossPlatform: InAppWebViewOptions(
// //                     // Enable JavaScript and allow hybrid composition defaults
// //                     javaScriptEnabled: true,
// //                     // This option is key for certain Android TV rendering scenarios
// //                     mediaPlaybackRequiresUserGesture: false,
// //                   ),
// //                   android: AndroidInAppWebViewOptions(
// //                     // Enable hardware acceleration if needed for video playback
// //                     useHybridComposition: true,
// //                   ),
// //                 ),
// //                 pullToRefreshController: pullToRefreshController,
// //                 onWebViewCreated: (controller) {
// //                   _webViewController = controller;
// //                 },
// //                 onLoadStart: (controller, url) {
// //                   setState(() => _isLoading = true);
// //                 },
// //                 onLoadStop: (controller, url) {
// //                   pullToRefreshController?.endRefreshing();
// //                   setState(() => _isLoading = false);
// //                 },
// //                 onProgressChanged: (controller, progress) {
// //                   if (progress == 100) {
// //                     setState(() => _isLoading = false);
// //                   }
// //                   // Update progress indicator if desired
// //                 },
// //                 onLoadError: (controller, url, code, message) {
// //                   pullToRefreshController?.endRefreshing();
// //                   // Handle error loading the page
// //                 },
// //               ),
// //             ),
// //
// //             // Loading indicator
// //             if (_isLoading)
// //               const Center(
// //                 child: SizedBox(
// //                   width: 72,
// //                   height: 72,
// //                   child: CircularProgressIndicator(
// //                     strokeWidth: 6,
// //                     color: Colors.grey,
// //                   ),
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
//
// class WebTvPage extends StatefulWidget {
//   const WebTvPage({super.key});
//
//   @override
//   State<WebTvPage> createState() => _WebTvPageState();
// }
//
// class _WebTvPageState extends State<WebTvPage> {
//   late final WebViewController _controller;
//   bool _isLoading = true;
//   final String initialUrl = 'https://tv.piprahwaexhibition.com/';
//
//   @override
//   void initState() {
//     super.initState();
//
//     // // Enable hybrid composition on Android (improves compatibility)
//     // late final PlatformWebViewControllerCreationParams params;
//     // if (WebViewPlatform.instance is android.AndroidWebViewPlatform) {
//     //   params = android.AndroidWebViewControllerCreationParams(
//     //     // This ensures hybrid composition is used if the device/version supports it.
//     //     // It uses Texture Layer Hybrid Composition by default for newer devices (API 23+)
//     //     // and falls back to standard Hybrid Composition for older ones.
//     //     // The displayWithHybridComposition property can force it for versions >= 23 if needed.
//     //     displayWithHybridComposition: true,
//     //   );
//     // } else {
//     //   Use standard creation params for other platforms (iOS uses hybrid composition by default)
//       // params = const PlatformWebViewControllerCreationParams();
//     // }
//     if (_controller.platform is AndroidWebViewController) {
//       (_controller.platform as AndroidWebViewController)
//           .setOnWebViewWidgetCreationParams(
//           AndroidWebViewWidgetCreationParams(
//               displayWithHybridComposition: true));
//     }
//
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (progress) {
//             // progress: 0-100
//             if (progress == 100) {
//               setState(() => _isLoading = false);
//             }
//           },
//           onPageStarted: (url) => setState(() => _isLoading = true),
//           onPageFinished: (url) => setState(() => _isLoading = false),
//           onNavigationRequest: (request) {
//             // Allow navigation inside the webview
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(initialUrl));
//   }
//
//   Future<bool> _onWillPop() async {
//     // If the webview can go back, go back instead of closing the app
//     if (await _controller.canGoBack()) {
//       _controller.goBack();
//       return false; // don't pop the app
//     }
//     // otherwise allow the app to be popped (exit)
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         body: Stack(
//           children: [
//             SafeArea(
//               top: false,
//               bottom: false,
//               child: WebViewWidget(controller: _controller),
//             ),
//
//             // Loading indicator
//             if (_isLoading)
//               const Center(
//                 child: SizedBox(
//                   width: 72,
//                   height: 72,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 6,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//
//             // Optional small overlay button to reload (hidden for kiosk)
//             // Positioned(
//             //   right: 16,
//             //   top: 16,
//             //   child: SafeArea(
//             //     child: FloatingActionButton(
//             //       heroTag: 'reload',
//             //       mini: true,
//             //       onPressed: () => _controller.reload(),
//             //       child: const Icon(Icons.refresh),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
