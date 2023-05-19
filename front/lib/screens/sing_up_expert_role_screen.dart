import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import '../provider/auth_provider.dart';
import '../screens/skip_screen.dart';
import 'package:provider/provider.dart';
import '../models/contributor.dart';

class signupExpertRoleScreen extends StatefulWidget {
  static const routeName = "/sign-up-expert-role-screen";
  @override
  State<signupExpertRoleScreen> createState() => _signupExpertRoleScreenState();
}

class _signupExpertRoleScreenState extends State<signupExpertRoleScreen> {
  bool isLoading = false;
  int tabIndex = 0;
  Enum experienceCategory = ExperienceCategory.anoun;
  Map<DateTime, List<int>> availableDates = {};
  String? consultingDetails;
  int? consultCost;
  String? phoneNumber;
  bool show = false;

  Map<Enum, bool> category = {
    ExperienceCategory.adminstrative: false,
    ExperienceCategory.family: false,
    ExperienceCategory.medical: false,
    ExperienceCategory.proffesional: false,
    ExperienceCategory.psychological: false,
  };

  Map<DateTime, List<int>> week = {};
  List<DateTime> SelectedAvailableDates = [];

  @override
  void initState() {
    week = {
      DateTime.now(): [0, 7, 9],
      DateTime.now().add(const Duration(days: 1)): [0, 7, 9],
      DateTime.now().add(const Duration(days: 2)): [0, 7, 9],
      DateTime.now().add(const Duration(days: 3)): [0, 7, 9],
      DateTime.now().add(const Duration(days: 4)): [0, 7, 9],
      DateTime.now().add(const Duration(days: 5)): [0, 7, 9],
      DateTime.now().add(const Duration(days: 6)): [0, 7, 9],
    };
    super.initState();
  }

  Widget buildCard(String image, Enum text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: () {
            setState(() {
              for (Enum i in category.keys) {
                if (i == text) {
                  if (category[i]!) {
                    category.update(i, (value) => false);
                  } else {
                    category.update(i, (value) => true);
                  }
                } else {
                  category.update(i, (value) => false);
                }
              }
            });
          },
          child: Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 4,
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color:
                        category[text] == true ? Colors.amber : Colors.white),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    const Padding(padding: EdgeInsets.all(3)),
                    Image.asset(
                      image,
                    ),
                    FittedBox(
                        child: Text(text.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)))
                  ],
                )),
          )),
    );
  }

  Widget buildTextFormField({
    String label = "",
    FocusNode? node,
    String? Function(String?)? validate,
    TextInputAction? action,
    String? Function(String?)? submit,
    void Function(String?)? saved,
    TextEditingController? control,
    int? linesNumber,
  }) {
    return SizedBox(
      child: TextFormField(
          maxLines: linesNumber,
          controller: control,
          decoration: InputDecoration(
              border: const UnderlineInputBorder(), label: Text(label)),
          focusNode: node,
          validator: validate,
          textInputAction: action,
          onFieldSubmitted: submit,
          onSaved: saved),
    );
  }

  @override
  Widget build(BuildContext context) {
    var map = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    var auth = Provider.of<authProvider>(context);
    var size = MediaQuery.of(context).size;

    final _form = GlobalKey<FormState>();

    FocusNode phoneNumberField = FocusNode();

    String? validateConsultingDetails(String? value) {
      // if (value!.length < 10)
      //   return "the consulting details is too short, provide more information";
      if (value!.isEmpty)
        return "provide more details about your consulting experience";
      return null;
    }

    String? validateConsultingCost(String? value) {
      if (value!.isEmpty) return "you must detarmine your consulting price";
      return null;
    }

    String? validatePhoneNumber(String? value) {
      if (value!.isEmpty) return "provide your phone number";
      return null;
    }

    void confirm() {
      setState(() {
        isLoading = true;
      });

      try{
      availableDates = {};
      var isValid = _form.currentState!.validate();

      for (var i in category.keys) {
        if (category[i] == true) {
          setState(() {
            experienceCategory = i;
          });
          break;
        }
      }

      for (var i in week.keys) {
        setState(() {
          availableDates.putIfAbsent(
              i, () => [week[i]!.first, week[i]!.elementAt(1), week[i]!.last]);
        });
      }

      _form.currentState!.save();

      
        auth
            .signupExpert(
          map["name"]!,
          map["email"]!,
          map["password"]!,
          map["role"]!,
          map["gender"]!,
          experienceCategory.name,
          consultingDetails!,
          consultCost!,
          phoneNumber!,
          "address",
          availableDates,
        )
            .then((value) {
          setState(() {
            isLoading = false;
          });
        });
      Navigator.of(context).pushReplacementNamed(skipScreen.routeName);

      } catch (error) {
        setState(() {
          isLoading = false;
        });
      }
    }

    var form = Form(
      key: _form,
      child: Column(
        children: [
          buildTextFormField(
              label: "enter informetion about your Consulting",
              linesNumber: 3,
              validate: validateConsultingDetails,
              action: TextInputAction.newline,
              saved: (value) {
                setState(() {
                  consultingDetails = value!;
                });
              }),
          buildTextFormField(
              linesNumber: 1,
              label: "enter your Consulte Cost",
              validate: validateConsultingCost,
              action: TextInputAction.next,
              submit: (value) {
                FocusScope.of(context).requestFocus(phoneNumberField);
              },
              saved: (value) {
                setState(() {
                  consultCost = int.parse(value!);
                });
              }),
          buildTextFormField(
              linesNumber: 1,
              label: "enter your Phone number",
              validate: validatePhoneNumber,
              action: TextInputAction.next,
              node: phoneNumberField,
              saved: (value) {
                setState(() {
                  phoneNumber = value!;
                });
              }),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit your informetion"),
      ),
      body: Container(
        height: size.height,
        margin: const EdgeInsets.all(15),
        child: ListView(
          children: [
            const Center(child: Text("choose you experience category")),
            SizedBox(
              height: size.height * 0.3,
              child: Center(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: size.width * 0.25,
                    childAspectRatio: 1,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  children: category.keys
                      .map((e) => buildCard("assets/image/${e.name}.png", e))
                      .toList(),
                ),
              ),
            ),
            if (show)
              const Text("please selecte one of the categories",
                  style: TextStyle(color: Colors.red)),
            form,
            Container(
              padding: const EdgeInsets.only(bottom: 1, top: 15),
              height: 125,
              width: 400,
              child: GridView(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 70,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 5,
                ),
                children: week.keys.map((day) {
                  return FloatingActionButton(
                    backgroundColor:
                        week[day]!.first == 1 ? Colors.amber : Colors.white,
                    onPressed: () => setState(() {
                      week.update(
                          day,
                          (v) => [
                                v.first == 1 ? 0 : 1,
                                week[day]!.elementAt(1),
                                week[day]!.last
                              ]);
                      if (SelectedAvailableDates.contains(day)) {
                        SelectedAvailableDates.remove(day);
                      } else {
                        SelectedAvailableDates.add(day);
                      }
                    }),
                    elevation: week[day]!.first == 1 ? 12 : 0,
                    child: Text(DateFormat("EEE").format(day),
                        style: TextStyle(
                            color: week[day]!.first == 1
                                ? Colors.white
                                : Colors.black)),
                  );
                }).toList(),
              ),
            ),
            if (show)
              Text("please add one available day at least",
                  style: TextStyle(color: Colors.red)),
            if (SelectedAvailableDates.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 18),
                child: Center(child: Text("you didn't select any date yet!")),
              )
            else
              SizedBox(
                height: 120 *
                    double.parse(SelectedAvailableDates.length.toString()),
                child: Column(
                  children: SelectedAvailableDates.map((e) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              DateFormat("EEE").format(e),
                            ),
                          ),
                          const Text("from"),
                          Column(
                            children: [
                              IconButton(
                                splashRadius: 20,
                                onPressed: () => setState(() {
                                  if (week[e]!.elementAt(1) < 24) {
                                    setState(() {
                                      week.update(
                                          e,
                                          (value) => [
                                                value.first,
                                                value.elementAt(1) + 1,
                                                value.last
                                              ]);
                                    });
                                  }
                                }),
                                icon: const Icon(Icons.keyboard_arrow_up_sharp),
                              ),
                              Text(week[e]!.elementAt(1).toString()),
                              IconButton(
                                splashRadius: 20,
                                onPressed: () => setState(() {
                                  if (week[e]!.elementAt(1) > 1) {
                                    setState(() {
                                      week.update(
                                          e,
                                          (value) => [
                                                value.first,
                                                value.elementAt(1) - 1,
                                                value.last
                                              ]);
                                    });
                                  }
                                }),
                                icon:
                                    const Icon(Icons.keyboard_arrow_down_sharp),
                              )
                            ],
                          ),
                          const Text("to"),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () => setState(() {
                                  if (week[e]!.last < 24) {
                                    setState(() {
                                      week.update(
                                          e,
                                          (value) => [
                                                value.first,
                                                value.elementAt(1),
                                                value.last + 1
                                              ]);
                                    });
                                  }
                                }),
                                icon: const Icon(Icons.keyboard_arrow_up_sharp),
                              ),
                              Text(week[e]!.last.toString()),
                              IconButton(
                                onPressed: () => setState(() {
                                  if (week[e]!.last > 1) {
                                    setState(() {
                                      week.update(
                                          e,
                                          (value) => [
                                                value.first,
                                                value.elementAt(1),
                                                value.last - 1
                                              ]);
                                    });
                                  }
                                }),
                                icon:
                                    const Icon(Icons.keyboard_arrow_down_sharp),
                              )
                            ],
                          ),
                        ]);
                  }).toList(),
                ),
              ),
            if (isLoading == true)
              const Center(child: CircularProgressIndicator())
            else
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.32, right: size.width * 0.32),
                child: ElevatedButton(
                  onPressed: confirm,
                  child: const Text("Confirm"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
