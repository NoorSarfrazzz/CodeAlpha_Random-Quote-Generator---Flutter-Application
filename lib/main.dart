import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_quote_generator_app/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favourite_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await testSharedPreferences(); // Test SharedPreferences
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: MyApp(),
    ),
  );
}

Future<void> testSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('testKey', 'testValue');
  String? value = prefs.getString('testKey');
  print('Test value: $value'); // Should print 'Test value: testValue'
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
