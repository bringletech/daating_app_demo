// Enhanced Swipe Card UI with Glass Blur & Animations
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scrumlab_flutter_tindercard/scrumlab_flutter_tindercard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'chat_screen.dart';

class Profile {
  final String image;
  final String name;
  final int age;
  final String location;
  final int distance;
  final String bio;
  final String phoneNumber;
  final String mood;

  Profile({
    required this.image,
    required this.name,
    required this.age,
    required this.location,
    required this.distance,
    required this.bio,
    required this.phoneNumber,
    required this.mood,
  });
}

final Map<String, String> moodSounds = {
  'romantic': 'sounds/wind.mp3',
};

final Map<String, Animation<double> Function(AnimationController)> moodAnimations = {
  'romantic': (controller) => Tween<double>(begin: 1.0, end: 1.05).animate(
    CurvedAnimation(parent: controller, curve: Curves.easeInOut),
  ),
};

class SwipeCardExample extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const SwipeCardExample({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<SwipeCardExample> createState() => _SwipeCardExampleState();
}

class _SwipeCardExampleState extends State<SwipeCardExample> with SingleTickerProviderStateMixin {
  late CardController controller;
  String swipeDirection = '';
  bool showHeart = false;
  int currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _moodAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Profile> masterList = [
    Profile(image: 'assets/images/img_1.jpg', name: 'Priya Sharma', age: 24, location: 'Delhi', distance: 3, bio: 'Loves traveling & coffee ☕ | Dog mom 🐶', phoneNumber: '+911234567890', mood: 'romantic'),
    Profile(image: 'assets/images/img_2.jpeg', name: 'Ananya Verma', age: 26, location: 'Mumbai', distance: 5, bio: 'Bookworm 📚 | Music is life 🎷 | Plant lover 🌿', phoneNumber: '+911234567891', mood: 'romantic'),
    Profile(image: 'assets/images/img_3.jpg', name: 'Kavya Reddy', age: 23, location: 'Hyderabad', distance: 2, bio: 'Salsa dancer 💃 | Foodie 🍕 | Nature walks 🌳', phoneNumber: '+911234567892', mood: 'romantic'),
    Profile(image: 'assets/images/img_4.webp', name: 'Megha Patel', age: 25, location: 'Ahmedabad', distance: 7, bio: 'Gym rat 💪 | Night owl 🌙 | Fashionista 👗', phoneNumber: '+911234567893', mood: 'romantic'),
    Profile(image: 'assets/images/img_5.jpg', name: 'Simran Kaur', age: 27, location: 'Chandigarh', distance: 1, bio: 'Poetry ✍ | Road trips 🚗 | Netflix binge watcher 🎬', phoneNumber: '+911234567894', mood: 'romantic'),
  ];

  List<Profile> profiles = [];
  final List<Profile> removedProfiles = [];
  final List<Profile> likedProfiles = [];

  @override
  void initState() {
    super.initState();
    controller = CardController();
    loadProfiles();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
    playMoodSound();
  }

  void playMoodSound() async {
    final mood = profiles.isNotEmpty ? profiles[currentIndex].mood : null;
    final sound = mood != null ? moodSounds[mood] : null;
    if (sound != null) {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(sound));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void loadProfiles() {
    profiles = masterList.where((p) => !removedProfiles.contains(p)).toList();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future<void> _startVideoCall() async {
    final Uri url = Uri.parse('https://meet.google.com/new');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }

  Widget swipeIcon(String text, Color color) {
    return Transform.rotate(
      angle: -0.3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget actionButton(IconData icon, Color color, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 32,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, size: 28, color: color),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: color, fontSize: 12))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.pink.shade50,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.pink.shade50,
        title: const Text('💕 Discover Love'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => widget.toggleTheme(!isDarkMode),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: TinderSwapCard(
                        orientation: AmassOrientation.bottom,
                        totalNum: profiles.length,
                        stackNum: 3,
                        swipeEdge: 3.0,
                        maxWidth: MediaQuery.of(context).size.width * 0.92,
                        maxHeight: MediaQuery.of(context).size.height * 0.64,
                        minWidth: MediaQuery.of(context).size.width * 0.86,
                        minHeight: MediaQuery.of(context).size.height * 0.58,
                        cardBuilder: (context, index) {
                          final profile = profiles[index];
                          currentIndex = index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            child: Stack(
                              children: [
                                Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  clipBehavior: Clip.antiAlias,
                                  child: Stack(
                                    children: [
                                      Image.asset(profile.image, fit: BoxFit.cover, width: double.infinity),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: ClipRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.4),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${profile.name}, ${profile.age}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 6),
                                                  Text('${profile.location} • ${profile.distance} km away', style: TextStyle(color: Colors.white70, fontSize: 16)),
                                                  const SizedBox(height: 8),
                                                  Text(profile.bio, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 20,
                                        right: 20,
                                        child: Column(
                                          children: [
                                            FloatingActionButton(
                                              heroTag: 'call_${profile.name}',
                                              mini: true,
                                              backgroundColor: Colors.greenAccent.withOpacity(0.9),
                                              child: Icon(Icons.call, color: Colors.white),
                                              onPressed: () => _makePhoneCall(profile.phoneNumber),
                                            ),
                                            const SizedBox(height: 10),
                                            FloatingActionButton(
                                              heroTag: 'video_${profile.name}',
                                              mini: true,
                                              backgroundColor: Colors.blueAccent.withOpacity(0.9),
                                              child: Icon(Icons.video_call, color: Colors.white),
                                              onPressed: _startVideoCall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (swipeDirection == 'left') Positioned(top: 40, left: 20, child: swipeIcon("❌ NOPE", Colors.red)),
                                if (swipeDirection == 'right') Positioned(top: 40, right: 20, child: swipeIcon("❤️ LIKE", Colors.green)),
                                if (showHeart) const Center(child: Icon(Icons.favorite, color: Colors.red, size: 80)),
                              ],
                            ),
                          );
                        },
                        cardController: controller,
                        swipeUpdateCallback: (details, align) {
                          setState(() {
                            if (align.x < -5) swipeDirection = 'left';
                            else if (align.x > 5) swipeDirection = 'right';
                            else swipeDirection = '';
                          });
                        },
                        swipeCompleteCallback: (orientation, index) {
                          setState(() {
                            swipeDirection = '';
                            if (orientation == CardSwipeOrientation.right) {
                              showHeart = true;
                              final profile = profiles[index];
                              if (!likedProfiles.contains(profile)) {
                                likedProfiles.add(profile);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(profile: profile)));
                                Vibration.vibrate(duration: 100);
                              }
                              Future.delayed(const Duration(milliseconds: 600), () => setState(() => showHeart = false));
                            }
                            removedProfiles.add(profiles[index]);
                            playMoodSound();
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        actionButton(Icons.undo, Colors.orange, "Undo", () {
                          if (removedProfiles.isNotEmpty) {
                            final last = removedProfiles.removeLast();
                            setState(() {
                              profiles.insert(currentIndex, last);
                              likedProfiles.remove(last);
                            });
                          }
                        }),
                        actionButton(Icons.close, Colors.red, "Nope", () => controller.triggerLeft()),
                        actionButton(Icons.star, Colors.purpleAccent, "Super", () => controller.triggerUp()),
                        actionButton(Icons.favorite, likedProfiles.contains(profiles[currentIndex]) ? Colors.red : Colors.green, "Like", () {
                          if (!likedProfiles.contains(profiles[currentIndex])) {
                            controller.triggerRight();
                          }
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
