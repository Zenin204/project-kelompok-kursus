import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Model data sederhana untuk Notifikasi
class NotificationItem {
  final String title;
  final String body;
  final IconData icon;
  final String timeAgo;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.body,
    required this.icon,
    required this.timeAgo,
    this.isRead = false,
  });
}

// --- Data Notifikasi (Contoh) ---
final List<NotificationItem> dummyNotifications = [
  NotificationItem(
    title: 'Sertifikat Baru Diperoleh!',
    body: 'Anda telah menyelesaikan kursus "Membangun DApps di Web3".',
    icon: Icons.card_membership_rounded,
    timeAgo: '5m lalu',
    isRead: false, // Akan ada titik neon
  ),
  NotificationItem(
    title: 'Kursus Baru Ditambahkan',
    body: 'Jelajahi materi baru kami: "Advanced Cyber Security".',
    icon: Icons.school_rounded,
    timeAgo: '2j lalu',
    isRead: false, // Akan ada titik neon
  ),
  NotificationItem(
    title: 'Update Sistem',
    body: 'Perbaikan bug dan peningkatan performa telah diterapkan.',
    icon: Icons.system_update_rounded,
    timeAgo: '1h lalu',
    isRead: true, // Tidak ada titik neon
  ),
  NotificationItem(
    title: 'Profil Diperbarui',
    body: 'Password Anda berhasil diubah.',
    icon: Icons.security_rounded,
    timeAgo: '1d lalu',
    isRead: true,
  ),
  NotificationItem(
    title: 'Diskon Spesial!',
    body: 'Dapatkan diskon 50% untuk kursus "AI Kuantum" hari ini.',
    icon: Icons.local_offer_rounded,
    timeAgo: '2d lalu',
    isRead: true,
  ),
];
// ------------------------------

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  // Warna utama
  static const Color bgColor = Color(0xFF0A0E21);
  static const Color cardColor = Color(0xFF1D1E33);
  static const Color primaryNeon = Colors.cyanAccent;

  // Controller untuk animasi daftar 'Staggered'
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Durasi total animasi
    );
    _animationController.forward(); // Mulai animasi saat halaman dibuka
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Tombol "Tandai Semua Dibaca"
          IconButton(
            onPressed: () {
              // TODO: Tambahkan logika untuk menandai semua sudah dibaca
            },
            icon: Icon(Icons.drafts_rounded, color: Colors.blueGrey[300]),
            tooltip: 'Tandai semua dibaca',
          ),
        ],
      ),
      body: dummyNotifications.isEmpty
          ? _buildEmptyState() // Tampilkan ini jika tidak ada notifikasi
          : _buildNotificationList(), // Tampilkan daftar jika ada
    );
  }

  // Widget jika tidak ada notifikasi
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            color: primaryNeon.withOpacity(0.7),
            size: 100,
          ),
          const SizedBox(height: 20),
          Text(
            'Tidak Ada Notifikasi',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Semua pemberitahuan Anda akan muncul di sini.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.blueGrey[300],
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membuat daftar notifikasi
  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: dummyNotifications.length,
      itemBuilder: (context, index) {
        final notification = dummyNotifications[index];

        // --- Logika Animasi Staggered ---
        final intervalStart = (index * 150) / 1000.0;
        final intervalEnd = (intervalStart + 0.5).clamp(0.0, 1.0);

        final animation = Tween<Offset>(
          begin: const Offset(1.0, 0.0), // Mulai dari luar (kanan)
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
        // --- Akhir Logika Animasi ---

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: animation,
            child: _buildNotificationCard(notification: notification),
          ),
        );
      },
    );
  }

  // Widget untuk satu kartu notifikasi
  Widget _buildNotificationCard({required NotificationItem notification}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      // --- Efek Glassmorphism ---
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blueGrey[800]!.withOpacity(0.5)),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              // --- Ikon Neon ---
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: primaryNeon.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryNeon.withOpacity(0.5)),
                ),
                child: Icon(
                  notification.icon,
                  color: primaryNeon,
                  size: 24,
                ),
              ),
              // --- Teks Judul & Isi ---
              title: Text(
                notification.title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                '${notification.body}\n${notification.timeAgo}',
                style: GoogleFonts.poppins(
                  color: Colors.blueGrey[200],
                  fontSize: 12,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              // --- Titik "Belum Dibaca" ---
              trailing: notification.isRead
                  ? null // Jika sudah dibaca, tidak ada apa-apa
                  : Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: primaryNeon,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryNeon,
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                    ),
              onTap: () {
                // TODO: Tambahkan logika saat notifikasi diklik
              },
            ),
          ),
        ),
      ),
    );
  }
}