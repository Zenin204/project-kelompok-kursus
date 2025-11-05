import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'my_courses_page.dart';
import 'login_page.dart';

class MainPage extends StatefulWidget {
  // 💡 --- PERUBAHAN 1: Terima data ---
  final String name;
  final String email;

  const MainPage({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 💡 --- PERUBAHAN 2: Kirim data ke Halaman ---
    _pages = [
      // Kirim nama, email, dan callback
      HomePage(
        name: widget.name,
        email: widget.email,
        onProfileTap: () => _jumpToPage(2),
      ),
      const MyCoursesPage(),
      // Kirim nama, email, dan callback
      ProfilePage(
        name: widget.name,
        email: widget.email,
        onLogout: _logout,
      ),
    ];
  }

  void _jumpToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryNeon = Colors.cyanAccent;
    const Color navBarColor = Color(0xFF0D1127);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBarColor,
          boxShadow: [
            BoxShadow(
              color: primaryNeon.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_rounded),
              label: 'Kursus Saya',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _jumpToPage,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryNeon,
          unselectedItemColor: Colors.blueGrey[600],
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.poppins(),
        ),
      ),
    );
  }
}