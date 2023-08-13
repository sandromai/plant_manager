import 'dart:ui';
import 'package:flutter/material.dart';

import '../styles/colors.dart';

import './select_plant.dart';
import './my_plants.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  static const routeName = '/userHome';

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                SelectPlantPage(),
                MyPlantsPage(),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 24,
            ),
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 50,
                  offset: const Offset(0, 4),
                ),
              ],
              color: Colors.white,
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: MyColors.green,
              unselectedLabelColor: MyColors.textLight,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              isScrollable: true,
              tabs: const <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      size: 20,
                      Icons.add_circle_outline,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Nova planta',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.66666666667,
                        fontVariations: <FontVariation>[
                          FontVariation('wght', 500)
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      size: 20,
                      Icons.list,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Minhas plantinhas',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.66666666667,
                        fontVariations: <FontVariation>[
                          FontVariation('wght', 500)
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
