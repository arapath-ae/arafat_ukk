import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gantilah URL dan Anon Key dengan milik proyek Supabase-mu
  await Supabase.initialize(
    url: 'https://sqhppuqezjqsxmmqljwl.supabase.co',
    anonKey: 'sb_publishable_aRPVmuvtdsnlOel2AOfr4w_J5cC2IBr',
  );

  runApp(const MyApp());
}

// Client Supabase global
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventaris App',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Sans-Serif'),
      home: const LoginPage(),
    );
  }
}

// --- 1. HALAMAN LOGIN DENGAN LOGIKA ROLE ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;

  Future<void> signIn() async {
    setState(() => isLoading = true);
    try {
      // Login ke Supabase Auth
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user != null) {
        // Ambil data role dari tabel public.profiles
        final userData = await supabase
            .from('profiles')
            .select('role')
            .eq('id_user', response.user!.id)
            .single();

        String role = userData['role'];

        if (!mounted) return;

        // Navigasi berdasarkan role
        if (role == 'admin') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminPage()));
        } else if (role == 'petugas') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ApprovalPage()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PeminjamPage()));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Gagal: ${e.toString()}"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Text("Hi, Selamat Datang!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              _buildTextField("Email", emailController, false),
              const SizedBox(height: 20),
              _buildTextField("Password", passwordController, true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: isLoading ? null : signIn,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isPass) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPass ? obscureText : false,
          decoration: InputDecoration(
            hintText: "Masukkan $label",
            suffixIcon: isPass ? IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => obscureText = !obscureText),
            ) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.green), borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

// --- 2. HALAMAN ADMIN ---
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(context, "M A S", "admin"),
            _buildSearchBar(),
            Expanded(child: _buildListContainer([
              _buildItemRow("Monitor", isPeminjam: false),
              _buildItemRow("Keyboard", isPeminjam: false),
            ])),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, backgroundColor: Colors.greenAccent, child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomNav(5),
    );
  }
}

// --- 3. HALAMAN PEMINJAM ---
class PeminjamPage extends StatelessWidget {
  const PeminjamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(context, "P O U", "peminjam"),
            _buildSearchBar(),
            _buildTabs(),
            Expanded(child: _buildListContainer([
              _buildItemRow("Monitor", isPeminjam: true),
              _buildItemRow("Keyboard", isPeminjam: true),
            ])),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(3),
    );
  }
}

// --- 4. HALAMAN PETUGAS (APPROVAL) ---
class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(context, "M B A K", "petugas"),
            _buildSearchBar(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("Menunggu Persetujuan", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildApprovalCard("Monitor", "28 - 29 Jan 2026"),
                _buildApprovalCard("Keyboard", "29 - 31 Jan 2026"),
              ],
            )),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(4),
    );
  }
}

// --- REUSABLE WIDGETS ---

Widget _buildCustomHeader(BuildContext context, String name, String role) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(role, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.green),
          onPressed: () async {
            await supabase.auth.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
          },
        )
      ],
    ),
  );
}

Widget _buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Cari barang",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
  );
}

Widget _buildTabs() {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Row(children: [
      Container(width: 60, height: 30, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5))),
      const SizedBox(width: 10),
      Container(width: 60, height: 30, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5))),
    ]),
  );
}

Widget _buildListContainer(List<Widget> children) {
  return Container(
    margin: const EdgeInsets.all(20),
    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)),
    child: ListView(padding: const EdgeInsets.all(10), children: children),
  );
}

Widget _buildItemRow(String name, {required bool isPeminjam}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(children: [
      Container(width: 80, height: 80, color: Colors.greenAccent[100], child: const Icon(Icons.computer)),
      const SizedBox(width: 15),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name),
        const SizedBox(height: 5),
        isPeminjam 
          ? ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text("Tambah", style: TextStyle(color: Colors.white)))
          : Row(children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit, color: Colors.grey)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.red)),
            ]),
      ])
    ]),
  );
}

Widget _buildApprovalCard(String item, String date) {
  return Card(
    margin: const EdgeInsets.only(bottom: 15),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("POU\n$date", style: const TextStyle(fontSize: 12)),
          Text(item, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text("Setuju"))),
          const SizedBox(width: 10),
          Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Tolak"))),
        ]),
      ]),
    ),
  );
}

Widget _buildBottomNav(int count) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.green,
    items: List.generate(count, (index) => const BottomNavigationBarItem(icon: Icon(Icons.home), label: "")),
  );
}