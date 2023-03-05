import 'package:flutter/material.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/providers/theme_provider.dart';
import 'package:meal_app/screens/category_meals_screen.dart';
import 'package:meal_app/screens/filters_screen.dart';
import 'package:meal_app/screens/meal_detaile_screen.dart';
import 'package:meal_app/screens/on_boarding_screen.dart';
import 'package:meal_app/screens/tabs_screen.dart';
import 'package:meal_app/screens/theme_screen.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Widget homeScreen =
      prefs.getBool('watched')??false ? TabsScreen() : const OnBoardingScreen();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MealProvider>(
          create: (BuildContext ctx) => MealProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (BuildContext ctx) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (BuildContext ctx) => LanguageProvider(),
        )
      ],
      child: MyApp(homeScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget mainScreen;
  MyApp(this.mainScreen);

  @override
  Widget build(BuildContext context) {
    var primaryColor =
        Provider.of<ThemeProvider>(context, listen: true).primaryColor;
    var accentColor =
        Provider.of<ThemeProvider>(context, listen: true).accentColor;
    var tm = Provider.of<ThemeProvider>(context, listen: true).tm;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: tm,
      theme: ThemeData(
        buttonTheme: const ButtonThemeData(buttonColor: Colors.black87),
        primarySwatch: primaryColor,
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'RaleWay',
        cardColor: Colors.white,
        shadowColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.black87),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor)
            .copyWith(secondary: accentColor),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: const TextStyle(
                color: Color.fromRGBO(20, 50, 50, 1),
              ),
              headline6: const TextStyle(
                color: Colors.black87,
                fontSize: 21,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
              subtitle2: const TextStyle(fontSize: 16),
            ),
      ),
      darkTheme: ThemeData(
        primarySwatch: primaryColor,
        canvasColor: const Color.fromRGBO(14, 22, 33, 1),
        fontFamily: 'RaleWay',
        cardColor: const Color.fromRGBO(35, 34, 39, 1),
        buttonTheme: const ButtonThemeData(buttonColor: Colors.black87),
        shadowColor: Colors.white70,
        iconTheme: const IconThemeData(color: Colors.white70),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor)
            .copyWith(secondary: accentColor),
        unselectedWidgetColor: Colors.white70,
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText1: const TextStyle(
                color: Colors.white70,
              ),
              headline6: const TextStyle(
                color: Colors.white70,
                fontSize: 21,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              ),
              subtitle2: const TextStyle(fontSize: 16),
            ),
      ),
      //home: const MYHomePage(),
      //home: const CategoryScreen(),
      routes: {
        '/': (context) => AnimatedSplashScreen(
            duration: 300,
            splash: Container(
              color: Colors.orange,
              child: const Icon(
                Icons.fastfood_outlined,
                size: 90,
              ),
            ),
            nextScreen: mainScreen,
            splashTransition: SplashTransition.rotationTransition,
            backgroundColor: Colors.orange),
        // '/' = home so it is instead of home
        CategoryMealsScreen.routeName: (context) => CategoryMealsScreen(),
        MealDetailScreen.routeName: (context) => MealDetailScreen(),
        FiltersScreen.routeName: (context) => FiltersScreen(),
        ThemeScreen.routeName: (context) => ThemeScreen(),
        TabsScreen.routeName: (context) => TabsScreen(),
      },
    );
  }
}
