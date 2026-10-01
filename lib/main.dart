import 'package:flutter/material.dart';

void main() => runApp(const MynzoCompletePlatform());

class MynzoCompletePlatform extends StatelessWidget {
  const MynzoCompletePlatform({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mynzo - My Social World',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF33363F),
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainNavigationScreen(),
    );
  }
}

// ==========================================
// 🧭 मुख्य नेविगेशन कंट्रोलर
// ==========================================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SocialFeedScreen(),
    const SearchAndDiscoverScreen(),
    const MessengerScreen(),
    const MyUserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0095F6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'फीड'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'खोजें'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'चैट'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'प्रोफाइल'),
        ],
      ),
    );
  }
}

// ==========================================
// 📸 1. सोशल फीड स्क्रीन (लाइक, कमेंट, फोटो)
// ==========================================
class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final List<Map<String, dynamic>> _postsData = List.generate(30, (index) {
    int id = index + 1;
    return {
      "id": id,
      "username": "mynzo_star_$id",
      "name": "Mynzo User $id",
      "avatar": "https://dicebear.com",
      "postImage": "https://picsum.photos{id + 10}/600/400",
      "caption": "Mynzo सोशल प्लेटफॉर्म पर आपका स्वागत है! अद्भुत अनुभव। 🌐 #SocialWorld",
      "likes": 200 + (id * 12),
      "isLiked": false,
      "isBookmarked": false,
      "commentsCount": 3 + id,
      "comments": ["बहुत खूब!", "शानदार रील्स और फ़ोटो!"]
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Mynzo Feed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListView.builder(
        itemCount: _postsData.length,
        itemBuilder: (context, index) {
          final post = _postsData[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(post['avatar'])),
                  title: Text(post['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("@${post['username']}"),
                ),
                Image.network(post['postImage'], width: double.infinity, fit: BoxFit.cover),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(post['isLiked'] ? Icons.favorite : Icons.favorite_border, color: post['isLiked'] ? Colors.red : Colors.black),
                      onPressed: () => setState(() {
                        post['isLiked'] = !post['isLiked'];
                        post['isLiked'] ? post['likes']++ : post['likes']--;
                      }),
                    ),
                    IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () => _showComments(context, post)),
                    const Spacer(),
                    IconButton(
                      icon: Icon(post['isBookmarked'] ? Icons.bookmark : Icons.bookmark_border),
                      onPressed: () => setState(() => post['isBookmarked'] = !post['isBookmarked']),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${post['likes']} लाइक्स", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("${post['username']}: ${post['caption']}"),
                      const SizedBox(height: 6),
                      Text("सभी ${post['commentsCount']} कमेंट्स देखें...", style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 12),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _showComments(BuildContext context, Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 350,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('कमेंट्स अनुभाग', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: post['comments'].length,
                  itemBuilder: (c, i) => ListTile(title: Text(post['comments'][i]), leading: const Icon(Icons.account_circle)),
                ),
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'अपनी राय लिखें...', suffixIcon: Icon(Icons.send)),
                onSubmitted: (v) {
                  if (v.trim().isNotEmpty) {
                    setState(() { post['comments'].add(v); post['commentsCount']++; });
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 🔍 2. खोजें और डिस्कवर स्क्रीन
// ==========================================
class SearchAndDiscoverScreen extends StatelessWidget {
  const SearchAndDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mynzo खोजें')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
        itemCount: 30,
        itemBuilder: (c, i) => Image.network("https://picsum.photos{i + 50}/200", fit: BoxFit.cover),
      ),
    );
  }
}

// ==========================================
// 💬 3. रियल-टाइम मैसेंजर (चैट रूम लिस्ट)
// ==========================================
class MessengerScreen extends StatelessWidget {
  const MessengerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mynzo चैट रूम', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("ग्रुप्स (Groups)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.group, color: Colors.white)),
              title: const Text('मायनज़ो ग्लोबल कम्युनिटी ग्रुप'),
              subtitle: const Text('Admin: स्वागत है सभी का!'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const ActiveChatRoom(chatTitle: "ग्लोबल कम्युनिटी")));
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("व्यक्तिगत चैट (Direct Messaging)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ),
            _buildFriendItem(context, 1),
            _buildFriendItem(context, 2),
            _buildFriendItem(context, 3),
            _buildFriendItem(context, 4),
            _buildFriendItem(context, 5),
            _buildFriendItem(context, 6),
            _buildFriendItem(context, 7),
            _buildFriendItem(context, 8),
            _buildFriendItem(context, 9),
            _buildFriendItem(context, 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendItem(BuildContext context, int id) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage("https://dicebear.com")),
      title: Text('Mynzo Friend $id'),
      subtitle: const Text('ऑनलाइन / सक्रिय फ़ीड'),
      trailing: Row(
