import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riccardo_roux_cocktail_app/models/cocktails.dart';

class DrinkDetailScreen extends StatelessWidget {
  final dynamic cocktail;
  final bool isFavorite;

  DrinkDetailScreen({required this.cocktail, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail['strDrink']),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              final cocktails = Provider.of<CocktailModel>(context, listen: false);
              cocktails.toggleFavorite(cocktail);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              cocktail['strDrinkThumb'],
              width: 200,
              height: 200,
            ),
            SizedBox(height: 16.0),
            Text('Nome: ${cocktail['strDrink']}'),
            SizedBox(height: 16.0),
            Text('Preparazione: ${cocktail['strInstructions']}'),
            // Aggiungi altre informazioni sul drink, se necessario.
          ],
        ),
      ),
    );
  }
}
