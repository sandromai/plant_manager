import 'dart:ui';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles/colors.dart';

import '../context/user.dart';

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
  late String userName;
  List<_Environment>? _environments;
  List<_Plant>? _plants;

  Future<void> _loadEnvironments() async {
    final response = await Future.delayed(
      Duration(milliseconds: Random().nextInt(1850) + 150),
      () =>
          '[{"key": "living_room", "title": "Sala"},{"key": "bedroom", "title": "Quarto"},{"key": "kitchen", "title": "Cozinha"},{"key": "bathroom", "title": "Banheiro"}]',
    );

    final parsedEnvironments = jsonDecode(response);

    List<_Environment> environments = [
      const _Environment(key: 'all', title: 'Todos'),
    ];

    for (int i = 0, n = parsedEnvironments.length; i < n; ++i) {
      environments.add(
        _Environment.fromJSON(parsedEnvironments[i]),
      );
    }

    setState(() {
      _environments = environments;
    });
  }

  Future<void> _loadPlants() async {
    final response = await Future.delayed(
      Duration(milliseconds: Random().nextInt(1850) + 150),
      () =>
          '[{"id":1,"name":"Aningapara","about":"É uma espécie tropical que tem crescimento rápido e fácil manuseio.","water_tips":"Mantenha a terra sempre úmida sem encharcar. Regue 2 vezes na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/1.svg","environments":["living_room","kitchen"],"frequency":{"times":2,"repeat_every":"week"}},{"id":2,"name":"Zamioculca","about":"Apesar de florescer na primavera, fica o ano todo bonita e verdinha. ","water_tips":"Utilize vasos com furos e pedras no fundo para facilitar a drenagem. Regue 1 vez no dia.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/2.svg","environments":["living_room","bedroom"],"frequency":{"times":1,"repeat_every":"day"}},{"id":3,"name":"Peperomia","about":"Adapta-se tanto ao sol e sombra, mas prefere ficar num cantinho fresco, sem sol direto. ","water_tips":"Nos dias mais quentes borrife água nas folhas. Regue 3 vezes na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/3.svg","environments":["bedroom"],"frequency":{"times":3,"repeat_every":"week"}},{"id":4,"name":"Imbé","about":"De médio porte que se adapta a diversas regiões, além de ser bem fácil de cultivar. Conquista cada vez mais pessoas.","water_tips":"Mantenha a terra sempre húmida sem encharcar. Regue 2 vezes na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/4.svg","environments":["bedroom","living_room"],"frequency":{"times":2,"repeat_every":"week"}},{"id":5,"name":"Espada São Jorge","about":"O aroma reduz os níveis de ansiedade e seu cheiro ajudar na qualidade do sono e a produtividade durante o dia.","water_tips":"Regue o solo ao redor. Regue 1 vez no dia.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/5.svg","environments":["bedroom","living_room"],"frequency":{"times":1,"repeat_every":"day"}},{"id":6,"name":"Yucca","about":"São indicadas pois são fáceis de manter e cuidar. Você colocar em pequenos vasos, ou até mesmo em xícaras.","water_tips":"Graças à reserva de água dessas verdinhas, é sempre melhor regar pouco. Regue 1 vez na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/6.svg","environments":["kitchen","bedroom"],"frequency":{"times":1,"repeat_every":"week"}},{"id":7,"name":"Frutíferas","about":"Exigem algumas horinhas de sol por dia, por isso deixe próximo a janelas.","water_tips":"Regue sempre na terra e não as folhas. Regue 3 vezes na semana","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/7.svg","environments":["kitchen","living_room"],"frequency":{"times":3,"repeat_every":"week"}},{"id":8,"name":"Orquídea","about":"Traz sensação de tranquilidade e paz ao ambiente. Requer pouca manutenção e ótima para quem tem pouco espaço.","water_tips":"Regue moderadamente. Reque 4 vezes na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/8.svg","environments":["bathroom"],"frequency":{"times":4,"repeat_every":"week"}},{"id":9,"name":"Violeta","about":"Com flores delicadas. Elas são ótimas sugestões para decorar o banheiro. ","water_tips":"Nada de molhar as flores e folhas. Regue o solo 2 vezes na semana.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/3.svg","environments":["bathroom"],"frequency":{"times":2,"repeat_every":"week"}},{"id":10,"name":"Hortênsia","about":"A hortênsia é uma planta rústica e se adapta a diferentes tipos de solos.","water_tips":"Mantenha a terra sempre húmida sem encharcar. Regue 1 vez no dia.","photo":"https://storage.googleapis.com/golden-wind/nextlevelweek/05-plantmanager/2.svg","environments":["bathroom"],"frequency":{"times":1,"repeat_every":"day"}}]',
    );

    final parsedPlants = jsonDecode(response);

    List<_Plant> plants = [];

    for (int i = 0, n = parsedPlants.length; i < n; ++i) {
      plants.add(
        _Plant.fromJSON(parsedPlants[i]),
      );
    }

    setState(() {
      _plants = plants;
    });
  }

  List<Widget> _buildEnvironmentWidgets() {
    final environments = _environments;

    List<Widget> environmentWidgets = [];

    if (environments == null) {
      for (int i = 0; i < 5; ++i) {
        if (i > 0) {
          environmentWidgets.add(
            const SizedBox(width: 4),
          );
        }

        environmentWidgets.add(
          const Text('Loading'),
        );
      }
    } else {
      for (int i = 0, n = environments.length; i < n; ++i) {
        if (i > 0) {
          environmentWidgets.add(
            const SizedBox(width: 4),
          );
        }

        environmentWidgets.add(
          Text(environments[i].title),
        );
      }
    }

    return environmentWidgets;
  }

  List<Widget> _buildPlantWidgets() {
    print(_plants);

    return [];
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
        '/home',
        (route) => false,
      );
    }

    userName = User.name as String;

    super.initState();

    _loadEnvironments();
    _loadPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                        userName,
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
            const SizedBox(
              height: 40,
            ),
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
                      fontVariations: <FontVariation>[
                        FontVariation('wght', 500)
                      ],
                      color: MyColors.heading,
                      height: 1.35294117647,
                    ),
                  ),
                  Text(
                    'você quer colocar sua planta?',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 17,
                      fontVariations: <FontVariation>[
                        FontVariation('wght', 400)
                      ],
                      color: MyColors.heading,
                      height: 1.35294117647,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 32),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildEnvironmentWidgets(),
              ),
            ),
            ..._buildPlantWidgets(),
          ],
        ),
      ),
    );
  }
}
