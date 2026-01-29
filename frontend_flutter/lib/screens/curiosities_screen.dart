import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../styles/theme.dart';

class CuriositiesScreen extends StatelessWidget {
  final List<Map<String, String>> facts = [
    {"title": "Real Name", "content": "Yoshi's full scientific name is T. Yoshisaur Munchakoopas."},
    {"title": "Debut", "content": "Yoshi first appeared in Super Mario World (SNES) in 1990."},
    {"title": "Colors", "content": "Yoshis come in many colors: Red, Blue, Yellow, Pink, and even Black/White!"},
    {"title": "Island Life", "content": "Yoshi's Island is surrounded by the sea and full of happy fruits called Super Happy Tree fruits."},
    {"title": "Language", "content": "Yoshi's language is often translated in parentheses, but 'Yoshi!' usually means 'Yes' or 'Hello!'."},
  ];

   CuriositiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yoshi Fun Facts")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: facts.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shadowColor: YoshiTheme.yoshiGreen.withOpacity(0.4),
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.white, YoshiTheme.yoshiBellyWhite],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: YoshiTheme.yoshiLightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${index + 1}",
                    style: GoogleFonts.fredoka(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(facts[index]['title']!, style: GoogleFonts.fredoka(fontSize: 18, color: YoshiTheme.yoshiGreen)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(facts[index]['content']!, style: GoogleFonts.nunito(fontSize: 16)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
