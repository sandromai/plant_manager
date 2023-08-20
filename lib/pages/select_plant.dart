import 'dart:ui';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/colors.dart';

import '../context/user.dart';

import './home.dart';

class _Environment {
  final String key;
  final String title;

  const _Environment({required this.key, required this.title});

  factory _Environment.fromJSON(Map<String, dynamic> json) {
    return _Environment(
      key: json["key"],
      title: json["title"],
    );
  }
}

class _Frequency {
  final int times;
  final String repeatEvery;

  const _Frequency({required this.times, required this.repeatEvery});
}

class _Plant {
  final int id;
  final String name;
  final String about;
  final String waterTips;
  final String image;
  final List<String> environments;
  final _Frequency frequency;

  const _Plant({
    required this.id,
    required this.name,
    required this.about,
    required this.waterTips,
    required this.image,
    required this.environments,
    required this.frequency,
  });

  factory _Plant.fromJSON(Map<String, dynamic> json) {
    return _Plant(
      id: json["id"],
      name: json["name"],
      about: json["about"],
      waterTips: json["water_tips"],
      image: json["photo"],
      environments: List<String>.from(json["environments"]),
      frequency: _Frequency(
        times: json["frequency"]["times"],
        repeatEvery: json["frequency"]["repeat_every"],
      ),
    );
  }
}

class SelectPlantPage extends StatefulWidget {
  const SelectPlantPage({super.key});

  @override
  State<SelectPlantPage> createState() => _SelectPlantPageState();
}

class _SelectPlantPageState extends State<SelectPlantPage>
    with AutomaticKeepAliveClientMixin {
  String _selectedEnvironment = 'all';
  List<_Environment>? _environments;
  List<_Plant>? _plants;

  void _updateSelectedEnvironment(String environment) {
    if (_plants == null) {
      return;
    }

    if (environment != _selectedEnvironment) {
      setState(() => _selectedEnvironment = environment);
    }
  }

  Widget _environmentWidgetBuilder(BuildContext _, int index) {
    final environments = _environments;

    if (environments == null) {
      return Container(
        width: 76,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xfff5faf7),
              Color(0xfff0f0f0),
            ],
          ),
        ),
      );
    }

    return TextButton(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        padding: const MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.zero,
        ),
      ),
      onPressed: () {
        _updateSelectedEnvironment(
          environments[index].key,
        );
      },
      child: Ink(
        width: 76,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _selectedEnvironment == environments[index].key
              ? MyColors.greenLight
              : null,
          gradient: _selectedEnvironment != environments[index].key
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xfff5faf7),
                    Color(0xfff0f0f0),
                  ],
                )
              : null,
        ),
        child: Center(
          child: Text(
            environments[index].title,
            style: TextStyle(
              fontSize: 13,
              fontVariations: <FontVariation>[
                FontVariation(
                  'wght',
                  _selectedEnvironment == environments[index].key ? 600 : 400,
                ),
              ],
              height: 23 / 13,
              color: MyColors.greenDark,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPlantWidgets() {
    List<_Plant>? plants = _plants;

    if (plants != null && _selectedEnvironment != 'all') {
      plants = plants
          .where((plant) => plant.environments.contains(_selectedEnvironment))
          .toList();
    }

    List<Widget> plantWidgets = [];

    if (plants == null) {
      for (int i = 0; i < 3; ++i) {
        plantWidgets.add(
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: <Widget>[
              Container(
                width: 148,
                height: 154,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color(0xfff5faf7),
                      Color(0xfff0f0f0),
                    ],
                  ),
                ),
              ),
              Container(
                width: 148,
                height: 154,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color(0xfff5faf7),
                      Color(0xfff0f0f0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        if (i < 2) {
          plantWidgets.add(
            const SizedBox(height: 16),
          );
        }
      }
    } else {
      for (int i = 0, n = (plants.length / 2).ceil(); i < n; i += 2) {
        plantWidgets.add(
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: <Widget>[
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.zero,
                  ),
                ),
                onPressed: null,
                child: Ink(
                  width: 148,
                  height: 154,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xfff5faf7),
                        Color(0xfff0f0f0),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SvgPicture.network(
                          plants[i].image,
                          height: 89,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          plants[i].name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontVariations: <FontVariation>[
                              FontVariation('wght', 600),
                            ],
                            height: 23 / 13,
                            color: MyColors.heading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.zero,
                  ),
                ),
                onPressed: null,
                child: Ink(
                  width: 148,
                  height: 154,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xfff5faf7),
                        Color(0xfff0f0f0),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SvgPicture.network(
                          plants[i + 1].image,
                          height: 89,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          plants[i + 1].name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontVariations: <FontVariation>[
                              FontVariation('wght', 600),
                            ],
                            height: 23 / 13,
                            color: MyColors.heading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

        if (i < (n - 1)) {
          plantWidgets.add(
            const SizedBox(height: 16),
          );
        }
      }
    }

    return plantWidgets;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    if (User.name == null) {
      SharedPreferences.getInstance().then(
        (sharedPreferences) => sharedPreferences.remove('name'),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.routeName,
        (route) => false,
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 32,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Olá,',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 32,
                        fontVariations: <FontVariation>[
                          FontVariation('wght', 300)
                        ],
                        height: 1.125,
                        color: MyColors.heading,
                      ),
                    ),
                    Text(
                      User.name as String,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 32,
                        fontVariations: <FontVariation>[
                          FontVariation('wght', 600)
                        ],
                        height: 1.125,
                        color: MyColors.heading,
                      ),
                    ),
                  ],
                ),
                ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(28),
                    child: const Image(
                      image: AssetImage('assets/images/avatar.webp'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Em qual ambiente',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 17,
                    fontVariations: <FontVariation>[FontVariation('wght', 500)],
                    color: MyColors.heading,
                    height: 23 / 17,
                  ),
                ),
                Text(
                  'você quer colocar sua planta?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 17,
                    fontVariations: <FontVariation>[FontVariation('wght', 400)],
                    color: MyColors.heading,
                    height: 23 / 17,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter builderSetState) {
              if (_environments == null) {
                Future.delayed(
                  Duration(milliseconds: Random().nextInt(1850) + 150),
                  () =>
                      '[{"key": "living_room", "title": "Sala"},{"key": "bedroom", "title": "Quarto"},{"key": "kitchen", "title": "Cozinha"},{"key": "bathroom", "title": "Banheiro"}]',
                ).then((response) {
                  final parsedEnvironments = jsonDecode(response);

                  List<_Environment> environments = [
                    const _Environment(key: 'all', title: 'Todos'),
                  ];

                  for (int i = 0, n = parsedEnvironments.length; i < n; ++i) {
                    environments.add(
                      _Environment.fromJSON(parsedEnvironments[i]),
                    );
                  }

                  builderSetState(() => _environments = environments);
                });
              }

              return SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 32,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: (_environments == null)
                      ? 5
                      : _environments?.length as int,
                  itemBuilder: _environmentWidgetBuilder,
                  separatorBuilder: (_, __) => const SizedBox(width: 4),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter builderSetState) {
              if (_plants == null) {
                Future.delayed(
                  Duration(milliseconds: Random().nextInt(1850) + 150),
                  () =>
                      '[{"id":1,"name":"Aningapara","about":"É uma espécie tropical que tem crescimento rápido e fácil manuseio.","water_tips":"Mantenha a terra sempre úmida sem encharcar. Regue 2 vezes na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/1.svg","environments":["living_room","kitchen"],"frequency":{"times":2,"repeat_every":"week"}},{"id":2,"name":"Zamioculca","about":"Apesar de florescer na primavera, fica o ano todo bonita e verdinha. ","water_tips":"Utilize vasos com furos e pedras no fundo para facilitar a drenagem. Regue 1 vez no dia.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/2.svg","environments":["living_room","bedroom"],"frequency":{"times":1,"repeat_every":"day"}},{"id":3,"name":"Peperomia","about":"Adapta-se tanto ao sol e sombra, mas prefere ficar num cantinho fresco, sem sol direto. ","water_tips":"Nos dias mais quentes borrife água nas folhas. Regue 3 vezes na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/3.svg","environments":["bedroom"],"frequency":{"times":3,"repeat_every":"week"}},{"id":4,"name":"Imbé","about":"De médio porte que se adapta a diversas regiões, além de ser bem fácil de cultivar. Conquista cada vez mais pessoas.","water_tips":"Mantenha a terra sempre húmida sem encharcar. Regue 2 vezes na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/4.svg","environments":["bedroom","living_room"],"frequency":{"times":2,"repeat_every":"week"}},{"id":5,"name":"Espada São Jorge","about":"O aroma reduz os níveis de ansiedade e seu cheiro ajudar na qualidade do sono e a produtividade durante o dia.","water_tips":"Regue o solo ao redor. Regue 1 vez no dia.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/5.svg","environments":["bedroom","living_room"],"frequency":{"times":1,"repeat_every":"day"}},{"id":6,"name":"Yucca","about":"São indicadas pois são fáceis de manter e cuidar. Você colocar em pequenos vasos, ou até mesmo em xícaras.","water_tips":"Graças à reserva de água dessas verdinhas, é sempre melhor regar pouco. Regue 1 vez na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/6.svg","environments":["kitchen","bedroom"],"frequency":{"times":1,"repeat_every":"week"}},{"id":7,"name":"Frutíferas","about":"Exigem algumas horinhas de sol por dia, por isso deixe próximo a janelas.","water_tips":"Regue sempre na terra e não as folhas. Regue 3 vezes na semana","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/7.svg","environments":["kitchen","living_room"],"frequency":{"times":3,"repeat_every":"week"}},{"id":8,"name":"Orquídea","about":"Traz sensação de tranquilidade e paz ao ambiente. Requer pouca manutenção e ótima para quem tem pouco espaço.","water_tips":"Regue moderadamente. Reque 4 vezes na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/8.svg","environments":["bathroom"],"frequency":{"times":4,"repeat_every":"week"}},{"id":9,"name":"Violeta","about":"Com flores delicadas. Elas são ótimas sugestões para decorar o banheiro. ","water_tips":"Nada de molhar as flores e folhas. Regue o solo 2 vezes na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/3.svg","environments":["bathroom"],"frequency":{"times":2,"repeat_every":"week"}},{"id":10,"name":"Hortênsia","about":"A hortênsia é uma planta rústica e se adapta a diferentes tipos de solos.","water_tips":"Mantenha a terra sempre húmida sem encharcar. Regue 1 vez no dia.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/2.svg","environments":["bathroom"],"frequency":{"times":1,"repeat_every":"day"}}]',
                ).then((response) {
                  final parsedPlants = jsonDecode(response);

                  List<_Plant> plants = [];

                  for (int i = 0, n = parsedPlants.length; i < n; ++i) {
                    plants.add(
                      _Plant.fromJSON(parsedPlants[i]),
                    );
                  }

                  builderSetState(() => _plants = plants);
                });
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildPlantWidgets(),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
