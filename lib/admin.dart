import 'package:flutter/material.dart';
import 'package:ukk/supabase_config.dart';
import 'package:ukk/login.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk list barang
    final List<Map<String, String>> items = [
      {'nama': 'Monitor LG', 'image': 'https://via.placeholder.com/100'},
      {'nama': 'Keyboard Mechanical', 'image': 'https://via.placeholder.com/100'},
      {'nama': 'Mouse Gaming', 'image': 'https://via.placeholder.com/100'},
      {'nama': 'PC Case', 'image': 'https://via.placeholder.com/100'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Profile
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.person, color: Colors.grey[400]),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('M A S', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('admin', style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                  // Tombol Logout
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: () async {
                      await supabase.auth.signOut();
                      if (context.mounted) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                      }
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari barang',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // List Barang
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(Icons.computer, size: 40, color: Colors.black54),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(items[index]['nama']!, 
                                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _actionButton(Icons.edit, Colors.grey[300]!),
                                    const SizedBox(width: 10),
                                    _actionButton(Icons.delete, Colors.red[100]!, iconColor: Colors.red),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: ''),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, Color bgColor, {Color iconColor = Colors.grey}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}