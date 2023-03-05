import 'package:flutter/material.dart';
import 'package:meal_app/providers/theme_provider.dart';
import 'package:meal_app/screens/filters_screen.dart';
import 'package:meal_app/screens/tabs_screen.dart';
import 'package:meal_app/screens/theme_screen.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //var primaryColor = Provider.of<ThemeProvider>(context).primaryColor;
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              isLandscape
                  ? SingleChildScrollView(
                      child: Container(
                        color: Colors.orange,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(70),
                              child: Image.asset(
                                'assets/images/meal.png',
                              ),
                            ),
                            const Text(
                              'Food Hacks',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.orange,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(70),
                            child: Image.asset(
                              'assets/images/meal.png',
                            ),
                          ),
                          const Text(
                            'Food Hacks',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    lan.getTexts('drawer_switch_item2').toString(),
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                  Switch(
                                    value:
                                    Provider.of<LanguageProvider>(context, listen: true)
                                        .isEng,
                                    onChanged: (neaValue) {
                                      Provider.of<LanguageProvider>(context, listen: false)
                                          .changeLang(neaValue);
                                    },
                                    inactiveTrackColor:
                                    Provider.of<ThemeProvider>(context, listen: true)
                                        .tm ==
                                        ThemeMode.light
                                        ? null
                                        : Colors.black,
                                  ),
                                  Text(
                                    lan.getTexts('drawer_switch_item1').toString(),
                                    style: Theme.of(context).textTheme.headline6,
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
              ThemeScreen(fromOnBoarding: true),
              FiltersScreen(fromOnBoarding: true),
            ],
            onPageChanged: (val) {
              setState(() {
                currentIndex = val;
              });
            },
          ),
          Indicator(currentIndex),
          Builder(
            builder: (BuildContext ctx) => Align(
              alignment: const Alignment(0, 0.85),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        lan.getTexts('start').toString(),
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(ctx)
                          .pushReplacementNamed(TabsScreen.routeName);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('watched', true);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final int index;

  Indicator(this.index);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDots(context, 0),
            buildDots(context, 1),
            buildDots(context, 2),
          ],
        ),
      ),
    );
  }

  Widget buildDots(BuildContext ctx, int i) {
    return index == i
        ? const Icon(
            Icons.fastfood,
            color: Colors.black,
            size: 30,
          )
        : Container(
            margin: const EdgeInsets.all(4),
            height: 15,
            width: 15,
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
          );
  }
}
