import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Recipe Categories')),
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 5), // Orange border
          ),
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // space between items in the column
                children: [
                  // 1. Browse Categories Header
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'BROWSE CATEGORIES',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // 2. Description Text (Left-aligned)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Not sure about exactly which recipe you\'re looking for? Do a search, or dive into our most popular categories.',
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. BY MEAT Section (using Stack layout)
                  _buildImageSection(
                    title: 'BY MEAT',
                    items: [
                      _buildCircularItem('Beef', 'images/beef.jpg', true),
                      _buildCircularItem('Chicken', 'images/chicken.jpg', true),
                      _buildCircularItem('Pork', 'images/pork.jpg', true),
                      _buildCircularItem('Seafood', 'images/seafood.jpg', true),
                    ],
                  ),

                  // 4. BY COURSE Section (using Column layout)
                  _buildImageSection(
                    title: 'BY COURSE',
                    items: [
                      _buildBottomTextItemInColumn('Main Dishes', 'images/main_dishes.jpg'),
                      _buildBottomTextItemInColumn('Salad Recipes', 'images/salad.jpg'),
                      _buildBottomTextItemInColumn('Side Dishes', 'images/side_dishes.jpg'),
                      _buildBottomTextItemInColumn('Crockpot', 'images/crockpot.jpg'),
                    ],
                  ),

                  // 5. BY DESSERT Section (using Column layout)
                  _buildImageSection(
                    title: 'BY DESSERT',
                    items: [
                      _buildBottomTextItemInColumn('Ice Cream', 'images/icecream.jpg'),
                      _buildBottomTextItemInColumn('Brownies', 'images/brownies.jpg'),
                      _buildBottomTextItemInColumn('Pies', 'images/pies.jpg'),
                      _buildBottomTextItemInColumn('Cookies', 'images/cookies.jpg'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection({required String title, required List<Widget> items}) {
    return Column(
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Images Row (SpaceAround to space items)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute evenly around
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularItem(String text, String imagePath, bool isCenter) {
    return SizedBox(
      width: 100, // Adjusting the width and height
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(imagePath),
          ),
          Positioned(
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // For menu items under "BY COURSE" and "BY DESSERT" (using Column layout)
  Widget _buildBottomTextItemInColumn(String text, String imagePath) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(imagePath),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14, // Slightly bigger font size for better visibility
            ),
          ),
        ),
      ],
    );
  }
}
