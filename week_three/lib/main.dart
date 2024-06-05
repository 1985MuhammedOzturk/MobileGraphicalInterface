import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Browser',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Browse Categories'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Not sure about exactly which recipe you\'re looking for? Do a search, or dive into our most popular categories.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              categorySection('BY MEAT', [
                {'label': 'Beef', 'image': 'images/beef.jpg'},
                {'label': 'Chicken', 'image': 'images/chicken.jpg'},
                {'label': 'Pork', 'image': 'images/pork.jpg'},
                {'label': 'Seafood', 'image': 'images/seafood.jpg'},
              ], true),  // True for center text over the image
              categorySection('BY COURSE', [
                {'label': 'Main Dishes', 'image': 'images/maindishes.jpg'},
                {'label': 'Salad Recipes', 'image': 'images/salad.jpg'},
                {'label': 'Side Dishes', 'image': 'images/sidedishes.jpg'},
                {'label': 'Crockpot', 'image': 'images/crockpot.jpg'},
              ], false),  // False for text below the image
              categorySection('BY DESSERT', [
                {'label': 'Ice Cream', 'image': 'images/icecream.jpg'},
                {'label': 'Brownies', 'image': 'images/brownies.jpg'},
                {'label': 'Pies', 'image': 'images/pies.jpg'},
                {'label': 'Cookies', 'image': 'images/cookies.jpg'},
              ], false),  // False for text below the image
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget categorySection(String title, List<Map<String, String>> items, bool isCenterText) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) => _buildCategory(item['label']!, item['image']!, isCenterText)).toList(),
        ),
      ],
    );
  }

  Widget _buildCategory(String text, String imagePath, bool isCenterText) {
    return Expanded(
      child: Container(
        height: 130,
        margin: EdgeInsets.all(4),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipOval(
              child: Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.cover),
            ),
            if (isCenterText)
              Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)) // Text centered without background for meat
            else
              Positioned(
                bottom: 0, // Position of the text at the bottom for BY COURSE' and 'BY DESSERT'
                child: Text(
                    text,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)
                ),
              )
          ],
        ),
      ),
    );
  }
}
