import 'package:flutter/foundation.dart';

class CocktailModel extends ChangeNotifier {
  List<dynamic> _favorites = [];

  List<dynamic> get favorites => _favorites;

  void toggleFavorite(dynamic cocktail) {
    if (isFavorite(cocktail)) {
      _favorites.removeWhere((item) => item['idDrink'] == cocktail['idDrink']);
    } else {
      _favorites.add(cocktail);
    }
    notifyListeners();
  }

  bool isFavorite(dynamic cocktail) {
    return _favorites.any((item) => item['idDrink'] == cocktail['idDrink']);
  }
}
