import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../styles/theme.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Who is Yoshi?")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              "The Friendly Dinosaur",
              "Yoshi (T. Yoshisaur Munchakoopas) is a green dinosaur from the Mushroom Kingdom. He is known for his long tongue, appetite, and ability to lay eggs!",
            ),
             _buildSection(
              context,
              "Home Sweet Home",
              "Yoshi lives on Yoshi's Island, a tropical paradise full of fruit and friendly friends.",
            ),
             _buildSection(
              context,
              "Super Powers",
              "• Flutter Jump: Defying gravity!\n• Eating Enemies: Mlem!\n• Throwing Eggs: Pow!",
            ),
            const SizedBox(height: 20),
            Center(
               child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                  image: DecorationImage(
                    image: AssetImage('assets/images/yoshi_group.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: YoshiTheme.yoshiGreen),
              SizedBox(width: 10),
              Text(title, style: GoogleFonts.fredoka(fontSize: 22, color: YoshiTheme.yoshiGreen)),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: GoogleFonts.nunito(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }
}
