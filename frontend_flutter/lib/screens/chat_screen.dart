import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../services/api_service.dart';
import '../styles/theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String _currentStreamResponse = "";

  void _sendMessage({String? text}) {
    final messageText = text ?? _controller.text.trim();
    if (messageText.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': messageText});
      _isLoading = true;
      _currentStreamResponse = "";
      if (text == null) _controller.clear();
    });

    try {
      ApiService.sendMessageStream(messageText).listen(
        (chunk) {
          setState(() {
            _currentStreamResponse += chunk;
          });
        },
        onDone: () {
          setState(() {
             _messages.add({'role': 'yoshi', 'content': _currentStreamResponse});
             _currentStreamResponse = "";
             _isLoading = false;
          });
        },
        onError: (error) {
           setState(() {
             _messages.add({'role': 'yoshi', 'content': "Error: $error"});
             _isLoading = false;
          });
        }
      );
    } catch (e) {
       setState(() {
         _messages.add({'role': 'yoshi', 'content': "Connection Failed."});
         _isLoading = false;
       });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Talk to Yoshi")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                   // Loading Indicator
                   if (_currentStreamResponse.isNotEmpty) {
                     return _buildBubble("yoshi", _currentStreamResponse, true);
                   } else {
                     return _buildSkeleton();
                   }
                }
                final msg = _messages[index];
                return _buildBubble(msg['role']!, msg['content']!, false);
              },
            ),
          ),
          if (_messages.isEmpty)
             _buildSuggestions(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        children: [
          _suggestionChip("Tell me a story!", "Tell me a happy story about Mario!"),
          _suggestionChip("I'm sad...", "I am feeling sad today."),
          _suggestionChip("Who are you?", "Who are you?"),
        ],
      ),
    );
  }

  Widget _suggestionChip(String label, String query) {
    return ActionChip(
      label: Text(label, style: GoogleFonts.fredoka(color: Colors.white)),
      backgroundColor: YoshiTheme.yoshiLightGreen,
      onPressed: () => _sendMessage(text: query),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Say something to Yoshi...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                filled: true,
                fillColor: YoshiTheme.yoshiBellyWhite,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: YoshiTheme.yoshiGreen,
            elevation: 2,
            onPressed: _isLoading ? null : () => _sendMessage(),
            child: _isLoading 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
              : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(12),
          width: 200,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(String role, String content, bool isStreaming) {
    final isYoshi = role == 'yoshi';
    return Align(
      alignment: isYoshi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isYoshi ? YoshiTheme.yoshiGreen : Colors.white,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomLeft: isYoshi ? Radius.zero : const Radius.circular(20),
            bottomRight: isYoshi ? const Radius.circular(20) : Radius.zero,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: isYoshi 
          ? MarkdownBody(
              data: content + (isStreaming ? " 🦖" : ""), 
              styleSheet: MarkdownStyleSheet(
                 p: GoogleFonts.nunito(color: Colors.white, fontSize: 16),
                 strong: GoogleFonts.nunito(color: Colors.yellow, fontWeight: FontWeight.bold),
              ),
            ) 
          : Text(content, style: GoogleFonts.nunito(color: YoshiTheme.darkText, fontSize: 16)),
      ),
    );
  }
}
