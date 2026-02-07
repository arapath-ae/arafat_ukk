import 'package:flutter/material.dart';
import 'package:ukk/supabase_config.dart';
import 'package:ukk/login.dart';

class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.person, color: Colors.grey[400], size: 35),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('M B A K', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('petugas', style: TextStyle(color: Colors.grey, fontSize: 14)),
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

            // --- SEARCH BAR ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(25, 20, 25, 10),
              child: Text('Menunggu Persetujuan', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
            ),

            // --- LIST PERSETUJUAN ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildApprovalCard('Monitor', '28 - 29 januari 2026', '3'),
                  _buildApprovalCard('Keyboard', '29 - 31 januari 2026', '5'),
                  _buildApprovalCard('Mouse', '28 - 29 januari 2026', '3'),
                  _buildApprovalCard('CPU', '29 - 31 januari 2026', '5'),
                ],
              ),
            ),
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, color: Colors.green, size: 32),
            Icon(Icons.people, color: Colors.green, size: 32),
            Icon(Icons.account_circle, color: Colors.green, size: 32),
            Icon(Icons.pie_chart_outline, color: Colors.green, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalCard(String item, String date, String qty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('POU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Pinjam $date', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(item, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text('Sewa $qty', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Setuju', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Tolak', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}