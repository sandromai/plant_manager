import 'dart:ui';
import 'package:flutter/material.dart';

import '../styles/colors.dart';

import '../widgets/main_button.dart';

import './register.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  void navigateToRegisterPage(context) {
    Navigator.pushNamed(context, RegisterPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Gerencie\n suas plantas de\n forma fácil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontVariations: <FontVariation>[FontVariation('wght', 600)],
                  height: 1.1875,
                  color: MyColors.heading,
                ),
              ),
              const SizedBox(height: 32),
              const Image(
                image: AssetImage('assets/images/home.webp'),
              ),
              const SizedBox(height: 48),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 288),
                child: const Text(
                  'Não esqueça mais de regar suas plantas. Nós cuidamos de lembrar você sempre que precisar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontVariations: <FontVariation>[FontVariation('wght', 400)],
                    color: MyColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              MainButton(
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size.square(56),
                ),
                child: const Icon(
                  size: 22,
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  navigateToRegisterPage(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
