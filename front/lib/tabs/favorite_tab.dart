import "package:flutter/material.dart";
import '../provider/contributor_provider.dart';
import '../widgets/expert_widget.dart';
import 'package:provider/provider.dart';

class favoriteTab extends StatelessWidget {
  static const routName = "/favorite-tab";

  Widget build(BuildContext context) {
    var provide = Provider.of<ContributorProvider>(context);
    return Container(
      height: 700,
      child: Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 350,
              childAspectRatio: 1.5,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemCount: provide.favorites.length,
            itemBuilder: (context, index) {
              return expertWidget(provide.favorites[index]);
            },
          ),
        ),
      ),
    );
  }
}
