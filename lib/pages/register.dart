import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles/colors.dart';

import '../context/user.dart';

import '../widgets/loading_dots.dart';
import '../widgets/main_button.dart';

import './start.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController(
    text: User.insertedName,
  );

  bool _nameIsEmpty = User.insertedName == '';
  bool _isSavingName = false;

  void _nameControllerHandler() {
    User.insertedName = _nameController.text.trim();

    if (_nameIsEmpty != (User.insertedName == '')) {
      setState(() => _nameIsEmpty = !_nameIsEmpty);
    }
  }

  void _handleNameSubmit() {
    setState(() => _isSavingName = true);

    FocusManager.instance.primaryFocus?.unfocus();

    User.name = User.insertedName;

    SharedPreferences.getInstance().then((sharedPreferences) {
      sharedPreferences.setString('name', User.name as String);
    });

    Navigator.pushNamed(context, StartPage.routeName);

    setState(() => _isSavingName = false);
  }

  @override
  void initState() {
    _nameController.addListener(_nameControllerHandler);

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 120, 16, 24),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                !_nameIsEmpty ? '😄' : '😀',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  height: 1,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Como podemos\n chamar você?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontVariations: <FontVariation>[FontVariation('wght', 600)],
                  height: 32 / 24,
                  color: MyColors.heading,
                ),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: TextField(
                  controller: _nameController,
                  enabled: !_isSavingName,
                  onSubmitted: !_nameIsEmpty
                      ? (value) {
                          _handleNameSubmit();
                        }
                      : null,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  textCapitalization: TextCapitalization.words,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffcfcfcf),
                        width: 1,
                      ),
                    ),
                    hintText: 'Digite seu nome',
                    hintStyle: TextStyle(
                      fontSize: 17,
                      fontVariations: const <FontVariation>[
                        FontVariation('wght', 400)
                      ],
                      color: MyColors.textDark.withOpacity(0.5),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 17,
                    fontVariations: <FontVariation>[FontVariation('wght', 400)],
                    color: MyColors.textDark,
                  ),
                  scrollPadding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 0,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 230,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    enabled: (!_nameIsEmpty && !_isSavingName),
                    onPressed: (!_nameIsEmpty && !_isSavingName)
                        ? _handleNameSubmit
                        : null,
                    child: _isSavingName
                        ? const LoadingDots(
                            color: Colors.white,
                            size: 23,
                          )
                        : const Text(
                            'Confirmar',
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
