import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:riccardo_roux_cocktail_app/models/cocktails.dart';
import 'package:riccardo_roux_cocktail_app/screens/cocktail_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _cocktails = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cocktailModel = Provider.of<CocktailModel>(context);

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(labelText: 'Inserisci una lettera'),
            onChanged: (query) async {
              if (query.isNotEmpty) {
                setState(() {
                  _isLoading = true;
                });
                final cocktails = await _searchCocktails(query);
                setState(() {
                  _isLoading = false;
                  _cocktails = cocktails;
                });
              } else {
                setState(() {
                  _cocktails = [];
                });
              }
            },
          ),
          SizedBox(height: 16.0),
          _isLoading
              ? CircularProgressIndicator()
              : _cocktails.isEmpty
              ? Text('Nessun risultato trovato. Modifica il testo inserito.')
              : Expanded(
            child: ListView.builder(
              itemCount: _cocktails.length,
              itemBuilder: (context, index) {
                final cocktail = _cocktails[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      cocktail['strDrinkThumb'],
                      width: 80,
                      height: 80,
                    ),
                    title: Text(cocktail['strDrink']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DrinkDetailScreen(
                            cocktail: cocktail,
                            isFavorite: cocktailModel.isFavorite(cocktail),
                          ),
                        ),
                      );
                    },
                    trailing: Icon(
                      cocktailModel.isFavorite(cocktail)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: cocktailModel.isFavorite(cocktail)
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> _searchCocktails(String query) async {
    final response = await http.get(
      Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['drinks'] ?? [];
    } else {
      throw Exception('Errore durante la ricerca dei cocktail');
    }
  }
}
