import 'package:flutter/material.dart';
import 'package:meal_app/providers/meal_provider.dart';

import '../modules/meal.dart';
import '../providers/language_provider.dart';
import '../widgets/meal_item.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Meal> favoritesMeals = Provider.of<MealProvider>(context).favoritesMeals;
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    var dW = MediaQuery.of(context).size.width;
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Scaffold(
      body: favoritesMeals.isEmpty
          ? Center(
              child: Text(lan.getTexts('favorites_text').toString()),
            )
          : GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: dW <= 400 ? 400 : 500,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: isLandscape ? dW / (dW * 0.80) : dW / (dW * 0.75),
          ),
              itemBuilder: (BuildContext context, int index) {
                return MealItem(
                  imageUrl: favoritesMeals[index].imageUrl,
                  id: favoritesMeals[index].id,
                  duration: favoritesMeals[index].duration,
                  affordability: favoritesMeals[index].affordability,
                  complexity: favoritesMeals[index].complexity,
                );
              },
              itemCount: favoritesMeals.length,
            ),
    );
  }
}
