import "package:flutter/material.dart";
import '../provider/auth_provider.dart';
import '../screens/auth_screen.dart';
import '../tabs/chatting_tab.dart';
import '../tabs/favorite_tab.dart';
import '../tabs/notifications.dart';
import '../tabs/home_tab.dart';
import '../tabs/profile_tab.dart';
import 'package:provider/provider.dart';
import '../models/contributor.dart';

class mainPage extends StatefulWidget {
  static const routeName = "/main-page";

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  int tabIndex = 0;

  PopupMenuEntry<dynamic> buildshowMenu(Enum category, String text) {
    return PopupMenuItem<Enum>(
      value: category,
      child: Text(text),
    );
  }

  Widget build(BuildContext context) {
    var role = Provider.of<authProvider>(context).contributor.role;
    // var role = Role.expert;
    List<Map<String, Object>> page = [
      {"page": homeTab(), "title": "Home Page"},
      {"page": chattingTab(), "title": "your Contect"},
      {"page": favoriteTab(), "title": "your Favorite experts"},
      if (role == Role.expert)
        {"page": notificationsTab(), "title": "check you notifications"},
      {"page": profileTab(), "title": "your Profile"},
    ];

    void selectedTab(int index) {
      setState(() {
        tabIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(page[tabIndex]["title"] as String),
      ),
      drawer: Drawer(
        child: Column(children: [
          ListTile(
            onTap: () {
              Provider.of<authProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(authScreen.routeName);
            },
            leading: const Icon(Icons.logout),
            title: const Text("Log out"),
          )
        ]),
      ),
      body: page[tabIndex]["page"] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => selectedTab(index),
        iconSize: 28,
        elevation: 12,
        currentIndex: tabIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: Icon(tabIndex == 0 ? Icons.home : Icons.home_outlined),
            tooltip: "home",
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(tabIndex == 1 ? Icons.chat : Icons.chat_outlined),
            tooltip: "chatting",
            label: "chatting",
          ),
          BottomNavigationBarItem(
            icon: Icon(tabIndex == 2 ? Icons.favorite : Icons.favorite_outline),
            tooltip: "favorite",
            label: "favorite",
          ),
          if (role == Role.expert)
            BottomNavigationBarItem(
              icon: Icon(tabIndex == 3
                  ? Icons.notifications
                  : Icons.notifications_none_outlined),
              tooltip: "notification",
              label: "notification",
            ),
          BottomNavigationBarItem(
            icon: Icon(tabIndex == (role == Role.expert ? 4 : 3)
                ? Icons.person
                : Icons.person_outline),
            tooltip: "profile",
            label: "profile",
          ),
        ],
      ),
    );
  }
}
