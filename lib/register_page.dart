import 'package:flutter/material.dart';
import 'dart:math';

class RegisterPage extends StatefulWidget {
  final Map<String, Map<String, String>> userDatabase;

  const RegisterPage({
    Key? key,
    required this.userDatabase,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();

  // 💡 --- TAMBAHAN UNTUK ANIMASI KLIK ---
  double _daftarButtonScale = 1.0;
  double _masukButtonScale = 1.0;
  // ------------------------------------

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    final nama = _namaController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final konfirmasiPassword = _konfirmasiPasswordController.text;

    if (nama.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        konfirmasiPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field tidak boleh kosong!'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format email tidak valid.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }
    if (password.length < 6) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password minimal 6 karakter.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }
    if (password != konfirmasiPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan Konfirmasi Password tidak cocok!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (widget.userDatabase.containsKey(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email ini sudah terdaftar. Silakan gunakan email lain.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    widget.userDatabase[email] = {
      'password': password,
      'name': nama,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registrasi berhasil! Silakan login.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.cyanAccent),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Colors.pinkAccent, width: 1.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Colors.cyanAccent, width: 2.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF050A1E),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(Colors.deepPurple, Colors.cyan,
                          (sin(_animation.value) + 1) / 2)!,
                      Color.lerp(Colors.cyan, Colors.pinkAccent,
                          (cos(_animation.value) + 1) / 2)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Bungkus dengan SingleChildScrollView agar tidak overflow keyboard
              SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 30),
                    margin: const EdgeInsets.symmetric(vertical: 40), // margin
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B0E1A).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        width: 4,
                        color: Colors.transparent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.4),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_add_alt_1_rounded,
                            color: Colors.cyanAccent, size: 70),
                        const SizedBox(height: 15),
                        const Text(
                          "NeonTech Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.cyanAccent, blurRadius: 10)
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        _buildTextField(
                          controller: _namaController,
                          label: "Nama Lengkap",
                          icon: Icons.person,
                        ),
                        _buildTextField(
                          controller: _emailController,
                          label: "Email",
                          icon: Icons.email_outlined,
                        ),
                        _buildTextField(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),
                        _buildTextField(
                          controller: _konfirmasiPasswordController,
                          label: "Konfirmasi Password",
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),
                        const SizedBox(height: 25),
                        
                        // 💡 --- PERUBAHAN 1: Tombol Daftar (Bungkus dengan Animasi) ---
                        AnimatedScale(
                          scale: _daftarButtonScale,
                          duration: const Duration(milliseconds: 150),
                          child: GestureDetector(
                            onTapDown: (_) =>
                                setState(() => _daftarButtonScale = 0.95),
                            onTapCancel: () =>
                                setState(() => _daftarButtonScale = 1.0),
                            onTapUp: (_) {
                              setState(() => _daftarButtonScale = 1.0);
                              _register(); // Panggil fungsi register
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.cyanAccent,
                                    Colors.blueAccent
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyanAccent.withOpacity(0.5),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Center( // Ganti TextButton jadi Center
                                child: Text(
                                  "Daftar Sekarang",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // ----------------------------------------------------

                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sudah punya akun? ",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                            
                            // 💡 --- PERUBAHAN 2: Tombol Masuk (Bungkus dengan Animasi) ---
                            AnimatedScale(
                              scale: _masukButtonScale,
                              duration: const Duration(milliseconds: 150),
                              child: GestureDetector(
                                onTapDown: (_) =>
                                    setState(() => _masukButtonScale = 0.95),
                                onTapCancel: () =>
                                    setState(() => _masukButtonScale = 1.0),
                                onTapUp: (_) {
                                  setState(() => _masukButtonScale = 1.0);
                                  Navigator.pop(context); // Kembali ke login
                                },
                                child: const Padding(
                                  // Tambah padding agar area klik lebih besar
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Masuk Sekarang",
                                    style: TextStyle(
                                      color: Colors.pinkAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // ----------------------------------------------------
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}