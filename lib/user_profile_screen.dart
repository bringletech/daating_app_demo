import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:swipeimages/swipe_card.dart';

class UserProfileScreen extends StatefulWidget {
  final Profile profile;

  const UserProfileScreen({super.key, required this.profile});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isEditing = false;

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController locationController;
  late TextEditingController bioController;
  late TextEditingController phoneController;
  late TextEditingController moodController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    ageController = TextEditingController(text: widget.profile.age.toString());
    locationController = TextEditingController(text: widget.profile.location);
    bioController = TextEditingController(text: widget.profile.bio);
    phoneController = TextEditingController(text: widget.profile.phoneNumber);
    moodController = TextEditingController(text: widget.profile.mood);
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    locationController.dispose();
    bioController.dispose();
    phoneController.dispose();
    moodController.dispose();
    super.dispose();
  }

  Widget _buildInfoRow(IconData icon, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.pinkAccent, size: 22),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildEditableField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16,color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.white),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;

                if (!isEditing) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile updated")),
                  );
                }
              });
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxContentWidth = constraints.maxWidth > 600 ? 500 : constraints.maxWidth * 0.95;

          return Stack(
            children: [
              // Gradient background
              // Container(
              //   height: size.height * 0.35,
              //   decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [Colors.pinkAccent, Colors.orangeAccent],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //   ),
              // ),
              Container(
                height: size.height * 0.35,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/valentine_concept.jpg'), // 👉 your cover image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Profile photo
                          CircleAvatar(
                            radius: 90,
                            backgroundImage: AssetImage(widget.profile.image),
                          ),
                          const SizedBox(height: 90),

                          // Name + age + location
                          isEditing
                              ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                _buildEditableField(nameController, 'Name'),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildEditableField(
                                          ageController, 'Age',
                                          keyboardType: TextInputType.number),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildEditableField(
                                          locationController, 'Location'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                              : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Text(
                                  nameController.text,
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${ageController.text} • ${locationController.text}",
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Glass card
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: isDark ? Colors.black45 : Colors.white.withOpacity(0.3),
                              backgroundBlendMode: BlendMode.overlay,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow(
                                      Icons.info_outline,
                                      isEditing
                                          ? _buildEditableField(bioController, 'Bio', maxLines: 2)
                                          : Text(bioController.text,
                                          style: const TextStyle(fontSize: 16)),
                                    ),
                                    _buildInfoRow(
                                      Icons.phone,
                                      isEditing
                                          ? _buildEditableField(phoneController, 'Phone',
                                          keyboardType: TextInputType.phone)
                                          : Text(phoneController.text,
                                          style: const TextStyle(fontSize: 16)),
                                    ),
                                    _buildInfoRow(
                                      Icons.emoji_emotions,
                                      isEditing
                                          ? _buildEditableField(moodController, 'Mood')
                                          : Text("Mood: ${moodController.text}",
                                          style: const TextStyle(fontSize: 16)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
