import 'dart:ui';
import 'package:flutter/material.dart';

import '../styles/colors.dart';

import '../context/user.dart';

import '../widgets/main_button.dart';

import './user_home.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  static const routeName = '/start';

  void _navigateToAppHomePage(context) {
    User.insertedName = '';

    Navigator.pushNamedAndRemoveUntil(
      context,
      UserHomePage.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                '😁',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 96,
                  height: 1,
                ),
              ),
              const SizedBox(height: 64),
              const Text(
                'Prontinho',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontVariations: <FontVariation>[FontVariation('wght', 600)],
                  height: 1.25,
                  color: MyColors.heading,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Agora vamos começar a cuidar das suas plantinhas com muito cuidado.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontVariations: <FontVariation>[FontVariation('wght', 400)],
                  color: MyColors.textDark,
                ),
              ),
              const SizedBox(height: 40),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 230,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    onPressed: () {
                      _navigateToAppHomePage(context);
                    },
                    child: const Text(
                      'Começar',
                      style: TextStyle(
                        fontSize: 17,
                        height: 23 / 17,
                        fontVariations: <FontVariation>[
                          FontVariation('wght', 500)
                        ],
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
