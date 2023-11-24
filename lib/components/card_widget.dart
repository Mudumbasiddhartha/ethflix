import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String imageUrl;

  CardWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () => {
          Navigator.pushReplacementNamed(context, '/details',
              arguments: imageUrl),
        },
        child: Card(
          elevation: 4,
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 400,
            ),
          ),
        ),
      ),
    );
  }
}
