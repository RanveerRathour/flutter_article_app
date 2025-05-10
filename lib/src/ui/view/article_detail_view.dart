import 'package:flutter/material.dart';

class ArticleDetailView extends StatelessWidget {
  const ArticleDetailView({super.key, required this.body, required this.title});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: <Widget>[
              Text(title, style: const TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              Text(body, style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}
