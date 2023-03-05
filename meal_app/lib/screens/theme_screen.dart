import 'package:flutter/material.dart';
import 'package:meal_app/providers/theme_provider.dart';
import 'package:meal_app/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../providers/language_provider.dart';

class ThemeScreen extends StatelessWidget {
  final bool fromOnBoarding;

  ThemeScreen({this.fromOnBoarding = false});

  static const routeName = 'theme_screen';

  RadioListTile buildRadioListTile(
    ThemeMode themeVal,
    String txt,
    IconData ?icon,
    BuildContext context,
  ) {
    return RadioListTile(
      activeColor: Theme.of(context).colorScheme.secondary,
      secondary: Icon(icon, color: Theme.of(context).iconTheme.color),
      value: themeVal,
      groupValue: Provider.of<ThemeProvider>(context, listen: true).tm,
      onChanged: (newThemeVal) =>
          Provider.of<ThemeProvider>(context, listen: false)
              .themeModeChange(newThemeVal),
      title: Text(txt),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEng ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              elevation: fromOnBoarding ? 0 : 5,
              title: fromOnBoarding
                  ? null
                  : Text(lan.getTexts('theme_appBar_title').toString()),
              backgroundColor: fromOnBoarding
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).primaryColor,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  lan.getTexts('theme_screen_title').toString(),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  lan.getTexts('theme_mode_title').toString(),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              buildRadioListTile(
                ThemeMode.system,
                lan.getTexts('System_default_theme').toString(),
                null,
                context,
              ),
              buildRadioListTile(
                ThemeMode.light,
                lan.getTexts('light_theme').toString(),
                Icons.wb_sunny_outlined,
                context,
              ),
              buildRadioListTile(
                ThemeMode.dark,
                lan.getTexts('dark_theme').toString(),
                Icons.nights_stay_outlined,
                context,
              ),
              buildListTile(context, 'primary'),
              buildListTile(context, 'accent'),
              SizedBox(
                height: fromOnBoarding ? 500 : 0,
              )
            ]))
          ],
        ),
        drawer: fromOnBoarding ? null : const MainDrawer(),
      ),
    );
  }

  ListTile buildListTile(BuildContext context, txt) {
    var primaryColor =
        Provider.of<ThemeProvider>(context, listen: true).primaryColor;
    var accentColor =
        Provider.of<ThemeProvider>(context, listen: true).accentColor;
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return ListTile(
      title: Text(
          txt == "primary"
              ? lan.getTexts('primary').toString()
              : lan.getTexts('accent').toString(),
          style: Theme.of(context).textTheme.headline6),
      trailing: CircleAvatar(
        backgroundColor: txt == 'primary' ? primaryColor : accentColor,
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context2) {
              return AlertDialog(
                elevation: 4,
                titlePadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.all(0),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: txt == 'primary'
                        ? Provider.of<ThemeProvider>(context, listen: true)
                            .primaryColor
                        : Provider.of<ThemeProvider>(context, listen: true)
                            .accentColor,
                    onColorChanged: (Color newColor) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .onChanged(newColor, txt == 'primary' ? 1 : 2),
                    colorPickerWidth: 300,
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: false,
                    displayThumbColor: true,
                    labelTypes: const [
                      ColorLabelType.rgb,
                      ColorLabelType.hex,
                      ColorLabelType.hsv
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
