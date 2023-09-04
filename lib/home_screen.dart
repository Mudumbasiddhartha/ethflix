import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import 'components/card_widget.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = ['Shows', 'Movies', 'Live Sports'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EthFlix'),
        // backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategorySection(category: categories[index]);
        },
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String category;

  CategorySection({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            height: 200,
            enlargeCenterPage: true,
          ),
          items: [
            CardWidget(
                imageUrl:
                    'https://img2.wallspic.com/previews/0/9/9/7/3/137990/137990-uefa_champions_league-sky-lionel_messi-sport_venue-fun-x750.jpg'),
            CardWidget(
                imageUrl:
                    'https://img2.wallspic.com/previews/0/9/9/7/3/137990/137990-uefa_champions_league-sky-lionel_messi-sport_venue-fun-x750.jpg'),
            CardWidget(
                imageUrl:
                    'https://img2.wallspic.com/previews/0/9/9/7/3/137990/137990-uefa_champions_league-sky-lionel_messi-sport_venue-fun-x750.jpg'),
            // Add more CardWidgets for each item in the carousel
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}