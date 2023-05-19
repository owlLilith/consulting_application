import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../screens/main_page.dart';

class skipScreen extends StatefulWidget {
  static const routeName = "/skip-screen";

  @override
  State<skipScreen> createState() => _skipScreenState();
}

class _skipScreenState extends State<skipScreen> {
  final _form = GlobalKey<FormState>();
  String? address;
  DateTime? birthday;
  String? phoneNumber;

  Widget buildTextFormField({
    IconData? icon,
    String label = "",
    FocusNode? node,
    TextInputAction? action,
    String? Function(String?)? submit,
    void Function(String?)? saved,
  }) {
    return SizedBox(
      child: TextFormField(
        decoration: InputDecoration(
            label: Text(label, style: const TextStyle(fontSize: 15)),
            prefixIcon: Icon(icon),
            border: const UnderlineInputBorder()),
        focusNode: node,
        textInputAction: action,
        onFieldSubmitted: submit,
        onSaved: saved,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    String? imagePath;
    void pickMedia() async {
      XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) {
        imagePath = file.path;
      }
    }

    void pickDate() {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000, 1, 1, 1, 1),
              lastDate: DateTime.now())
          .then((value) {
        setState(() {
          birthday = value!;
        });
      });
    }

    void confirm() {
      _form.currentState!.save();
      print(address);
      print(phoneNumber);
      print(birthday);
      Navigator.of(context).pushNamed(mainPage.routeName);
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Adding some extra info!",
        style: TextStyle(fontSize: 18),
      )),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Center(
              child: Container(
                alignment: Alignment.center,
                height: size.height * 0.5,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue)),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildTextFormField(
                          label: "enter your Address",
                          icon: Icons.location_on,
                          action: TextInputAction.next,
                          saved: (value) => setState(() {
                                address = value!;
                              })),
                      buildTextFormField(
                        label: "enter your Phone Number",
                        icon: Icons.perm_phone_msg_rounded,
                        action: TextInputAction.next,
                        saved: (value) => setState(() {
                          phoneNumber = value!;
                        }),
                      ),
                      ListTile(
                        title: const Text("select your birthday"),
                        subtitle: birthday != null
                            ? Text(DateFormat("EEE, M/d/y").format(birthday!))
                            : Text("you didn't select any date yet"),
                        trailing: IconButton(
                            tooltip: "select date",
                            onPressed: () => pickDate(),
                            icon: const Icon(Icons.calendar_month)),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
                height: size.height * 0.3,
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 70,
                  child: imagePath != null
                      ? Image.file(File(imagePath!))
                      : CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              AssetImage("assets/image/profile_picture.png"),
                          radius: 65,
                        ),
                )),
            Positioned(
              top: size.height * 0.2,
              left: size.width * 0.3,
              child: FloatingActionButton(
                tooltip: "add a photo to your profile picture",
                mini: true,
                onPressed: () {
                  pickMedia();
                },
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.66,
              right: size.width * 0.3,
              child: ElevatedButton(
                onPressed: confirm,
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.73,
              right: size.width * 0.35,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                splashColor: Colors.blue,
                onTap: () {
                  Navigator.of(context).pushNamed(mainPage.routeName);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Skip",
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(
                        Icons.keyboard_double_arrow_right_outlined,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
