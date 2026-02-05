import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  
  bool obscureText = true;
  bool isLoading = false;

  // Fungsi Utama Login & Routing
  Future<void> signIn() async {
    // Validasi input kosong
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar("Email dan Password tidak boleh kosong", Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      // 1. Proses Sign In ke Supabase Auth
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user != null) {
        // 2. Ambil data role dari tabel 'profiles' berdasarkan UID user
        final userData = await supabase
            .from('profiles')
            .select('role')
            .eq('id_user', response.user!.id)
            .single();

        String role = userData['role'];

        if (!mounted) return;

        // 3. Navigasi sesuai Role
        if (role == 'admin') {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const AdminPage()));
        } else if (role == 'petugas') {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const ApprovalPage()));
        } else {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const PeminjamPage()));
        }
      }
    } on AuthException catch (error) {
      _showSnackBar(error.message, Colors.red);
    } catch (error) {
      _showSnackBar("Terjadi kesalahan tak terduga", Colors.red);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Hi, Selamat Datang!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Input Email
              _buildInputLabel("Email"),
              const SizedBox(height: 5),
              _buildTextField(
                controller: emailController,
                hint: "Masukkan Email",
                isPass: false,
              ),

              const SizedBox(height: 20),

              // Input Password
              _buildInputLabel("Password"),
              const SizedBox(height: 5),
              _buildTextField(
                controller: passwordController,
                hint: "Masukkan Password",
                isPass: true,
              ),

              const SizedBox(height: 30),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: isLoading ? null : signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk Label
  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.green[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget Helper untuk TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isPass,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPass ? obscureText : false,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPass
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => obscureText = !obscureText),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }
}