import 'package:flutter/material.dart';
import 'package:meal_app/providers/language_provider.dart';
import 'package:meal_app/screens/filters_screen.dart';
import 'package:meal_app/screens/tabs_screen.dart';

import '../providers/theme_provider.dart';
import '../screens/theme_screen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  ListTile buildListTile(
      IconData icon, String title, Function() tapHandler, BuildContext ctx) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: Theme.of(ctx).iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(ctx).textTheme.bodyText1?.color,
          fontSize: 24,
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEng ? TextDirection.ltr : TextDirection.rtl,
      child: SafeArea(
        child: Drawer(
          elevation: 0,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment:
                      lan.isEng ? Alignment.centerLeft : Alignment.centerRight,
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  height: 120,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Text(
                    '${lan.getTexts('drawer_name')}',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                buildListTile(
                  Icons.restaurant,
                  '${lan.getTexts('drawer_item1')}',
                  () => Navigator.of(context)
                      .pushReplacementNamed(TabsScreen.routeName),
                  context,
                ),
                buildListTile(
                  Icons.settings,
                  '${lan.getTexts('drawer_item2')}',
                  () => Navigator.of(context)
                      .pushReplacementNamed(FiltersScreen.routeName),
                  context,
                ),
                buildListTile(
                  Icons.color_lens,
                  '${lan.getTexts('drawer_item3')}',
                  () => Navigator.of(context)
                      .pushReplacementNamed(ThemeScreen.routeName),
                  context,
                ),
                const Divider(color: Colors.black87, height: 10),
                Container(
                  alignment: lan.isEng ? Alignment.topLeft : Alignment.topRight,
                  padding: EdgeInsets.only(
                    right: (lan.isEng ? 0 : 15),
                    left: (lan.isEng ? 15 : 0),
                  ),
                  child: Text(
                    '${lan.getTexts('drawer_switch_title')}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          lan.getTexts('drawer_switch_item2').toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Switch(
                          activeColor: Theme.of(context).primaryColor,
                          value: Provider.of<LanguageProvider>(context,
                                  listen: true)
                              .isEng,
                          onChanged: (neaValue) {
                            Provider.of<LanguageProvider>(context,
                                    listen: false)
                                .changeLang(neaValue);
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(
                          lan.getTexts('drawer_switch_item1').toString(),
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ],
                    )),
                const Divider(height: 10, color: Colors.black87),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
