import 'package:flutter/material.dart';
import 'package:front_sosmed/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front_sosmed/pages/home_page.dart';
import 'package:front_sosmed/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ApalahProvider()),
    // Tambahkan provider lain jika diperlukan
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final newTextTheme = Theme.of(context).textTheme.apply(
          fontFamily: 'MPLUSRounded1c',
        );
    return MaterialApp(
      theme: ThemeData(
          textTheme: newTextTheme,
          scaffoldBackgroundColor: const Color.fromARGB(237, 255, 255, 255)),
      home: const AuthPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}
