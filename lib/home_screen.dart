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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Welcome ${FirebaseAuth.instance.currentUser!.displayName}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        title: Text("Hey! ${FirebaseAuth.instance.currentUser!.displayName}"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite_outline_rounded,
              size: 28,
              color: const Color.fromARGB(255, 255, 84, 141),
            ),
            onPressed: () {},
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
