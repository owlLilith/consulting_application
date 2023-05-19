import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../models/contributor.dart';
import '../provider/contributor_provider.dart';
import '../screens/expert_details_screen.dart';

class expertWidget extends StatefulWidget {
  Contributor contributer;
  expertWidget(this.contributer);

  @override
  State<expertWidget> createState() => _expertWidgetState();
}

class _expertWidgetState extends State<expertWidget> {
  bool isFavorite = false;

  Widget build(BuildContext context) {
    var provide = Provider.of<ContributorProvider>(context);

    return Expanded(
      child: 
      
      InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(expertDetailsScreen.routeName,
              arguments: widget.contributer);
        },
        child: GridTile(
          header: Center(
            child: ListTile(
              title: Text(widget.contributer.rate.toStringAsFixed(1),
                  textAlign: TextAlign.end,
                  style: const TextStyle(color: Colors.white)),
              trailing: const Icon(
                Icons.star,
                color: Colors.amberAccent,
              ),
            ),
          ),
          footer: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              color: Colors.black54,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: ListTile(
                  title: Expanded(
                      child: Text(
                    widget.contributer.name,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                  subtitle: Expanded(
                      child: Row(children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color.fromARGB(255, 179, 190, 198),
                    ),
                    Text(widget.contributer.location,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 179, 190, 198)))
                  ])),
                  leading: IconButton(
                    onPressed: () =>
                        provide.addToFavorite(widget.contributer.id),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.category,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Image.network(
              widget.contributer.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
