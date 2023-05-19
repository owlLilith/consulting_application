import 'package:flutter/material.dart';
import '../screens/experience_category_screen.dart';
import "package:provider/provider.dart";

import '../provider/contributor_provider.dart';
import '../models/contributor.dart';

class homeTab extends StatefulWidget {
  @override
  State<homeTab> createState() => _homeTabState();
}

class _homeTabState extends State<homeTab> {
  Widget buildCard(BuildContext context, String image, String text) {
    var contributor = Provider.of<ContributorProvider>(context);
    return InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.pink,
        onTap: () {
          contributor.fetchContributors(text);
          Navigator.of(context)
              .pushNamed(experienceCategoryScreen.routeName, arguments: text);
        },
        child: Material(
          color: Color.fromARGB(144, 255, 255, 255),
          borderRadius: BorderRadius.circular(30),
          elevation: 12,
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color:
                          Color.fromARGB(255, 180, 226, 247).withOpacity(0.5))),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  const Padding(padding: EdgeInsets.all(6)),
                  Image.asset(
                    image,
                  ),
                  FittedBox(
                    child: Text(
                      text,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    Size size = query.size;
    var isLandscape = query.orientation == Orientation.landscape;

    return Center(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.pinkAccent.withOpacity(0.5),
                Colors.white,
                Colors.white
              ], begin: Alignment.bottomRight, end: Alignment.topLeft),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Text(
                      "What type of consultant you need ?",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView(
                    padding: const EdgeInsets.all(15),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: isLandscape
                            ? size.width * 0.25
                            : size.height * 0.25,
                        childAspectRatio: 1,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20),
                    children: [
                      buildCard(
                        context,
                        "assets/image/adminstrative.png",
                        ExperienceCategory.adminstrative.name.toString(),
                      ),
                      buildCard(
                        context,
                        "assets/image/family.png",
                        ExperienceCategory.family.name.toString(),
                      ),
                      buildCard(
                        context,
                        "assets/image/proffesional.png",
                        ExperienceCategory.proffesional.name.toString(),
                      ),
                      buildCard(
                        context,
                        "assets/image/medical.png",
                        ExperienceCategory.medical.name.toString(),
                      ),
                      buildCard(
                        context,
                        "assets/image/psychological.png",
                        ExperienceCategory.psychological.name.toString(),
                      ),
                      buildCard(
                        context,
                        "assets/image/all.png",
                        ExperienceCategory.all.name.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
