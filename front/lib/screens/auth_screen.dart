import "package:flutter/material.dart";

import "../provider/auth_provider.dart";
import '../screens/main_page.dart';
import '../screens/role_screen.dart';
import "package:provider/provider.dart";
import "../models/contributor.dart";
import "../error/httpError.dart";

enum Auth {
  Login,
  Signup,
}

class authScreen extends StatefulWidget {
  static const routeName = "/auth-screen";
  @override
  State<authScreen> createState() => _authScreenState();
}

class _authScreenState extends State<authScreen>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  bool visibility = true;
  bool isLoading = false;
  Auth authMode = Auth.Login;
  String email = "";
  String password = "";
  String name = "";
  Enum? gender;

  Map<Enum, bool> selectedGender = {
    Gender.female: false,
    Gender.male: false,
  };

  TextEditingController passwordController = TextEditingController();

  AnimationController? _animationController;
  Animation<Size>? _heightAnimation;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      var size = MediaQuery.of(context).size;
      _animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 600));
      _heightAnimation = Tween<Size>(
              begin: Size(double.infinity, size.height * 0.55),
              end: Size(double.infinity, size.height * 0.85))
          .animate(CurvedAnimation(
              parent: _animationController!, curve: Curves.fastOutSlowIn));

      _heightAnimation!.addListener(() => setState(() {}));
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  Widget buildTextFormField({
    String? hintText,
    IconData? icon,
    String label = "",
    FocusNode? node,
    String? Function(String?)? validate,
    TextInputAction? action,
    String? Function(String?)? submit,
    void Function(String?)? saved,
    required bool visibility,
    TextEditingController? control,
  }) {
    return SizedBox(
      child: TextFormField(
        controller: control,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 10),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            label: Text(label, style: const TextStyle(fontSize: 15)),
            suffixIcon: Icon(icon),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
        focusNode: node,
        validator: validate,
        textInputAction: action,
        onFieldSubmitted: submit,
        obscureText: visibility,
        onSaved: saved,
      ),
    );
  }

  Widget buildSelectGenderCard(Enum text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            for (Enum i in selectedGender.keys) {
              if (i == text) {
                if (selectedGender[i]!) {
                  selectedGender.update(i, (value) => false);
                } else {
                  selectedGender.update(i, (value) => true);
                }
              } else {
                selectedGender.update(i, (value) => false);
              }
            }
          });
        },
        child: Material(
          borderRadius: BorderRadius.circular(30),
          elevation: 4,
          child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: selectedGender[text] == true
                      ? Colors.amber
                      : Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                    child: Text(text.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedGender[text] == true
                                ? Colors.white
                                : Colors.deepPurple))),
              )),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    Size? size = media.size;
    var isLanscape = media.orientation == Orientation.landscape;
    var auth = Provider.of<authProvider>(context);

    FocusNode emailField = FocusNode();
    FocusNode passwordField = FocusNode();
    FocusNode confirmPasswordField = FocusNode();
    FocusNode button = FocusNode();

    String? validateName(String? value) {
      if (value!.isEmpty) return "provide your name";
      return null;
    }

    String? vaildateEmail(String? value) {
      if (value!.isEmpty) return "provide Email";
      if (!value.contains("@") && !value.contains(".com"))
        return "your email is not correct";
      return null;
    }

    String? validatePassword(String? value) {
      if (value!.isEmpty) return "provide Password";
      if (value.length < 8)
        return "your Password is too short\nat least enter 8 caracters";
      return null;
    }

    String? validateCinformPassword(String? value) {
      if (value!.isEmpty) return "provide Password confirming";
      if (value != passwordController.text) return "doesn't match you password";
      return null;
    }

    void showSnackBar(String errorMessage) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        action: SnackBarAction(
          label: errorMessage.contains("password")
              ? "FORGGET YOUR PASSWORD?"
              : "OKEY",
          onPressed: () {},
        ),
      ));
    }

    void elevatedButtonPressed(Auth authMode) async {
      bool isValid = _form.currentState!.validate();
      if (gender == null) {
        setState(() {
          gender = Gender.anoun;
        });
      } else {
        for (var i in selectedGender.keys) {
          if (selectedGender[i] == true) {
            setState(() {
              gender = i;
            });
          }
        }
      }
      if (!isValid) {
        isLoading = false;
        return;
      }
      _form.currentState!.save();

      try {
        if (authMode == Auth.Signup) {
          for (var i in selectedGender.keys) {
            if (selectedGender[i] == true) {
              setState(() {
                gender = i;
              });
            }
          }
          Navigator.of(context).pushReplacementNamed(roleScreen.routeName,
              arguments: {
                "name": name,
                "email": email,
                "gender": gender!.name,
                "password": password
              });
        } else {
          print(email + password);
          await auth.login(
            this.email,
            this.password,
          );
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pushReplacementNamed(mainPage.routeName);
        }
      } on httpError catch (error) {
        setState(() {
          isLoading = false;
        });
        String errorMessage = error.toString();
        // if (errorMessage.contains("INVALID_EMAIL")) {
        //   errorMessage = "the email you try to submit is invalid";
        // } else if (errorMessage.contains("INVALID_PASSWORD")) {
        //   errorMessage = "invalid password, try again";
        // } else if (errorMessage.contains("EMAIL_EXISTS")) {
        //   errorMessage = "the email you try to submit is already exists";
        // } else if (errorMessage.contains("EMAIL_NOT_FOUND")) {
        //   errorMessage = "the email you try to submit is not exist";
        // }
        showSnackBar(errorMessage);
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        String errorMessage = "somthing went wrong, please try again";
        showSnackBar(errorMessage);
      }
    }

    var form = Form(
      key: _form,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          height:
              authMode == Auth.Signup ? size.height * 0.76 : size.height * 0.45,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (authMode == Auth.Signup)
                FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: _animationController!, curve: Curves.easeIn)),
                  child: buildTextFormField(
                    visibility: false,
                    label: "Name",
                    hintText: "Enter your Name",
                    validate: validateName,
                    submit: (value) {
                      FocusScope.of(context).requestFocus(emailField);
                    },
                    saved: (value) {
                      this.name = value!;
                    },
                    action: TextInputAction.next,
                  ),
                ),
              if (authMode == Auth.Signup)
                Text(
                  gender == Gender.anoun
                      ? "you should provide your gender"
                      : "select your gender",
                  style: TextStyle(
                    color:
                        gender == Gender.anoun ? Colors.red : Colors.blueGrey,
                    fontWeight: gender == Gender.anoun
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
              if (authMode == Auth.Signup)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ScaleTransition(
                          scale: Tween(begin: 0.5, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: _animationController!,
                                  curve: Curves.easeIn)),
                          child: buildSelectGenderCard(Gender.female)),
                      ScaleTransition(
                        scale: Tween(begin: 0.5, end: 1.0).animate(
                            CurvedAnimation(
                                parent: _animationController!,
                                curve: Curves.easeIn)),
                        child: buildSelectGenderCard(Gender.male),
                      ),
                    ],
                  ),
                ),
              buildTextFormField(
                hintText: "Enter your Email address",
                icon: Icons.email_outlined,
                label: "Email",
                action: TextInputAction.next,
                submit: (value) {
                  FocusScope.of(context).requestFocus(passwordField);
                },
                validate: vaildateEmail,
                visibility: false,
                saved: (value) {
                  this.email = value!;
                },
                node: emailField,
              ),
              Row(
                children: [
                  Expanded(
                    child: buildTextFormField(
                      hintText: "Enter your Password",
                      icon: Icons.lock_open,
                      label: "Password",
                      action: TextInputAction.next,
                      node: passwordField,
                      submit: (value) {
                        FocusScope.of(context).requestFocus(
                            authMode == Auth.Signup
                                ? confirmPasswordField
                                : button);
                      },
                      validate: validatePassword,
                      visibility: visibility,
                      saved: (value) {
                        this.password = value!;
                      },
                      control: passwordController,
                    ),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    onPressed: () => setState(() {
                      visibility = !visibility;
                    }),
                    icon: Icon(
                      visibility ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ],
              ),
              if (authMode == Auth.Signup)
                FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: _animationController!, curve: Curves.easeIn)),
                  child: buildTextFormField(
                    hintText: "Confirm your Password",
                    label: "Confirm Password",
                    action: TextInputAction.next,
                    node: confirmPasswordField,
                    submit: (value) {
                      FocusScope.of(context).requestFocus(button);
                    },
                    validate: validateCinformPassword,
                    visibility: false,
                  ),
                ),
              if (isLoading == true)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    elevatedButtonPressed(authMode);
                  },
                  focusNode: button,
                  child: Text((authMode == Auth.Login) ? "Log in" : "Sign up"),
                ),
              TextButton(
                  onPressed: () => setState(() {
                        isLoading = false;
                        if (authMode == Auth.Login) {
                          authMode = Auth.Signup;
                          _animationController!.forward();
                        } else {
                          authMode = Auth.Login;
                          _animationController!.reverse();
                        }
                      }),
                  child: Text((authMode == Auth.Login)
                      ? "SignUp instead"
                      : "Log in instead"))
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.white, Colors.white],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                if (authMode == Auth.Login)
                  Image.asset("assets/image/auth.webp",
                      height: size.height * 0.2),
                Text(
                  "Welcome!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black87, fontSize: size.height * 0.05),
                ),
                Text(
                  "please fill those fields to ${authMode == Auth.Login ? "log in" : "sign up"}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54, fontSize: size.height * 0.03),
                ),
                const Divider(
                  indent: 15,
                  endIndent: 15,
                ),
                AnimatedContainer(
                  height: authMode == Auth.Signup
                      ? size.height * 0.85
                      : size.height * 0.55,
                  constraints: BoxConstraints(
                    minHeight: authMode == Auth.Signup
                        ? size.height * 0.85
                        : size.height * 0.55,
                  ),
                  curve: Curves.decelerate,
                  duration: const Duration(seconds: 1),
                  child: Card(
                      elevation: 12,
                      color: Colors.white,
                      margin: const EdgeInsets.all(15),
                      child: Padding(
                          padding: const EdgeInsets.all(15), child: form)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
