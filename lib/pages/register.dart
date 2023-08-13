import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles/colors.dart';

import '../widgets/loading_dots.dart';
import '../widgets/main_button.dart';

import '../context/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameFormKey = GlobalKey<FormState>();

  String _name = '';
  bool _isSavingName = false;

  void _handleNameChange(value) {
    setState(() {
      _name = value.trim();
    });
  }

  void _handleNameSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isSavingName = true;
    });

    var sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString('name', _name);

    User.name = _name;

    if (context.mounted) {
      Navigator.pushNamed(context, '/start');
    }

    setState(() {
      _isSavingName = false;
    });
  }

  @override
  void initState() {
    super.initState();
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
                (_name != '') ? '😄' : '😀',
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
                  height: 1.3333,
                  color: MyColors.heading,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _nameFormKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260),
                  child: TextField(
                    enabled: !_isSavingName,
                    onChanged: _handleNameChange,
                    onSubmitted: (_name != '')
                        ? (value) {
                            _handleNameSubmit();
                          }
                        : null,
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
                      fontVariations: <FontVariation>[
                        FontVariation('wght', 400)
                      ],
                      color: MyColors.textDark,
                    ),
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
                    enabled: (_name != '' && !_isSavingName),
                    onPressed: (_name != '' && !_isSavingName)
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
                              height: 1.35294117647,
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
