import 'package:flutter/material.dart';
import 'package:kons/get_started.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final pages = [
    {
      'image': 'assets/illustration.png',
      'title': 'MONITORING ANAK PKL\nLEBIH PRAKTIS',
      'description': 'Dengan aplikasi ini, monitoring jadi mudah dan praktis.\nSemua dalam satu aplikasi, tanpa repot',
      'progress': 1,
    },
    {
      'image': 'assets/oritentasi2.png',
      'title': 'MANAGEMEN KEGIATAN PKL\nJADI LEBIH MUDAH',
      'description': 'Dengan aplikasi ini, managemen jadi mudah dan praktis.',
      'progress': 2,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        _createRoute(const GetStartedScreen()),
      );
    }
  }

  PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;
    final screenWidth = media.size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalHeight = constraints.maxHeight;
            final bottomHeight = totalHeight * 0.5;
            final imageHeight = totalHeight * 0.42;

            return Stack(
              children: [
                // PageView untuk smooth transition
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Stack(
                      children: [
                        // Latar gradient memenuhi layar
                        Container(
                          width: screenWidth,
                          height: totalHeight,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF6A5AE0), Color(0xFF8C9EFF)],
                            ),
                          ),
                        ),

                        // Ilustrasi dipusatkan
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: totalHeight * 0.12,
                              bottom: bottomHeight * 0.25,
                            ),
                            child: Image.asset(
                              page['image'] as String,
                              height: imageHeight,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Bottom sheet 50% tinggi layar (fixed, tidak ikut swipe)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: bottomHeight,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Animated content based on current page
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.1),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            key: ValueKey<int>(_currentPage),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pages[_currentPage]['title'] as String,
                                style: const TextStyle(
                                  fontFamily: 'Courier New',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                pages[_currentPage]['description'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Progress indicator with gradient
                        Row(
                          children: List.generate(3, (index) {
                            final progress = pages[_currentPage]['progress'] as int;
                            final isActive = index < progress;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                              height: 6,
                              width: 40,
                              decoration: BoxDecoration(
                                gradient: isActive
                                    ? const LinearGradient(
                                        colors: [Color(0xFF6A5AE0), Color(0xFF8C9EFF)],
                                      )
                                    : null,
                                color: isActive ? null : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }),
                        ),
                        const Spacer(),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6A5AE0), Color(0xFF8C9EFF)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _nextPage,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
