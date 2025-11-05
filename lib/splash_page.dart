import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart'; // Halaman tujuan setelah splash

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

// Gunakan TickerProviderStateMixin untuk 2 AnimationController
class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  
  // Kontroler untuk animasi masuk (fade-in & scale-up)
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  // Kontroler untuk animasi denyut (pulsating glow)
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Warna tema
  static const Color bgColor = Color(0xFF0A0E21);
  static const Color primaryNeon = Colors.cyanAccent;

  @override
  void initState() {
    super.initState();

    // --- Inisialisasi Animasi Masuk (1.5 detik) ---
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );

    // --- Inisialisasi Animasi Denyut (2 detik, berulang) ---
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Berulang dan membalik (membesar-mengecil)

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Mulai animasi masuk
    _entryController.forward();

    // --- Timer untuk Navigasi ---
    // Setelah 3.5 detik, pindah ke halaman login
    Timer(const Duration(milliseconds: 3500), _navigateToLogin);
  }

  void _navigateToLogin() {
    if (!mounted) return; // Pastikan widget masih ada

    // Gunakan PageRouteBuilder untuk transisi FADE-OUT yang mulus
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        // Waktu transisi fade-out
        transitionDuration: const Duration(milliseconds: 700),
        // Halaman tujuannya (LoginPage)
        pageBuilder: (context, animation, secondaryAnimation) {
          // LoginPage harus menginisialisasi databasenya sendiri
          return const LoginPage();
        },
        // Animasi transisinya (Fade)
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Selalu dispose controller Anda
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        // Gabungkan animasi masuk (fade & scale)
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- Logo Ikon Berdenyut ---
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    // Nilai denyut: 0.0 -> 1.0 -> 0.0
                    final double pulseValue = _pulseAnimation.value;
                    final double glowSize = 20.0 + (pulseValue * 20.0); // 20 -> 40
                    final double glowSpread = 5.0 + (pulseValue * 5.0); // 5 -> 10

                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryNeon.withOpacity(0.5),
                            blurRadius: glowSize,
                            spreadRadius: glowSpread,
                          )
                        ],
                      ),
                      child: child, // child-nya adalah Icon di bawah
                    );
                  },
                  child: Icon( // Ikon ini tidak perlu di-build ulang
                    Icons.track_changes_outlined,
                    color: primaryNeon,
                    size: 120, // Ukuran logo utama
                  ),
                ),
                const SizedBox(height: 24),
                // --- Teks Judul ---
                Text(
                  'NeonTech',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: primaryNeon.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}