import 'package:flutter/material.dart';
import 'package:meal_app/modules/meal.dart';
import 'package:meal_app/screens/meal_detaile_screen.dart';
import '../providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MealItem extends StatelessWidget {
  final String imageUrl;
  final String id;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;

  const MealItem({
    required this.imageUrl,
    required this.id,
    required this.duration,
    required this.affordability,
    required this.complexity,
  });

  void selectedMeal(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(MealDetailScreen.routeName, arguments: id);
  }

  checkInternetConnection() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return InkWell(
      onTap: () {
        selectedMeal(context);
        print(complexity);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Hero(
                      tag: id,
                      child: InteractiveViewer(
                        child: FadeInImage(
                          width: double.infinity,
                          fit: BoxFit.cover,
                          image: NetworkImage(imageUrl),
                          placeholder:
                          const AssetImage('assets/images/forall.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      color: Colors.black54,
                      width: 300,
                      child: Text(
                        lan.getTexts("meal-$id").toString(),
                        style: const TextStyle(fontSize: 26, color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(
                        width: 7,
                      ),
                      if (duration <= 10)
                        Text("$duration ${lan.getTexts("min2")}"),
                      if (duration > 10)
                        Text("$duration ${lan.getTexts("min")}"),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.work),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(lan.getTexts('$complexity').toString()),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.attach_money),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(lan.getTexts('$affordability').toString()),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
