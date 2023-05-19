import 'package:flutter/material.dart';

class rateProvider with ChangeNotifier {
  final List<bool> _lighting = [false, false, false, false, false];
  List<bool> lighting(double num) {
    if (num > 0) _lighting[0] = true;
    for (int i = 1; i <= num.floor(); i++) {
      _lighting[i] = true;
    }
    notifyListeners();
    return _lighting;
  }

  void lightUp(int index, double rate) {
    rate = (rate + double.parse(index.toString())) / 2;
    lighting(rate);
    notifyListeners();
  }
}
