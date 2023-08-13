import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'styles/colors.dart';

import 'pages/home.dart';
import 'pages/start.dart';
import 'pages/register.dart';
import 'pages/user_home.dart';

import 'context/user.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: MyColors.green,
    systemNavigationBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final storedUserName = sharedPreferences.getString('name');

  User.name = storedUserName;

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlantManager',
      initialRoute:
          (User.name == null) ? HomePage.routeName : UserHomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        StartPage.routeName: (context) => const StartPage(),
        UserHomePage.routeName: (context) {
          if (User.name != null) {
            return const UserHomePage();
          }

          return const HomePage();
        },
      },
      theme: ThemeData(
        fontFamily: 'Jost',
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyColors.green,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
    );
  }
}
