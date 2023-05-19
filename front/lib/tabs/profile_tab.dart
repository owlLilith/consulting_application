import "dart:io";
import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../models/contributor.dart';
import 'package:image_picker/image_picker.dart';

class profileTab extends StatefulWidget {
  static const routName = "/profile-tab";

  @override
  State<profileTab> createState() => _profileTabState();
}

Map<String, List<dynamic>> contactInfo = {};

class _profileTabState extends State<profileTab> {
  bool edit = false;

  late File image;
  final imagePicker = ImagePicker();
  uploadImage() async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  }

  Contributor? contributor;

  Widget buildCard({
    required double height,
    required String title,
    required Map<String, String> content,
    required void Function() edit,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: height,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromARGB(255, 196, 183, 218),
          border: Border.all(color: Colors.blueGrey)),
      child: GridTile(
        header: Positioned(
          left: 10,
          top: 10,
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.underline),
          ),
        ),
        footer: Positioned(
            right: 10,
            bottom: 11,
            child: TextButton(onPressed: edit, child: const Text("edit"))),
        child: Container(
          padding: const EdgeInsets.only(top: 30, bottom: 15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: content.keys.map((item) {
                return ListTile(
                  leading: Text("$item :"),
                  title: Text(
                    content[item].toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: item == "consulting details" ? 4 : 1,
                  ),
                );
              }).toList()),
        ),
      ),
    );
  }

  Future<void> refreshContent() async {
    setState(() {
      contactInfo = {
        "phone number": [
          contributor!.phoneNumber,
          Icons.phone_enabled_rounded,
          false
        ],
        "gender": [contributor!.gender.name, Icons.face, false],
        "email": [contributor!.email, Icons.email_rounded, false],
        "address": [contributor!.location, Icons.person_pin_circle, false],
        "birthDay": [
          contributor!.birthDay.toString(),
          Icons.date_range_rounded,
          false
        ],
      };
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      contactInfo;
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    contributor = Provider.of<authProvider>(context).contributor;

    var contactInfoContainer = Container(
        height: 350,
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            const Text("Contact Information :",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            SizedBox(
              height: 325,
              child: ListView(
                children: contactInfo.keys.map((item) {
                  return SizedBox(
                    height: 80,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: Icon(
                              contactInfo[item]![1],
                            ),
                            title: Text(item),
                            subtitle: contactInfo[item]![2]
                                ? TextField()
                                : Text(contactInfo[item]![0].toString()),
                            trailing: IconButton(
                                onPressed: () => setState(() {
                                      print(contactInfo[item]![2]);
                                      contactInfo.update(
                                          item,
                                          (value) => [
                                                contactInfo[item]![0],
                                                contactInfo[item]![1],
                                                !contactInfo[item]![2]
                                              ]);
                                    }),
                                icon: Icon(contactInfo[item]![2]
                                    ? Icons.done
                                    : Icons.edit)),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ));

    var experierinceDetailsContainer = Container(
        height: 250,
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Experience Details :",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            SizedBox(
              height: 225,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(
                  //   height: 30,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 95,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blueGrey),
                            color: Colors.blueGrey[100],
                          ),
                          child: Text(
                            contributor!.consultingDetail,
                            maxLines: 5,
                            style: const TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 16,
                                wordSpacing: 1,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Text("edit"),
                          color: Colors.blueGrey,
                          elevation: 6,
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  ListTile(
                    leading: Icon(Icons.attach_money_rounded),
                    title: Text("consulting cost"),
                    subtitle: Text(contributor!.consultingCost.toString()),
                    trailing:
                        IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ),
                  const Divider(
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),
            ),
          ],
        ));

    var availableOppointmentContainer = Container(
        height: 250,
        margin: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Available Oppointment :",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            SizedBox(
              height: 200,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: contributor!.availableDates!.keys.map((element) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                            child: Text(DateFormat("EEE").format(element))),
                        Text(
                            "from ${contributor!.availableDates![element]!.first} to ${contributor!.availableDates![element]!.last}")
                      ],
                    );
                  }).toList()),
            ),
          ],
        ));

    return Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.lightGreen.withOpacity(0.5),
          Colors.white,
          Colors.white
        ], begin: Alignment.bottomRight, end: Alignment.topLeft),
      ),
      height: 700,
      child: Column(
        children: [
          InkWell(
            onTap: uploadImage,
            child: CircleAvatar(
              radius: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(contributor!.imageUrl)),
              ),
            ),
          ),
          Text(contributor!.name,
              style: const TextStyle(
                  fontSize: 22, letterSpacing: 2, fontWeight: FontWeight.bold)),
          if (contributor!.role == Role.expert)
            Text(
              "- ${contributor!.experienceCategory.name} expert -",
              style: const TextStyle(letterSpacing: 1),
            ),
          const Divider(
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          RefreshIndicator(
              child: SizedBox(
                height: 350,
                child: ListView(
                  children: [
                    contactInfoContainer,
                    if (contributor!.role == Role.expert)
                      experierinceDetailsContainer,
                    if (contributor!.role == Role.expert)
                      availableOppointmentContainer
                  ],
                ),
              ),
              onRefresh: refreshContent)
        ],
      ),
    );
  }
}
