import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile_page.dart';
import 'notification_page.dart'; // 💡 --- TAMBAHAN IMPORT ---
import 'about_page.dart';      // 💡 --- TAMBAHAN IMPORT ---

// 1. Diubah menjadi StatefulWidget
class ProfilePage extends StatefulWidget {
  // 💡 --- PERUBAHAN 1: Terima data ---
  final String name;
  final String email;
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.onLogout,
    required this.name, // Tambahkan ini
    required this.email, // Tambahkan ini
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// 2. Dibuat _ProfilePageState
class _ProfilePageState extends State<ProfilePage> {
  // Warna utama (dipindahkan ke sini)
  static const Color bgColor = Color(0xFF0A0E21);
  static const Color cardColor = Color(0xFF1D1E33);
  static const Color primaryNeon = Colors.cyanAccent;
  static const Color secondaryNeon = Colors.pinkAccent;

  String _profileImagePath = 'assets/images/profil_anime.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Profil Saya',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 30),
              _buildStatsGrid(),
              const SizedBox(height: 30),
              _buildSettingsMenu(context), // 💡 FUNGSI INI DIGANTI
              const SizedBox(height: 40),
              _buildLogoutButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryNeon.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: CircleAvatar(
            radius: 55,
            backgroundColor: primaryNeon,
            child: CircleAvatar(
              radius: 52,
              backgroundImage: AssetImage(_profileImagePath),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.name,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.email,
          style: GoogleFonts.poppins(
            color: Colors.blueGrey[300],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(Icons.school, '7', 'Kursus Diikuti'),
        _buildStatCard(Icons.card_membership, '2', 'Sertifikat'),
        _buildStatCard(Icons.hourglass_bottom, '48', 'Jam Belajar'),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey[800]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: primaryNeon, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.blueGrey[300],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // 💡 --- KODE SNIPPET ANDA DIMASUKKAN DI SINI ---
  Widget _buildSettingsMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildMenuTile(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profil',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(
                    name: widget.name, // 👈 Kirim nama
                    email: widget.email, // 👈 Kirim email
                  ),
                ),
              );
            },
          ),
          _buildMenuTile(
            context,
            icon: Icons.notifications_none,
            title: 'Pengaturan Notifikasi',
            onTap: () {
              Navigator.push(
                // 💡 BUKA HALAMAN NOTIFIKASI
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            },
          ),
          _buildMenuTile(
            context,
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            onTap: () {
              // 💡 --- TAMBAHKAN NAVIGASI INI ---
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
              // ---------------------------------
            },
            hideDivider: true,
          ),
        ],
      ),
    );
  }
  // ---------------------------------------------

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool hideDivider = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: primaryNeon),
          title: Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.blueGrey[600]),
          onTap: onTap,
        ),
        if (!hideDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.blueGrey[800], height: 1),
          ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: widget.onLogout,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [secondaryNeon.withOpacity(0.8), Colors.redAccent],
          ),
          boxShadow: [
            BoxShadow(
              color: secondaryNeon.withOpacity(0.5),
              blurRadius: 15,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Center(
          child: Text(
            'Keluar (Logout)',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}