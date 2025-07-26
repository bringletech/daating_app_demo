import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:swipeimages/swipe_card.dart';


class LikedProfilesScreen extends StatefulWidget {
  final List<Profile> likedProfiles;

  const LikedProfilesScreen({super.key, required this.likedProfiles});

  @override
  State<LikedProfilesScreen> createState() => _LikedProfilesScreenState();
}

class _LikedProfilesScreenState extends State<LikedProfilesScreen> {
  late List<Profile> profiles;
  Profile? recentlyRemoved;
  int? removedIndex;

  @override
  void initState() {
    super.initState();
    profiles = List.from(widget.likedProfiles);
  }

  void showProfileDialog(Profile profile) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.transparent,
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 400,
          borderRadius: 20,
          blur: 15,
          alignment: Alignment.center,
          border: 1,
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderGradient: LinearGradient(
            colors: [
              Colors.pinkAccent.withOpacity(0.4),
              Colors.purpleAccent.withOpacity(0.2),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(profile.image),
              ),
              const SizedBox(height: 16),
              Text('${profile.name}, ${profile.age}',
                  style: const TextStyle(fontSize: 22,color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(profile.location,
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  profile.bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, height: 1.5,color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close',style: TextStyle(color: Colors.white),),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Liked Profiles', style: TextStyle(color: Colors.white)),
        backgroundColor: isDark ? Colors.black87 : Colors.pinkAccent,
      ),
      body: profiles.isEmpty
          ? const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 60, color: Colors.grey),
            SizedBox(height: 10),
            Text("No liked profiles yet.", style: TextStyle(fontSize: 18)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return Dismissible(
            key: Key(profile.name + profile.age.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            onDismissed: (direction) {
              setState(() {
                recentlyRemoved = profile;
                removedIndex = index;
                profiles.removeAt(index);
              });

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${profile.name} removed from liked profiles'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      if (recentlyRemoved != null && removedIndex != null) {
                        setState(() {
                          profiles.insert(removedIndex!, recentlyRemoved!);
                        });
                      }
                    },
                  ),
                ),
              );
            },
            child: GestureDetector(
              onLongPress: () => showProfileDialog(profile),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GlassmorphicContainer(
                  width: screenWidth,
                  height: 150,
                  borderRadius: 20,
                  blur: 20,
                  alignment: Alignment.center,
                  border: 1,
                  linearGradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.05)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderGradient: LinearGradient(
                    colors: [
                      Colors.pink.withOpacity(0.3),
                      Colors.purpleAccent.withOpacity(0.2)
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(profile.image),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${profile.name}, ${profile.age}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  profile.location,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              profile.bio,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Icon(Icons.favorite, color: Colors.pink),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
