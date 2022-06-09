import 'dart:convert';

import 'package:flutter/services.dart';

class Category {
  late String c1, c2, c3, c4;

  Category.init() : c1 = '', c2 = '', c3 = '', c4 = '';
  Category(this.c1, this.c2, this.c3, this.c4,);

  @override
  String toString() {
    String _returnString = c1;
    _returnString += c2.isEmpty ? c2 : '>$c2';
    _returnString += c3.isEmpty ? c3 : '>$c3';
    _returnString += c4.isEmpty ? c4 : '>$c4';
    return _returnString;
  }
}

class Categories {
  Map<String, dynamic> data = {};

  Future<void> loadJson() async {
    String jsonString = await rootBundle.loadString('assets/json/categories.json');
    data = await json.decode(jsonString);
  }

  dynamic _getList(dynamic json) => json is List ? json : json.keys;

  void toMap() {
    Map<String, dynamic> newData = {};

    for (String c1 in data.keys) {
      var first = data[c1];
      var firstList = _getList(first);

      newData[c1] = {};

      for (String c2 in firstList) {
        var second = first[c2];
        var secondList = _getList(second);

        newData[c1][c2] = {};

        for (String c3 in secondList) {
          var third = second is List ? second : second[c3];
          var thirdList = _getList(third);

          newData[c1][c2][c3] = {};

          if (second is List) continue;

          for (String c4 in thirdList) {
            newData[c1][c2][c3][c4] = {};
          }
        }
      }
    }

    data = newData;
  }

  List<String> find(String cateString) {
    List<String> _found = [];

    for (String c1 in data.keys) {
      if (c1.contains(cateString)) {
        _found.add(Category(c1, '', '', '').toString());
      }
      for (String c2 in data[c1].keys) {
        if (c2.contains(cateString)) {
          _found.add(Category(c1, c2, '', '').toString());
        }
        for (String c3 in data[c1][c2].keys) {
          if (c3.contains(cateString)) {
            _found.add(Category(c1, c2, c3, '').toString());
          }
          for (String c4 in data[c1][c2][c3].keys) {
            if (c4.contains(cateString)) {
              _found.add(Category(c1, c2, c3, c4).toString());
            }
          }
        }
      }
    }

    return _found;
  }

  dynamic next(String cateString) {
    final _categories = cateString.split('>');
    late String c1, c2, c3, c4;
    int len = _categories.length;

    c1 = _categories[0];
    c2 = len > 1 ? _categories[1] : '';
    c3 = len > 2 ? _categories[2] : '';
    c4 = len > 3 ? _categories[3] : '';

    try {
      if (len > 3) return data[c1][c2][c3][c4].keys;
      if (len > 2) return data[c1][c2][c3].keys;
      if (len > 1) return data[c1][c2].keys;
      return data[c1].keys;
    }
    catch(e) { return null; }

  }
}