import "package:flutter/material.dart";
import '../screens/book_screen.dart';
import '../models/contributor.dart';

import "package:intl/intl.dart";

class expertDetailsScreen extends StatefulWidget {
  static const routeName = "/expert-details-screen";

  @override
  State<expertDetailsScreen> createState() => _expertDetailsScreenState();
}

class _expertDetailsScreenState extends State<expertDetailsScreen> {
  bool isSelected1 = false;
  bool isSelected2 = false;
  bool isSelected3 = false;
  bool isSelected4 = false;
  final List<bool> _lighting = [false, false, false, false, false];

  List<bool> lighting(double num) {
    if (num > 0) _lighting[0] = true;
    for (int i = 1; i <= num.floor(); i++) {
      _lighting[i] = true;
    }
    return _lighting;
  }

  Widget buildRatingStar(bool isLighting) {
    return Icon(
      Icons.star,
      color: isLighting ? Colors.amber : Colors.blueGrey,
    );
  }

  Widget buildIcon(
      IconData icon, String data, void Function() selected, bool isSelected) {
    double width = MediaQuery.of(context).size.width;
    return ListTile(
      trailing: Transform(
          transform: Matrix4.translationValues((width - 100) * -1, 0, 0),
          child: FloatingActionButton(
            onPressed: selected,
            mini: true,
            child: Icon(icon),
          )),
      title: isSelected
          ? Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                      colors: [Colors.blue, Color.fromARGB(0, 33, 149, 243)])),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 4, left: 30, right: 4, top: 4),
                child: Text(
                  data,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          : null,
    );
  }

  void book(Contributor expert) {
    Navigator.of(context)
        .pushReplacementNamed(bookScreen.routeName, arguments: expert);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Contributor expert =
        ModalRoute.of(context)!.settings.arguments as Contributor;

    return Scaffold(
      appBar: AppBar(
        title: Text("${expert.name} Details"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  Center(child: Image.network(expert.imageUrl)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildIcon(
                          Icons.phone,
                          expert.phoneNumber,
                          () => setState(() {
                                isSelected1 = !isSelected1;
                              }),
                          isSelected1),
                      buildIcon(
                          Icons.email,
                          expert.email,
                          () => setState(() {
                                isSelected2 = !isSelected2;
                              }),
                          isSelected2),
                      if (expert.birthDay != null)
                        buildIcon(
                            Icons.cake,
                            DateFormat("EEE, M/d/y")
                                .format(expert.birthDay as DateTime),
                            () => setState(() {
                                  isSelected3 = !isSelected3;
                                }),
                            isSelected3),
                      buildIcon(
                          Icons.location_on,
                          expert.location,
                          () => setState(() {
                                isSelected4 = !isSelected4;
                              }),
                          isSelected4),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: lighting(expert.rate).map((item) {
                      return IconButton(
                          splashRadius: 20,
                          onPressed: () {},
                          icon: buildRatingStar(item));
                    }).toList(),
                  ),
                  const SizedBox(width: 15),
                  Text(expert.rate.toString())
                ],
              ),
              Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(expert.experienceCategory.name),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: size.width * 0.4,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Voice call",
                            style: TextStyle(letterSpacing: 2))),
                  ),
                  SizedBox(
                    width: size.width * 0.4,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: const FittedBox(
                          child: Text("Online Message",
                              style: TextStyle(letterSpacing: 2)),
                        )),
                  )
                ],
              ),
              Card(
                shape: Border.all(color: Colors.grey),
                color: Colors.blueGrey[100],
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                      title: Text("Details about ${expert.name} experience:"),
                      subtitle: Text(expert.consultingDetail)),
                ),
              ),
              ElevatedButton(
                  onPressed: () => book(expert), child: const Text("Book NOW!"))
            ],
          ),
        ),
      ),
    );
  }
}
