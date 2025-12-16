import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piprahwa/web_tv_page.dart';
import 'package:piprahwa/web_tv_page2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure immersive fullscreen (hide system bars)
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Piprahwa TV',
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: const TvWebViewApp(),
    );
  }
}
