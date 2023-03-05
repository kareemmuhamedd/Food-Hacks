import 'package:flutter/material.dart';
import 'package:meal_app/providers/meal_provider.dart';
import 'package:meal_app/providers/theme_provider.dart';
import 'package:meal_app/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';

class FiltersScreen extends StatefulWidget {
  bool fromOnBoarding;

  FiltersScreen({this.fromOnBoarding = false});

  static const routeName = 'filters';

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  SwitchListTile buildSwitchListTile(
    BuildContext context,
    String text,
    String description,
    bool myVal,
    Function(bool) updateValue,
  ) {
    return SwitchListTile(
      title: Text(text),
      subtitle: Text(description),
      value: myVal,
      onChanged: updateValue,
      inactiveTrackColor:
          Provider.of<ThemeProvider>(context, listen: true).tm ==
                  ThemeMode.light
              ? null
              : Provider.of<ThemeProvider>(context, listen: true).tm ==
                      ThemeMode.system
                  ? null
                  : Colors.black,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, bool> currentFilter =
        Provider.of<MealProvider>(context, listen: true).filters;
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEng ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              title: widget.fromOnBoarding
                  ? null
                  : Text(lan.getTexts('theme_appBar_title').toString()),
              backgroundColor: widget.fromOnBoarding
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).primaryColor,
              elevation: widget.fromOnBoarding ? 0 : 5,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  lan.getTexts('filters_screen_title').toString(),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
              buildSwitchListTile(
                context,
                lan.getTexts('Gluten-free').toString(),
                lan.getTexts('Gluten-free-sub').toString(),
                currentFilter['gluten']!,
                (newValue) {
                  setState(() {
                    currentFilter['gluten'] = newValue;
                  });
                  Provider.of<MealProvider>(context, listen: false)
                      .setFilters();
                },
              ),
              buildSwitchListTile(
                context,
                lan.getTexts('Lactose-free').toString(),
                lan.getTexts('Lactose-free_sub').toString(),
                currentFilter['lactose']!,
                (newValue) {
                  setState(() {
                    currentFilter['lactose'] = newValue;
                  });
                  Provider.of<MealProvider>(context, listen: false)
                      .setFilters();
                },
              ),
              buildSwitchListTile(
                context,
                lan.getTexts('Vegan').toString(),
                lan.getTexts('Vegan-sub').toString(),
                currentFilter['vegan']!,
                (newValue) {
                  setState(() {
                    currentFilter['vegan'] = newValue;
                  });
                  Provider.of<MealProvider>(context, listen: false)
                      .setFilters();
                },
              ),
              buildSwitchListTile(
                context,
                lan.getTexts('Vegetarian').toString(),
                lan.getTexts('Vegetarian-sub').toString(),
                currentFilter['vegetarian']!,
                (newValue) {
                  setState(() {
                    currentFilter['vegetarian'] = newValue;
                  });
                  Provider.of<MealProvider>(context, listen: false)
                      .setFilters();
                },
              ),
              SizedBox(
                height: widget.fromOnBoarding ? 500 : 0,
              ),
            ]))
          ],
        ),
        drawer: widget.fromOnBoarding ? null : const MainDrawer(),
      ),
    );
  }
}
