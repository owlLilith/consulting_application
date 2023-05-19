import 'package:flutter/material.dart';
import '../provider/auth_provider.dart';
import '../screens/skip_screen.dart';
import 'package:provider/provider.dart';
import '../models/contributor.dart';
import '../screens/sing_up_expert_role_screen.dart';

class roleScreen extends StatefulWidget {
  static const routeName = "/role-screen";

  @override
  State<roleScreen> createState() => _roleScreenState();
}

class _roleScreenState extends State<roleScreen> {
  Widget buildCard(String image, String text, void Function() onTap) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: FittedBox(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 12,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: size.height * 0.31,
                    width: size.width * 0.6,
                    child: Image.asset(image, fit: BoxFit.contain),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                    width: size.width * 0.18,
                    child: FittedBox(
                      child: Text(
                        text,
                        style: TextStyle(
                            color: Colors.amber, fontSize: size.height * 0.15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var provide = Provider.of<authProvider>(context);
    var map = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String name = map["name"]!,
        email = map["email"]!,
        password = map["password"]!,
        gender = map["gender"]!;

    void onTapUser() {
      provide.signupUser(
          name, email, password, Role.user.name.toString(), gender);
      Navigator.of(context).pushNamed(skipScreen.routeName);
    }

    void onTapExpert() {
      Navigator.of(context)
          .pushNamed(signupExpertRoleScreen.routeName, arguments: {
        "name": name,
        "email": email,
        "gender": gender,
        "password": password,
        "role": Role.expert.name.toString()
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Choose your role")),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Continue as :",
              style: TextStyle(
                  fontSize: height * 0.055,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildCard("assets/image/user.webp", "User", onTapUser),
                  buildCard("assets/image/expert.webp", "Expert", onTapExpert),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
