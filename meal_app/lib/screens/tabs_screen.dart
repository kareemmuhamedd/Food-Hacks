import 'package:flutter/material.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/screens/categories_screen.dart';
import 'package:meal_app/screens/favorites_screen.dart';
import '../modules/meal.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = 'Tabs';


  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {

  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  void _selectedPage(int value) {
    setState(() {
      _selectedPageIndex = value;
    });
  }
  @override
  void initState() {
    super.initState();
    Provider.of<MealProvider>(context,listen: false).getMyFiltersData();
    Provider.of<MealProvider>(context,listen: false).getFavoriteData();
    Provider.of<MealProvider>(context,listen: false).getData();
    Provider.of<ThemeProvider>(context,listen: false).getThemeModeFromPrefs();
    Provider.of<ThemeProvider>(context,listen: false).getThemeColorsFromPrefs();
    Provider.of<LanguageProvider>(context,listen: false).getLang();
    //print('${Provider.of<MealProvider>(context,listen: true).isFirst}');

  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    _pages = [
      {
        'page': const CategoryScreen(),
        'title': lan.getTexts('categories'),
      },
      {
        'page': FavoritesScreen(),
        'title': lan.getTexts('your_favorites'),
      }
    ];
    return Directionality(
      textDirection: lan.isEng ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_pages[_selectedPageIndex]['title'].toString()),
        ),
        body: _pages[_selectedPageIndex]['page'] as Widget,
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectedPage,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.category),
              label: lan.getTexts('categories').toString(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              label: lan.getTexts('your_favorites').toString(),
            ),
          ],
        ),
        drawer: const MainDrawer(),
      ),
    );
  }
}
