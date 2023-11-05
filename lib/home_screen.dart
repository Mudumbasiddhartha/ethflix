import "package:carousel_slider/carousel_slider.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'components/card_widget.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = ['Shows', 'Movies', 'Live Sports'];
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hey! ${FirebaseAuth.instance.currentUser!.displayName}"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Handle menu press
            Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: Text('Drawer Header'),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text('Item 1'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    title: Text('Item 2'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () {
              // Handle search action
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
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
        //add welcome user name
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
