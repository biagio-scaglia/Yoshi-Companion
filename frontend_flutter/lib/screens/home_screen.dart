import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../styles/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yoshi's Island Home")),
      body: Stack(
        children: [
          // Decorative Background Circles
          Positioned(
            top: -50,
            left: -50,
            child: CircleAvatar(radius: 100, backgroundColor: YoshiTheme.yoshiLightGreen.withOpacity(0.5)),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: CircleAvatar(radius: 120, backgroundColor: YoshiTheme.skyBlue.withOpacity(0.3)),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Placeholder for Yoshi Image with Shadow
                  Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: YoshiTheme.yoshiGreen, width: 6),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))],
                    ),
                    child: Center(
                       child: ClipOval(
                         child: Image.asset(
                           'assets/images/yoshi_icon.jpg',
                           height: 210,
                           width: 210,
                           fit: BoxFit.cover,
                         ),
                       ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Welcome to Yoshi's World!",
                    style: GoogleFonts.fredoka(fontSize: 28, color: YoshiTheme.darkText),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Yoshi is here to make your day better. Explore the island or chat with him!",
                    style: GoogleFonts.nunito(fontSize: 18, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Daily Quote Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: YoshiTheme.yoshiBootsOrange.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 4))],
                      border: Border.all(color: YoshiTheme.yoshiBootsOrange.withOpacity(0.5), width: 1),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lightbulb, color: YoshiTheme.yoshiBootsOrange),
                            SizedBox(width: 8),
                            Text("Yoshi's Thought of the Day", style: GoogleFonts.fredoka(fontSize: 20, color: YoshiTheme.yoshiBootsOrange)),
                          ],
                        ),
                        Divider(height: 20, color: YoshiTheme.yoshiBootsOrange.withOpacity(0.3)),
                        Text(
                          "\"Every egg is a new beginning! Wa-hoo!\"",
                          style: GoogleFonts.nunito(fontSize: 18, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
