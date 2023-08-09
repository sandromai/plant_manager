import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'styles/colors.dart';

import 'pages/home.dart';
import 'pages/start.dart';
import 'pages/register.dart';
import 'pages/user_home.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: MyColors.green,
    systemNavigationBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final storedUserName = sharedPreferences.getString('name');

  runApp(App(
    userName: storedUserName,
  ));
}

class App extends StatelessWidget {
  const App({super.key, this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlantManager',
      initialRoute:
          (userName == null) ? HomePage.routeName : UserHomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        StartPage.routeName: (context) => const StartPage(),
        UserHomePage.routeName: (context) {
          final storedUserName = userName;
          final routeUserName =
              ModalRoute.of(context)!.settings.arguments as String?;

          if (routeUserName != null) {
            return UserHomePage(userName: routeUserName);
          }

          if (storedUserName != null) {
            return UserHomePage(userName: storedUserName);
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
