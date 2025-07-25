// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:swipeimages/swipe_card.dart';
import 'dart:math';

class ChatScreen extends StatelessWidget {
  final Profile profile;

  const ChatScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink.shade200,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(profile.image),
            ),
            const SizedBox(width: 10),
            Text(profile.name,style: TextStyle(color: Colors.white),),
            const Spacer(),

            IconButton(
              icon: const Icon(Icons.videocam,color: Colors.white,),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Video Call feature coming soon!',style: TextStyle(color: Colors.white),),backgroundColor: Colors.pink.shade200,),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.call,color: Colors.white,),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Voice Call feature coming soon!',style: TextStyle(color: Colors.white),),backgroundColor: Colors.pink.shade200,),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Romantic pink gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFE4E1), Color(0xFFFFC0CB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Floating heart icons
          const Positioned.fill(
            child: AnimatedBackgroundHearts(),
          ),

          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 24),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ChatBubble(
                        text: "Hi! Nice to meet you 👋",
                        isMe: false,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ChatBubble(
                        text: "Nice to meet you too! 😊",
                        isMe: true,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Type a message... 💬',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Colors.pinkAccent,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const ChatBubble({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? Colors.pink.shade100 : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class AnimatedBackgroundHearts extends StatefulWidget {
  const AnimatedBackgroundHearts({Key? key}) : super(key: key);

  @override
  State<AnimatedBackgroundHearts> createState() => _AnimatedBackgroundHeartsState();
}

class _AnimatedBackgroundHeartsState extends State<AnimatedBackgroundHearts> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: HeartPainter(animationValue: _controller.value),
        );
      },
    );
  }
}

class HeartPainter extends CustomPainter {
  final double animationValue;
  final Random random = Random();

  HeartPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final icon = Icons.favorite;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < 30; i++) {
      final dx = size.width * (i / 30) + 20 * sin(animationValue * 5 * pi + i);
      final dy = size.height * (1.0 - ((animationValue + i / 30) % 1.0));

      final iconSize = 20.0 + 5 * sin((animationValue + i) * pi);
      final heart = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.pinkAccent.withOpacity(0.6 + 0.4 * sin(i + animationValue * 5)),
        ),
      );

      textPainter.text = heart;
      textPainter.layout();
      textPainter.paint(canvas, Offset(dx, dy));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
