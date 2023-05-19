import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import '../models/contributor.dart';

class bookScreen extends StatefulWidget {
  static const String routeName = "/book-screen";

  @override
  State<bookScreen> createState() => _bookScreenState();
}

class _bookScreenState extends State<bookScreen> {
  Map<DateTime, List<double>> choosenDates = {};

  @override
  Widget build(BuildContext context) {
    var expert = ModalRoute.of(context)!.settings.arguments as Contributor;

    void confirm() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Successfully added"),
        action: SnackBarAction(
          label: "OKEY",
          onPressed: () {},
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "book an appointment with ${expert.name}",
          style: TextStyle(fontSize: 12),
        ),
      ),
      body: Container(
        color: Color.fromARGB(101, 96, 125, 139),
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "to book an appointment choose your suitable dates from ${expert.name} available times : ",
              style: TextStyle(fontSize: 18),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 1, top: 15),
              height: 125,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: expert.availableDates!.keys.map((day) {
                  return FloatingActionButton(
                    elevation: choosenDates.containsKey(day) ? 12 : 0,
                    splashColor: Colors.amber,
                    backgroundColor: choosenDates.containsKey(day)
                        ? Colors.amberAccent
                        : Colors.grey,
                    onPressed: () {
                      setState(() {
                        if (choosenDates.containsKey(day)) {
                          choosenDates.remove(day);
                        } else {
                          choosenDates.putIfAbsent(
                            day,
                            () => [
                              30,
                              double.parse(expert.availableDates![day]!
                                  .elementAt(0)
                                  .toString()),
                            ],
                          );
                        }
                      });
                    },
                    child: Text(DateFormat("EEE").format(day),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: choosenDates.containsKey(day)
                                ? Colors.grey
                                : Colors.amberAccent)),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView(
                children: expert.availableDates!.keys.map((day) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          elevation: choosenDates.containsKey(day) ? 12 : 0,
                          splashColor: Colors.amber,
                          color: choosenDates.containsKey(day)
                              ? Colors.amberAccent
                              : Color.fromARGB(0, 255, 255, 255),
                          onPressed: () {
                            setState(() {
                              if (choosenDates.containsKey(day)) {
                                choosenDates.remove(day);
                              } else {
                                choosenDates.putIfAbsent(
                                  day,
                                  () => [
                                    30,
                                    double.parse(expert.availableDates![day]!
                                        .elementAt(0)
                                        .toString()),
                                  ],
                                );
                              }
                            });
                          },
                          child: ListTile(
                            leading: Card(
                              elevation: 12,
                              color: const Color.fromARGB(156, 255, 255, 255),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat('EEE, M/d/y').format(day),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            title: Text(
                              "from ${expert.availableDates![day]!.elementAt(0)} to ${expert.availableDates![day]!.elementAt(1)}",
                              maxLines: 1,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        if (choosenDates.containsKey(day))
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(140, 255, 255, 255),
                                border: Border.all(color: Colors.amberAccent)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text("Duration :"),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      splashRadius: 15,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_up_sharp,
                                      ),
                                      onPressed: () {
                                        if (choosenDates[day]!.first <= 90) {
                                          setState(() {
                                            choosenDates.update(
                                                day,
                                                (value) => [
                                                      choosenDates[day]!.first +
                                                          30,
                                                      choosenDates[day]!.last
                                                    ]);
                                          });
                                        }
                                      },
                                    ),
                                    Text("${choosenDates[day]!.first} min"),
                                    IconButton(
                                      splashRadius: 15,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                      ),
                                      onPressed: () {
                                        if (choosenDates[day]!.first >= 60) {
                                          setState(() {
                                            choosenDates.update(
                                                day,
                                                (value) => [
                                                      choosenDates[day]!.first -
                                                          30,
                                                      choosenDates[day]!.last
                                                    ]);
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 20,
                                  thickness: 2,
                                ),
                                const Text("Starting at :"),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      splashRadius: 15,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_up_sharp,
                                      ),
                                      onPressed: () {
                                        if (choosenDates[day]!.last <
                                            expert.availableDates![day]!.last -
                                                choosenDates[day]!.first / 60) {
                                          setState(() {
                                            choosenDates.update(
                                                day,
                                                (value) => [
                                                      choosenDates[day]!.first,
                                                      choosenDates[day]!.last +
                                                          choosenDates[day]!
                                                                  .first /
                                                              60,
                                                    ]);
                                          });
                                        }
                                      },
                                    ),
                                    Text(choosenDates[day]!.last.toString()),
                                    IconButton(
                                      splashRadius: 15,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                      ),
                                      onPressed: () {
                                        if (choosenDates[day]!.last >
                                            expert.availableDates![day]!
                                                .elementAt(0)) {
                                          setState(() {
                                            choosenDates.update(
                                                day,
                                                (value) => [
                                                      choosenDates[day]!.first,
                                                      choosenDates[day]!.last -
                                                          choosenDates[day]!
                                                                  .first /
                                                              60,
                                                    ]);
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title:
                              const Text("Are you sure you want to Continue?"),
                          content: Text(
                              "this consulting will cost you \$${expert.consultingCost} only per hour"),
                          actions: [
                            TextButton(
                              child: const Text("Denied",
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                            TextButton(
                              child: const Text("Confirm"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                confirm();
                              },
                            ),
                          ],
                        );
                      });
                },
                child: const Text("Book NOW!"))
          ],
        ),
      ),
    );
  }
}
