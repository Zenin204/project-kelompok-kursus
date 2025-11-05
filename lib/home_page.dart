import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification_page.dart'; // Import halaman notifikasi

class HomePage extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onProfileTap;

  const HomePage({
    super.key,
    required this.onProfileTap,
    required this.name,
    required this.email,
  });

  static const Color bgColor = Color(0xFF0A0E21);
  static const Color cardColor = Color(0xFF1D1E33);
  static const Color primaryNeon = Colors.cyanAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang,',
              style: GoogleFonts.poppins(
                color: Colors.blueGrey[300],
                fontSize: 14,
              ),
            ),
            Text(
              name,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            },
            icon: Icon(Icons.notifications_none_rounded, color: Colors.white),
          ),
          GestureDetector(
            onTap: onProfileTap,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: primaryNeon,
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/images/profil_anime.png'),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSectionHeader('Materi Unggulan', () {}),
            ),
            _buildFeaturedCarousel(), // 👈 FUNGSI INI DIUBAH
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSectionHeader('Kategori Populer', () {}),
            ),
            _buildCategories(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSectionHeader('Lanjutkan Belajar', () {}),
            ),
            _buildContinueLearningList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper untuk Judul Bagian
  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            'Lihat Semua',
            style: GoogleFonts.poppins(color: primaryNeon, fontSize: 12),
          ),
        ),
      ],
    );
  }

  // Helper untuk Search Bar
  Widget _buildSearchBar() {
    return TextField(
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Cari kursus favoritmu...',
        hintStyle: GoogleFonts.poppins(color: Colors.blueGrey[400]),
        prefixIcon: Icon(Icons.search, color: primaryNeon, size: 20),
        filled: true,
        fillColor: cardColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primaryNeon, width: 2),
        ),
      ),
    );
  }

  // --- 💡 PERUBAHAN DI SINI ---

  // Helper untuk Carousel
  Widget _buildFeaturedCarousel() {
    return Container(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16.0),
        children: [
          // Mengganti _buildFeaturedCard() dengan class _FeaturedCard()
          _FeaturedCard(
            title: 'Artificial Intelligence',
            subtitle: 'Masa Depan Teknologi Dimulai di Sini',
            imagePath: 'assets/images/course_ai.jpg',
          ),
          _FeaturedCard(
            title: 'Cyber Security',
            subtitle: 'Lindungi Aset Digital Anda',
            imagePath: 'assets/images/course_security.jpg',
          ),
          _FeaturedCard(
            title: 'Web3 & Blockchain',
            subtitle: 'Membangun Aplikasi Terdesentralisasi',
            imagePath: 'assets/images/course_web3.jpg',
          ),
        ],
      ),
    );
  }
} // <-- Class HomePage berakhir di sini

// 💡 --- WIDGET BARU DITAMBAHKAN ---
// Kita buatkan widget terpisah agar bisa mengelola 'state' hover-nya sendiri
class _FeaturedCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const _FeaturedCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  State<_FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<_FeaturedCard> {
  // Variabel untuk menyimpan status hover
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Tentukan skala berdasarkan status hover
    final double scale = _isHovered ? 1.05 : 1.0; // 1.05 = membesar 5%

    return MouseRegion(
      // 1. Deteksi kursor masuk
      onEnter: (_) => setState(() => _isHovered = true),
      // 2. Deteksi kursor keluar
      onExit: (_) => setState(() => _isHovered = false),
      
      child: AnimatedScale(
        // 3. Animasikan perubahan skala
        scale: scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        
        // Ini adalah kode kartu Anda yang sebelumnya
        child: Container(
          width: 300,
          margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10), // Beri margin agar animasi tidak terpotong
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(widget.imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
              onError: (exception, stackTrace) {},
            ),
            boxShadow: [
              BoxShadow(
                // 4. Buat bayangan lebih kuat saat di-hover
                color: _isHovered 
                  ? HomePage.primaryNeon.withOpacity(0.7) 
                  : HomePage.primaryNeon.withOpacity(0.4),
                blurRadius: _isHovered ? 20 : 15,
                spreadRadius: _isHovered ? 2 : 0, // Efek 'glow'
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
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
// --- 💡 BATAS WIDGET BARU ---


// --- SISA KODE HELPER (TIDAK BERUBAH) ---

Widget _buildCategories() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Row(
      children: [
        Expanded(child: _buildCategoryChip(Icons.memory, 'AI')),
        Expanded(child: _buildCategoryChip(Icons.security, 'Security')),
        Expanded(child: _buildCategoryChip(Icons.cloud_queue, 'Cloud')),
        Expanded(child: _buildCategoryChip(Icons.code, 'Web3')),
        Expanded(child: _buildCategoryChip(Icons.data_usage, 'Data')),
      ],
    ),
  );
}

Widget _buildCategoryChip(IconData icon, String label) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: HomePage.cardColor,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.blueGrey[800]!),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: HomePage.primaryNeon, size: 30),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
        ),
      ],
    ),
  );
}

Widget _buildContinueLearningList() {
  return Container(
    height: 150,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16.0),
      children: [
        _buildCourseCard(
          'Pengenalan AI Kuantum',
          'Bab 3: Algoritma Shor',
          0.6,
        ),
        _buildCourseCard(
          'Dasar-Dasar Ethical Hacking',
          'Bab 1: Instalasi Tools',
          0.2,
        ),
      ],
    ),
  );
}

Widget _buildCourseCard(String title, String chapter, double progress) {
  return Container(
    width: 220,
    margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: HomePage.cardColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueGrey[800]!.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter,
                    style: GoogleFonts.poppins(
                      color: Colors.blueGrey[300],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.blueGrey[700],
                    valueColor: AlwaysStoppedAnimation<Color>(HomePage.primaryNeon),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}