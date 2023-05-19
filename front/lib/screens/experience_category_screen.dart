import 'package:flutter/material.dart';
import '../models/contributor.dart';
import "package:provider/provider.dart";

import '../widgets/expert_widget.dart';
import '../provider/contributor_provider.dart';

class experienceCategoryScreen extends StatefulWidget {
  static const routeName = "/experience-category-screen";
  @override
  State<experienceCategoryScreen> createState() =>
      _experienceCategoryScreenState();
}

bool isLoading = false;

class _experienceCategoryScreenState extends State<experienceCategoryScreen> {
  final _form = GlobalKey<FormState>();
  bool searching = false;
  String? name;
  List<Contributor> onlySearch = [];
  @override
  Widget build(BuildContext context) {
    var contributerProvider = Provider.of<ContributorProvider>(context);
    var contributor = Provider.of<ContributorProvider>(context);
    String appBarTitle = ModalRoute.of(context)!.settings.arguments as String;
    List<Contributor> expertsData = contributerProvider.contributorsData
        .where((element) =>
            appBarTitle == ExperienceCategory.all.name ||
            element.experienceCategory.name == appBarTitle)
        .toList();

    FocusNode searchIcon = FocusNode();

    void search() async {
      setState(() {
        isLoading = true;
      });
      _form.currentState!.save();
      onlySearch = await contributor.search(name!);
      setState(() {
        onlySearch;
        searching = true;
        isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
              key: _form,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Search for Experts...",
                  suffixIcon: IconButton(
                    focusNode: searchIcon,
                    onPressed: search,
                    icon: const Icon(Icons.search),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(searchIcon);
                },
                onSaved: (newValue) => this.name = newValue,
              ),
            ),
            isLoading
                ? Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.5,
                    left: MediaQuery.of(context).size.width * 0.5,
                    child: CircularProgressIndicator())
                : Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(15),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 350,
                          childAspectRatio: 1.5,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                        ),
                        itemCount:
                            searching ? onlySearch.length : expertsData.length,
                        itemBuilder: (context, index) {
                          return expertWidget(searching
                              ? onlySearch[index]
                              : expertsData[index]);
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
