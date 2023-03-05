import 'package:flutter/material.dart';
import '../dummy_data.dart';
import '../modules/category.dart';
import '../modules/meal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealProvider with ChangeNotifier {
  Map<String, bool> filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> availableMeal = [];
  List<Category> availableCategory = [];
  List<String> prefsAva = [];
  List<Meal> aVA = [];
  bool isFirstOpenApp = false;

  void setFilters() async {
    availableMeal = DUMMY_MEALS.where((meal) {
      /// return false -> like don't add to my list
      if (filters['gluten']! && !meal.isGlutenFree) {
        return false;
      }
      if (filters['lactose']! && !meal.isLactoseFree) {
        return false;
      }
      if (filters['vegan']! && !meal.isVegan) {
        return false;
      }
      if (filters['vegetarian']! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();

    ///List<Category> avCAT = [];
    aVA = availableMeal;
    prefsAva.clear();
    for (var i in aVA) {
      if (!prefsAva.any((mealId) => mealId == i.id)) {
        prefsAva.add(i.id);
      }
    }

    // availableCategory = avCAT;
    // for (var meal in aVA) {
    //   for (var catID in meal.categories) {
    //     for (var cat in DUMMY_CATEGORIES) {
    //       if (cat.id == catID) {
    //         if (!avCAT.any((anyCat) => anyCat.id == catID)) {
    //           avCAT.add(cat);
    //         }
    //       }
    //     }
    //   }
    // }
    SharedPreferences setPrefs = await SharedPreferences.getInstance();
    setPrefs.setBool('gluten', filters['gluten']!);
    setPrefs.setBool('lactose', filters['lactose']!);
    setPrefs.setBool('vegan', filters['vegan']!);
    setPrefs.setBool('vegetarian', filters['vegetarian']!);
    setPrefs.setStringList('prefsAva', prefsAva);
    setPrefs.setBool('isFirstOpenApp', true);

    notifyListeners();
  }

  getData() async {
    SharedPreferences getPrefs = await SharedPreferences.getInstance();
    isFirstOpenApp = getPrefs.getBool('isFirstOpenApp') ?? false;
    prefsAva = getPrefs.getStringList('prefsAva') ?? []; // m1 m2 m3 m4
    for (var iD in prefsAva) {
      if (!availableMeal.any((element) => element.id == iD)) {
        availableMeal
            .add(DUMMY_MEALS.firstWhere((element) => element.id == iD));
      }
    }
    List<Meal> fm = [];
    for (var favMeals in favoritesMeals) {
      for (var avMeals in availableMeal) {
        if (favMeals.id == avMeals.id) {
          fm.add(favMeals);
        }
      }
    }
    favoritesMeals = fm;
    notifyListeners();
  }

  List<Meal> favoritesMeals = [];
  List<String> prefsMealId = [];

  void toggleFavorite(String mealId) async {
    SharedPreferences setPrefs = await SharedPreferences.getInstance();

    // take care that indexWhere will return -1 if the case not existing
    final existingIndex = favoritesMeals.indexWhere((meal) {
      return (meal.id == mealId);
    });
    if (existingIndex >= 0) {
      favoritesMeals.removeAt(existingIndex);
      prefsMealId.remove(mealId);
    }
    // i mean the returned value will = -1 if the case not existing
    else {
      favoritesMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      prefsMealId.add(mealId);
    }

    setPrefs.setStringList('prefsMealId', prefsMealId);
    notifyListeners();
  }

  void getMyFiltersData() async {
    SharedPreferences getPrefs = await SharedPreferences.getInstance();
    filters['gluten'] = getPrefs.getBool('gluten') ?? false;
    filters['lactose'] = getPrefs.getBool('lactose') ?? false;
    filters['vegan'] = getPrefs.getBool('vegan') ?? false;
    filters['vegetarian'] = getPrefs.getBool('vegetarian') ?? false;
    notifyListeners();
  }

  void getFavoriteData() async {
    SharedPreferences getPrefs = await SharedPreferences.getInstance();
    prefsMealId = getPrefs.getStringList('prefsMealId') ?? [];
    for (var mealID in prefsMealId) {
      final existingIndex =
          favoritesMeals.indexWhere((meal) => meal.id == mealID);
      if (existingIndex < 0) {
        favoritesMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealID));
      }
    }
    notifyListeners();
  }

  bool isMealFavorite(String mealId) {
    return favoritesMeals.any((meal) => meal.id == mealId);
  }
}
