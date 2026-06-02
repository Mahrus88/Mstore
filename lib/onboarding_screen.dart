// lib/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "icon": Icons.bakery_dining_rounded,
      "title": "Selamat Datang di\nMStore Bakery 🍞",
      "desc":
          "Temukan berbagai produk bakery lezat buatan tangan, dari kue tart, donat, hingga croissant segar setiap hari.",
      "color": const Color(0xFF8D6E63),
    },
    {
      "icon": Icons.shopping_cart_rounded,
      "title": "Belanja Mudah &\nCepat 🛒",
      "desc":
          "Pilih produk favoritmu, masukkan ke keranjang, dan checkout dalam hitungan detik. Semudah itu!",
      "color": const Color(0xFF5D4037),
    },
    {
      "icon": Icons.delivery_dining_rounded,
      "title": "Diantar Langsung\nke Pintu Rumah 🚀",
      "desc":
          "Pesanan Anda akan segera dikirim hangat langsung dari oven kami ke depan pintu rumah Anda.",
      "color": const Color(0xFF3E2723),
    },
  ];

  Future<void> _selesaiOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sudah_onboarding', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SafeArea(
        child: Column(
          children: [
            // Tombol skip di kanan atas
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _selesaiOnboarding,
                  child: const Text("Lewati",
                      style: TextStyle(
                          color: Color(0xFF8D6E63),
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Ikon
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: (page['color'] as Color)
                                .withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page['icon'] as IconData,
                            size: 80,
                            color: page['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Judul
                        Text(
                          page['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Deskripsi
                        Text(
                          page['desc'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indikator halaman
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFF8D6E63)
                        : const Color(0xFFBCAAA4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol next / mulai
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _selesaiOnboarding();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E2723),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1
                        ? "Lanjut →"
                        : "Mulai Belanja! 🍞",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}