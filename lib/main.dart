import 'package:flutter/material.dart';
import 'package:meals/screens/meal_detail_screen.dart';
import 'package:meals/screens/tabs_creen.dart';
// import 'screens/categories_screen.dart';
import 'screens/categories_meals_screen.dart';
import 'utils/app-routes.dart';
import 'screens/settings_screen.dart';
import 'models/meal.dart';
import 'data/dummy-data.dart';
import 'package:meals/models/settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Settings settings = Settings();
  List<Meal> _avaliableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _filterMeals(Settings settings) {
    this.settings = settings;
    _avaliableMeals = DUMMY_MEALS.where((meal) {
      final filterGluten = settings.isGlutenFree && !meal.isGlutenFree;
      final filterLactose = settings.isLactoseFree && !meal.isLactoseFree;
      final filterVegan = settings.isVegan && !meal.isVegan;
      final filterVegetarian = settings.isVegetarian && !meal.isVegetarian;
      return !filterGluten &&
          !filterLactose &&
          !filterVegan &&
          !filterVegetarian;
    }).toList();
  }

  void _toogleFavorite(Meal meal) {
    setState(() {
      _favoriteMeals.contains(meal)
          ? _favoriteMeals.remove(meal)
          : _favoriteMeals.add(meal);
    });
  }

  bool _isFavorite(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vamos Cozinhar?',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
          fontFamily: 'Raleway',
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
              ))),
      routes: {
        AppRoutes.HOME: (context) => TabsScreen(_favoriteMeals),
        AppRoutes.CATEGORIES_MEALS: (ctx) =>
            CategoriesMealsScreen(_avaliableMeals),
        AppRoutes.MEAL_DETAIL: (ctx) => MealDetailScreen(
              _toogleFavorite,
              _isFavorite,
            ),
        AppRoutes.SETTINGS: (ctx) => SettingsScreen(settings, _filterMeals)
      },
    );
  }
}
