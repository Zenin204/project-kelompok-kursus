// ignore_for_file: unused_field
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; 
import 'register_page.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final Map<String, Map<String, String>> _userDatabase = {};

  late final AnimationController _bgController;
  late final AnimationController _rgbController;
  late final AnimationController _iconController;
  late final Animation<double> _bgAnimation;

  double _masukButtonScale = 1.0;
  double _daftarButtonScale = 1.0;

  // Kontroler & State untuk Animasi Robot (Logika 10 detik tetap sama)
  late final AnimationController _robotLoopController;
  bool _robotsVisible = false;

  @override
  void initState() {
    super.initState();
    _bgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15))
          ..repeat(reverse: true);
    _bgAnimation =
        CurvedAnimation(parent: _bgController, curve: Curves.easeInOut);
    _rgbController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat();
    _iconController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();

    // Kontroler Robot (Durasi 13 detik = 1.5s keluar + 10s diam + 1.5s masuk)
    _robotLoopController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 13),
    )..repeat();

    _robotLoopController.addListener(() {
      final value = _robotLoopController.value;
      // Tampil di 11.5% (1.5s), Sembunyi di 88.4% (11.5s)
      bool shouldBeVisible = (value > 0.115 && value < 0.884);
      if (shouldBeVisible != _robotsVisible && mounted) {
        setState(() {
          _robotsVisible = shouldBeVisible;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bgController.dispose();
    _rgbController.dispose();
    _iconController.dispose();
    _robotLoopController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      if (_userDatabase.containsKey(email)) {
        final userData = _userDatabase[email]!;
        if (userData['password'] == password) {
          final String name = userData['name']!;
          final String userEmail = email;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(
                name: name,
                email: userEmail,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password salah. Silakan coba lagi.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email tidak terdaftar. Silakan daftar dahulu.'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      }
    }
  }

  // 💡 --- PERUBAHAN: Ganti Ikon jadi Animasi Lottie ---
  Widget _buildRobotAnimation(String assetPath, {bool mirror = false}) {
    Widget robot = Lottie.asset(
      assetPath,
      width: 100, // Atur ukuran robot
      height: 100,
      fit: BoxFit.contain,
    );

    // Jika 'mirror' true, kita balik animasinya (untuk robot sisi kanan)
    if (mirror) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi), // Balik secara horizontal
        child: robot,
      );
    }
    return robot;
  }
  // ----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    const Color neonBlue = Colors.cyanAccent;
    const Color neonPink = Colors.pinkAccent;
    const Color deepBlue = Color(0xFF0A0E21);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgAnimation,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + _bgAnimation.value, -1),
                end: Alignment(1 - _bgAnimation.value, 1),
                colors: const [
                  Color(0xFF06021A),
                  Color(0xFF0A0046),
                  Color(0xFF1E005F),
                  Color(0xFF0074D9),
                ],
              ),
            ),
            child: Stack(
              children: [
                CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _StarPainter(),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.black.withOpacity(0.25)),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: Stack( // Stack untuk menampung Kartu + Robot
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // --- KARTU LOGIN ---
                          AnimatedRgbBorder(
                            controller: _rgbController,
                            borderRadius: 20.0,
                            borderThickness: 5.0,
                            child: Container(
                              padding: const EdgeInsets.all(24.0),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0D1127),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  RotationTransition(
                                    turns: _iconController,
                                    child: Icon(
                                      Icons.track_changes_outlined,
                                      size: 100,
                                      color: neonBlue,
                                      shadows: [
                                        Shadow(
                                          color: neonBlue.withOpacity(0.7),
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'NeonTech',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.orbitron(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: neonBlue.withOpacity(0.5),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        _buildInputField(
                                          controller: _emailController,
                                          label: 'Email',
                                          icon: Icons.email_outlined,
                                          neonColor: neonBlue,
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return 'Email tidak boleh kosong';
                                            }
                                            if (!RegExp(r'\S+@\S+\.\S+')
                                                .hasMatch(v)) {
                                              return 'Mohon masukkan email yang valid';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        _buildInputField(
                                          controller: _passwordController,
                                          label: 'Password',
                                          icon: Icons.lock_outline,
                                          neonColor: neonBlue,
                                          obscure: !_isPasswordVisible,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: neonBlue,
                                            ),
                                            onPressed: () {
                                              setState(() =>
                                                  _isPasswordVisible =
                                                      !_isPasswordVisible);
                                            },
                                          ),
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return 'Password tidak boleh kosong';
                                            }
                                            if (v.length < 6) {
                                              return 'Password minimal 6 karakter';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  AnimatedScale(
                                    scale: _masukButtonScale,
                                    duration:
                                        const Duration(milliseconds: 150),
                                    child: GestureDetector(
                                      onTapDown: (_) => setState(
                                          () => _masukButtonScale = 0.95),
                                      onTapUp: (_) {
                                        setState(
                                            () => _masukButtonScale = 1.0);
                                        _login();
                                      },
                                      onTapCancel: () => setState(
                                          () => _masukButtonScale = 1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          gradient: const LinearGradient(
                                            colors: [
                                              neonBlue,
                                              Colors.blueAccent
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  neonBlue.withOpacity(0.5),
                                              blurRadius: 15,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Center(
                                            child: Text(
                                              'Masuk',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: deepBlue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Belum punya akun?',
                                        style: GoogleFonts.poppins(
                                            color: Colors.blueGrey[200]),
                                      ),
                                      GestureDetector(
                                        onTapDown: (_) => setState(() =>
                                            _daftarButtonScale = 0.95),
                                        onTapUp: (_) {
                                          setState(() =>
                                              _daftarButtonScale = 1.0);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => RegisterPage(
                                                userDatabase: _userDatabase,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Daftar Sekarang',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: neonPink,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 💡 --- PERUBAHAN: ROBOT KIRI (Lottie) ---
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 1300),
                            curve: Curves.easeInOutCubic,
                            // Posisi -70 (sembunyi) -> -35 (mengintip)
                            left: _robotsVisible ? -35 : -100,
                            top: 100,
                            child: _buildRobotAnimation(
                              'assets/animations/robot_peek.json', // 👈 GANTI NAMA FILE
                            ),
                          ),

                          // 💡 --- PERUBAHAN: ROBOT KANAN (Lottie) ---
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 1300),
                            curve: Curves.easeInOutCubic,
                            // Posisi -70 (sembunyi) -> -35 (mengintip)
                            right: _robotsVisible ? -35 : -100,
                            top: 180,
                            child: _buildRobotAnimation(
                              'assets/animations/robot_peek.json', // 👈 GANTI NAMA FILE
                              mirror: true, // Robot ini dibalik
                            ),
                          ),
                          // -------------------------------------
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color neonColor,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.blueGrey[200]),
        prefixIcon: Icon(icon, color: neonColor, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.pinkAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}

class _StarPainter extends CustomPainter {
  final math.Random _rand = math.Random();
  @override
  void paint(Canvas canvas, Size size) {
    final Paint starPaint =
        Paint()..color = Colors.cyanAccent.withOpacity(0.6);
    for (int i = 0; i < 80; i++) {
      final dx = _rand.nextDouble() * size.width;
      final dy = _rand.nextDouble() * size.height;
      final radius = _rand.nextDouble() * 1.5;
      canvas.drawCircle(Offset(dx, dy), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnimatedRgbBorder extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double borderThickness;
  final AnimationController controller;

  const AnimatedRgbBorder({
    super.key,
    required this.child,
    required this.controller,
    this.borderRadius = 16.0,
    this.borderThickness = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final gradient = SweepGradient(
          startAngle: 0,
          endAngle: 2 * math.pi,
          colors: const [
            Colors.cyanAccent,
            Colors.blueAccent,
            Colors.purpleAccent,
            Colors.cyanAccent,
          ],
          transform: GradientRotation(controller.value * 2 * math.pi),
        );
        return Container(
          padding: EdgeInsets.all(borderThickness),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(borderRadius - 2),
            ),
            child: child,
          ),
        );
      },
    );
  }
}