import "package:flutter/material.dart";

class chattingWidget extends StatelessWidget {
  String message;
  String name;

  chattingWidget(this.name, this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Column(
        children: [
          Card(
            elevation: 12,
            margin: const EdgeInsets.all(15),
            child: Expanded(
              child: ListTile(
                title: Text(name),
                subtitle: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(message),
                ),
                trailing:
                    ElevatedButton(onPressed: () {}, child: Text("Replay")),
              ),
            ),
          ),
          Divider(
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
    );
  }
}
