import 'package:flutter/material.dart';

void main() => runApp(const MynzoSocialApp());

class MynzoSocialApp extends StatelessWidget {
  const MynzoSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mynzo - My Social World',
      theme: ThemeData(
        useMaterial3: true, 
        colorSchemeSeed: const Color(0xFF33363F),
      ),
      debugShowCheckedModeBanner: false,
      home: const InstagramProfileScreen(),
    );
  }
}

class InstagramProfileScreen extends StatelessWidget {
  const InstagramProfileScreen({super.key});

  // 30 लोगों (Mynzo Members) की इंस्टाग्राम जैसी ऑटो-डेटा लिस्ट
  List<Map<String, dynamic>> _generateProfiles() {
    return List.generate(30, (index) {
      int id = index + 1;
      return {
        "id": id,
        "username": "mynzo_world_$id",
        "name": "Mynzo Member $id",
        "bio": "Building my social world on Mynzo Platform 🌐 | Member #$id",
        "followers": 1200 + (id * 45),
        "following": 300 + (id * 7),
        "posts": 10 + id,
        "avatar": "https://dicebear.com"
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final profiles = _generateProfiles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            // आपके द्वारा अपलोड की जाने वाली logo.png इमेज यहाँ लोड होगी
            Image.asset(
              'assets/images/logo.png', 
              height: 35, 
              errorBuilder: (c, e, s) {
                // अगर इमेज लोड होने में कोई दिक्कत आए, तो बैकअप के लिए यह आइकॉन दिखेगा
                return const Icon(Icons.blur_circular, color: Colors.purple, size: 30);
              },
            ),
            const SizedBox(width: 10),
            const Text(
              'Mynzo Social Network', 
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
      body: ListView.separated(
        itemCount: profiles.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
        itemBuilder: (context, index) {
          final user = profiles[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // यूजर्स की प्रोफाइल पिक्चर (Dicebear API से ऑटो-जेनरेटेड)
                    CircleAvatar(
                      radius: 26, 
                      backgroundColor: Colors.purple.shade100, 
                      backgroundImage: NetworkImage(user['avatar']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("@${user['username']}", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                        ],
                      ),
                    ),
                    // इंस्टाग्राम जैसा ब्लू फॉलो बटन
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0095F6),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      ),
                      child: const Text('Follow', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(user['bio'], style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 10),
                // पोस्ट्स, फॉलोअर्स और फॉलोइंग के आंकड़े (Stats)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildStat("${user['posts']}", "Posts"),
                    const SizedBox(width: 24),
                    _buildStat("${user['followers']}", "Followers"),
                    const SizedBox(width: 24),
                    _buildStat("${user['following']}", "Following"),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // स्टेट्स का डिजाइन बनाने के लिए हेल्पर विजेट
  Widget _buildStat(String value, String label) {
    return Row(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }
}
