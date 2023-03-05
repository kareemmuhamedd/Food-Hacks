import 'package:flutter/material.dart';
import 'package:meal_app/providers/meal_provider.dart';
import '../dummy_data.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = 'meal_detail';

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    Widget buildSectionTitle(BuildContext ctx, String section) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          section,
          style: Theme.of(ctx).textTheme.headline6,
        ),
      );
    }

    Widget buildSectionContent(Widget myChild) {
      bool isLandscape =
          MediaQuery.of(context).orientation == Orientation.landscape;
      var dW = MediaQuery.of(context).size.width;
      var dH = MediaQuery.of(context).size.height;
      return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Colors.grey)),
        height: isLandscape ? dH * 0.5 : dH * 0.25,
        width: isLandscape ? dW * 0.5 - 30 : dW,
        child: myChild,
      );
    }

    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mealId = ModalRoute.of(context)?.settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);
    List<String> stepsLi = lan.getTexts('steps-$mealId') as List<String>;
    List<String> liIngredientLi =
        lan.getTexts('ingredients-$mealId') as List<String>;
    Widget liIngredients = ListView.builder(
      padding: const EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              liIngredientLi[index],
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        );
      },
      itemCount: liIngredientLi.length,
    );
    Widget liSteps = ListView.builder(
      padding: const EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  '# ${index + 1}',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              title: Text(
                stepsLi[index],
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            const Divider()
          ],
        );
      },
      itemCount: stepsLi.length,
    );

    return Directionality(
      textDirection: lan.isEng ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(lan.getTexts('meal-$mealId').toString()),
                background: Hero(
                  tag: mealId,
                  child: InteractiveViewer(
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        selectedMeal.imageUrl,
                      ),
                      placeholder: const AssetImage('assets/images/forall.png'),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  isLandscape
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          buildSectionTitle(context,
                              lan.getTexts('Ingredients').toString()),
                          buildSectionContent(liIngredients),
                        ],
                      ),
                      Column(
                        children: [
                          buildSectionTitle(
                              context, lan.getTexts('Steps').toString()),
                          buildSectionContent(liSteps),
                        ],
                      )
                    ],
                  )
                      : Column(
                    children: [
                      buildSectionTitle(
                          context, lan.getTexts('Ingredients').toString()),
                      buildSectionContent(liIngredients),
                      buildSectionTitle(
                          context, lan.getTexts('Steps').toString()),
                      buildSectionContent(liSteps),
                    ],
                  ),
                  const SizedBox(height: 600,)
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<MealProvider>(context, listen: false)
                .toggleFavorite(mealId);
          },
          child: Icon(
            Icons.favorite,
            color: Provider.of<MealProvider>(context, listen: true)
                    .isMealFavorite(mealId)
                ? Colors.red
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
