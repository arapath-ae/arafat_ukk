import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Sans-Serif'),
      home: const PeminjamPage(),
    );
  }
}

class PeminjamPage extends StatelessWidget {
  const PeminjamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER SECTION ---
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
                          Text('P O U', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('peminjam', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                  const Icon(Icons.arrow_back, color: Colors.green, size: 30),
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
                    hintText: 'Cari barang',
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

            // --- CATEGORY TABS ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  _buildTab(Colors.green, isSelected: true),
                  const SizedBox(width: 10),
                  _buildTab(Colors.grey[300]!),
                  const SizedBox(width: 10),
                  _buildTab(Colors.grey[300]!),
                ],
              ),
            ),

            // --- ITEM LIST CARD ---
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(15),
                  children: [
                    _buildItemRow('Monitor'),
                    _buildItemRow('Keyboard'),
                    _buildItemRow('Mouse'),
                    _buildItemRow('PC Case'),
                  ],
                ),
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
            Icon(Icons.inventory_2_outlined, color: Colors.green, size: 32),
            Icon(Icons.account_circle_outlined, color: Colors.green, size: 32),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Kotak Kategori
  Widget _buildTab(Color color, {bool isSelected = false}) {
    return Container(
      height: 40,
      width: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Widget Helper untuk Baris Item
  Widget _buildItemRow(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.greenAccent[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.computer, size: 40, color: Colors.black54),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: const Size(100, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          )
        ],
      ),
    );
  }
}