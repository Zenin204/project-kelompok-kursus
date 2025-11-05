import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  // Warna utama
  static const Color bgColor = Color(0xFF0A0E21);
  static const Color cardColor = Color(0xFF1D1E33);
  static const Color primaryNeon = Colors.cyanAccent;

  // Controller untuk animasi staggered
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Durasi total animasi
    );
    _animationController.forward(); // Mulai animasi
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // --- Helper Widget untuk Animasi Staggered ---
  // Ini akan menganimasikan setiap item satu per satu
  Widget _buildAnimatedItem(int index, Widget child) {
    // Setiap item akan delay 150ms dari sebelumnya
    final intervalStart = (index * 150) / 1200.0;
    // Durasi animasi setiap item adalah 600ms
    final intervalEnd = (intervalStart + 0.5).clamp(0.0, 1.0);

    final animation = Tween<Offset>(
      begin: const Offset(0.0, 0.5), // Mulai dari bawah
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          intervalStart,
          intervalEnd,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          intervalStart,
          intervalEnd,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: animation,
        child: child,
      ),
    );
  }
  // ---------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Tentang NeonTech',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryNeon),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- Item 1: Logo dan Versi ---
            _buildAnimatedItem(
              0,
              _buildHeader(),
            ),
            const SizedBox(height: 30),

            // --- Item 2: Kartu Sejarah ---
            _buildAnimatedItem(
              1,
              _buildGlassCard(
                title: 'Sejarah NeonTech',
                icon: Icons.history_edu_rounded,
                child: Text(
                  'NeonTech dimulai pada tahun 2024 sebagai visi untuk mendemokratisasi akses ke pembelajaran teknologi canggih. Dari sebuah prototipe sederhana, kami berevolusi menjadi platform yang ditenagai oleh AI untuk memberikan wawasan dan kursus yang terkurasi.\n\nMisi kami adalah menerangi masa depan melalui pengetahuan yang dapat diakses oleh semua orang.',
                  style: GoogleFonts.poppins(
                    color: Colors.blueGrey[200],
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Item 3: Kartu Tautan ---
            _buildAnimatedItem(
              2,
              _buildGlassCard(
                title: 'Info & Tautan',
                icon: Icons.link_rounded,
                child: Column(
                  children: [
                    _buildMenuTile(
                      icon: Icons.security_rounded,
                      title: 'Kebijakan Privasi',
                      onTap: () {
                        // TODO: Tambahkan logika buka link
                      },
                    ),
                    _buildMenuTile(
                      icon: Icons.description_rounded,
                      title: 'Ketentuan Layanan',
                      onTap: () {
                        // TODO: Tambahkan logika buka link
                      },
                    ),
                    _buildMenuTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Pusat Bantuan',
                      onTap: () {
                        // TODO: Tambahkan logika buka link
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --- Item 4: Footer ---
            _buildAnimatedItem(
              3,
              Text(
                '© 2025 NeonTech Industries',
                style: GoogleFonts.poppins(
                  color: Colors.blueGrey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk Header (Logo & Versi)
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cardColor,
            border: Border.all(color: primaryNeon, width: 2),
            boxShadow: [
              BoxShadow(
                color: primaryNeon.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 4,
              )
            ],
          ),
          child: Icon(
            Icons.track_changes_outlined,
            color: primaryNeon,
            size: 60,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'NeonTech',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Versi 1.0.0 (Genesis War)',
          style: GoogleFonts.poppins(
            color: Colors.blueGrey[300],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Helper untuk Kartu Glassmorphism
  Widget _buildGlassCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: cardColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueGrey[800]!.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: primaryNeon, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(
                color: primaryNeon,
                height: 24,
                thickness: 0.5,
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }

  // Helper untuk ListTile kustom di dalam kartu
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: primaryNeon.withOpacity(0.8)),
      title: Text(
        title,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.blueGrey[600]),
      onTap: onTap,
    );
  }
}