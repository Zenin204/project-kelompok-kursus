import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Model data sederhana untuk kursus
class Course {
  final String title;
  final String category;
  final String imagePath; // Path ke assets/images/
  final double progress; // 0.0 sampai 1.0

  Course({
    required this.title,
    required this.category,
    required this.imagePath,
    required this.progress,
  });
}

// --- Data Kursus (Contoh) ---
// Ganti path gambar ini sesuai dengan file Anda di assets/images/
final List<Course> inProgressCourses = [
  Course(
    title: 'Pengenalan AI Kuantum',
    category: 'Artificial Intelligence',
    imagePath: 'assets/images/course_ai.jpg', // 👈 GANTI INI
    progress: 0.6,
  ),
  Course(
    title: 'Dasar-Dasar Ethical Hacking',
    category: 'Cyber Security',
    imagePath: 'assets/images/course_security.jpg', // 👈 GANTI INI
    progress: 0.2,
  ),
  // 💡 --- 5 ITEM BARU DITAMBAHKAN DI SINI ---
  Course(
    title: 'Data Science: Visualisasi Data',
    category: 'Data Science',
    imagePath: 'assets/images/course_data.jpg', // 👈 GANTI INI
    progress: 0.4,
  ),
  Course(
    title: 'Cloud Computing (AWS Basics)',
    category: 'Cloud',
    imagePath: 'assets/images/course_cloud.jpg', // 👈 GANTI INI
    progress: 0.8,
  ),
  Course(
    title: 'Machine Learning Fundamentals',
    category: 'Artificial Intelligence',
    imagePath: 'assets/images/course_mai.jpg', // 👈 GANTI INI
    progress: 0.1,
  ),
  Course(
    title: 'Jaringan Komputer & Topologi',
    category: 'Networking',
    imagePath: 'assets/images/course_network1.jpg', // 👈 GANTI INI
    progress: 0.5,
  ),
  Course(
    title: 'UI/UX Design Modern',
    category: 'Desain',
    imagePath: 'assets/images/course_design.jpg', // 👈 GANTI INI
    progress: 0.7,
  ),
  // ------------------------------------
];

final List<Course> completedCourses = [
  Course(
    title: 'Membangun Apps di Web3',
    category: 'Blockchain',
    imagePath: 'assets/images/course_web3.jpg', // 👈 GANTI INI
    progress: 1.0,
  ),
];
// ------------------------------

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage>
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
    return DefaultTabController(
      length: 2, // Dua tab: "Sedang Diikuti" dan "Selesai"
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text(
            'Kursus Saya',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: bgColor,
          elevation: 0,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: primaryNeon, // Warna garis bawah tab
            indicatorWeight: 3.0,
            labelStyle: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 15),
            labelColor: primaryNeon,
            unselectedLabelColor: Colors.blueGrey[400],
            tabs: const [
              Tab(text: 'Sedang Diikuti'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- Tab 1: Kursus Sedang Diikuti ---
            _buildCourseList(
              courses: inProgressCourses,
              isCompleted: false,
            ),
            // --- Tab 2: Kursus Selesai ---
            _buildCourseList(
              courses: completedCourses,
              isCompleted: true,
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat daftar kursus
  Widget _buildCourseList({
    required List<Course> courses,
    required bool isCompleted,
  }) {
    // 💡 Animasi 'scroll' Anda (Staggered Animation) sudah ada di sini.
    // ListView.builder akan otomatis membuat item baru
    // dan animasi di bawah akan diterapkan pada setiap item baru.
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        
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
            child: _buildCourseCard(course: course, isCompleted: isCompleted),
          ),
        );
      },
    );
  }

  // Widget untuk satu kartu kursus
  Widget _buildCourseCard({
    required Course course,
    required bool isCompleted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      // --- Efek Glassmorphism ---
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blueGrey[800]!.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                // --- Gambar Kursus ---
                Container(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Image.asset(
                      course.imagePath,
                      fit: BoxFit.cover,
                      // Error handling jika gambar asset tidak ditemukan
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.blueGrey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // --- Detail Kursus (Teks dan Progress) ---
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Teks Judul dan Kategori
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.category,
                              style: GoogleFonts.poppins(
                                color: primaryNeon,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              course.title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        // Progress Bar atau Badge "Selesai"
                        isCompleted
                            ? _buildCompletedBadge() // Tampilkan "Selesai"
                            : _buildProgressBar(course.progress), // Tampilkan Progress
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper untuk Progress Bar
  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${(progress * 100).toInt()}% Selesai',
          style: GoogleFonts.poppins(
            color: Colors.blueGrey[300],
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.blueGrey[700],
          valueColor: AlwaysStoppedAnimation<Color>(primaryNeon),
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  // Helper untuk Badge "Selesai"
  Widget _buildCompletedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primaryNeon.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryNeon),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: primaryNeon, size: 14),
          const SizedBox(width: 4),
          Text(
            'Selesai',
            style: GoogleFonts.poppins(
              color: primaryNeon,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}