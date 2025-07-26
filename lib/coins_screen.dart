import 'package:flutter/material.dart';

class CoinStoreScreen extends StatefulWidget {
  final bool isDarkMode;

  const CoinStoreScreen({super.key, this.isDarkMode = false});

  @override
  State<CoinStoreScreen> createState() => _CoinStoreScreenState();
}

class _CoinStoreScreenState extends State<CoinStoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
        title: Row(
          children: [
            const Spacer(),
            const Icon(Icons.timer, size: 18),
            const SizedBox(width: 4),
            const Text("x1"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Best Offers",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
                children: offerList.map((offer) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.monetization_on,
                                    color: Colors.amber, size: 18),
                                const SizedBox(width: 2),
                                Text(
                                  offer['coins'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Image.asset(
                              offer['image'],
                              height: 50,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              offer['price'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              offer['oldPrice'],
                              style: const TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      if (offer['tag'] != null)
                        Positioned(
                          top: -10,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: offer['tagColor'],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                if (offer['tagIcon'] != null)
                                  Icon(offer['tagIcon'],
                                      size: 12, color: Colors.white),
                                if (offer['tagIcon'] != null)
                                  const SizedBox(width: 4),
                                Text(
                                  offer['tag'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Sample data (replace image paths with your assets)
final List<Map<String, dynamic>> offerList = [
  {
    'coins': '100',
    'image': 'assets/images/coins.png',
    'price': '₹51.99',
    'oldPrice': '₹103.98',
  },
  {
    'coins': '250',
    'image': 'assets/images/coins6.png',
    'price': '₹104.99',
    'oldPrice': '₹262.47',
    'tag': 'Best Value',
    'tagColor': Colors.orange,
    'tagIcon': Icons.thumb_up_alt,
  },
  {
    'coins': '450',
    'image': 'assets/images/coins6.png',
    'price': '₹209.99',
    'oldPrice': '₹472.48',
  },
  {
    'coins': '1 125',
    'image': 'assets/images/coins6.png',
    'price': '₹529.99',
    'oldPrice': '₹1,192.48',
  },
  {
    'coins': '2 500',
    'image': 'assets/images/coins6.png',
    'price': '₹1,049.99',
    'oldPrice': '₹2,624.98',
    'tag': 'Popular',
    'tagColor': Colors.pink,
    'tagIcon': Icons.star,
  },
  {
    'coins': '3 000',
    'image': 'assets/images/coins6.png',
    'price': '₹1,569.99',
    'oldPrice': '₹3,139.98',
  },
];