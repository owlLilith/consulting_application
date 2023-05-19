import "package:flutter/material.dart";
import '../widgets/chatting_widget.dart';

class chattingTab extends StatelessWidget {
  static const routName = "/chatting-tab";
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Map<String, String> message = {
      "name": "blblblblb",
      "name2": "blblalblablablba"
    };
    return Container(
      height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.amberAccent.withOpacity(0.5),
          Colors.white,
          Colors.white
        ], begin: Alignment.bottomRight, end: Alignment.topLeft),
      ),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.6,
            child: Column(
              children: message.keys.map((element) {
                return chattingWidget(element, message[element]!);
              }).toList(),
            ),
          ),
          SizedBox(
            height: size.height * 0.2,
            width: size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        label:
                            Text("label", style: const TextStyle(fontSize: 15)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
