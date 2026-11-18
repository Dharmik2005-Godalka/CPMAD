import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeScreen extends StatelessWidget 
{
  const RecipeScreen({super.key});

  final List<String> categories = const 
  [
    'All', 'Breakfast', 'Lunch', 'Dinner', 'Dessert', 'Snacks',
  ];

  List<Recipe> get featured => [
        Recipe
        (
          name: 'Paneer Butter Masala',
          category: 'Dinner',
          time: '40 min',
          rating: '4.8',
          color: Colors.deepOrange,
          icon: Icons.dinner_dining,
        ),

        Recipe
        (
          name: 'Chocolate Brownie',
          category: 'Dessert',
          time: '35 min',
          rating: '4.9',
          color: Colors.brown,
          icon: Icons.cake,
        ),

        Recipe
        (
          name: 'Veg Sandwich',
          category: 'Breakfast',
          time: '15 min',
          rating: '4.5',
          color: Colors.green,
          icon: Icons.lunch_dining,
        ),
      ];

  List<Recipe> get recipes => [
        Recipe
        (
          name: 'Masala Dosa',
          category: 'Breakfast',
          time: '30 min',
          rating: '4.7',
          color: Colors.amber,
          icon: Icons.breakfast_dining,
        ),
        
        Recipe
        (
          name: 'Veg Biryani',
          category: 'Lunch',
          time: '50 min',
          rating: '4.6',
          color: Colors.red,
          icon: Icons.rice_bowl,
        ),
        Recipe
        (
          name: 'Pasta Alfredo',
          category: 'Dinner',
          time: '25 min',
          rating: '4.4',
          color: Colors.blueGrey,
          icon: Icons.ramen_dining,
        ),
        Recipe
        (
          name: 'Gulab Jamun',
          category: 'Dessert',
          time: '45 min',
          rating: '4.8',
          color: Colors.pink,
          icon: Icons.icecream,
        ),
        Recipe
        (
          name: 'French Fries',
          category: 'Snacks',
          time: '20 min',
          rating: '4.3',
          color: Colors.orange,
          icon: Icons.fastfood,
        ),
      ];

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe App'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            buildCategories(),
            buildTitle('Featured Recipes'),
            buildFeaturedList(),
            buildTitle('All Recipes'),
            ...recipes.map((recipe) => buildRecipeTile(recipe)),
          ],
        ),
      ),
    );
  }

  // Section heading
  Widget buildTitle(String text) 
  {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Horizontal category chips
  Widget buildCategories() 
  {
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: Chip(label: Text(categories[index])),
          );
        },
      ),
    );
  }

  // Horizontal featured recipe cards
  Widget buildFeaturedList() 
  {
    final list = featured;

    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final recipe = list[index];
          return Container(
            width: 230,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: recipe.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(recipe.icon, size: 60, color: Colors.white),
                ),
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${recipe.time}  •  ⭐ ${recipe.rating}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // One recipe row
  Widget buildRecipeTile(Recipe recipe) 
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: recipe.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(recipe.icon, color: Colors.white, size: 36),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recipe.category,
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  '${recipe.time}  •  ⭐ ${recipe.rating}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}