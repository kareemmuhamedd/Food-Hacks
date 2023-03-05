import 'package:flutter/material.dart';
import '../dummy_data.dart';
import '../modules/meal.dart';
import '../providers/language_provider.dart';
import '../providers/meal_provider.dart';
import '../widgets/meal_item.dart';
import 'package:provider/provider.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = 'category_Meals';

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  List<Meal>? displayedMeal;
  String categoryId = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final List<Meal> availableMeal =
        Provider.of<MealProvider>(context, listen: true).isFirstOpenApp == false
            ? DUMMY_MEALS
            : Provider.of<MealProvider>(context, listen: true).availableMeal;
    final routeArg =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    categoryId = routeArg['id']!;

    //i use widget. because _availableMeal created as global out state
    displayedMeal = availableMeal.where((element) {
      return element.categories.contains(categoryId);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var dW = MediaQuery.of(context).size.width;
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEng ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${lan.getTexts('cat-$categoryId')}'),
        ),
        body: GridView.builder(
          itemBuilder: (BuildContext context, int index) {
            return MealItem(
              imageUrl: displayedMeal![index].imageUrl,
              id: displayedMeal![index].id,
              duration: displayedMeal![index].duration,
              affordability: displayedMeal![index].affordability,
              complexity: displayedMeal![index].complexity,
            );
          },
          itemCount: displayedMeal!.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: dW <= 400 ? 400 : 500,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: isLandscape ? dW / (dW * 0.80) : dW / (dW * 0.75),
          ),
        ),
      ),
    );
  }
}
