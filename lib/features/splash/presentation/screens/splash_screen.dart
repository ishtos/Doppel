import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scale;
  late final Animation<double> _subtitleFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _subtitleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        context.go('/home');
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF0D1442)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _fadeIn,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.1),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.record_voice_over,
                          size: 56,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _fadeIn,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Text(
                        'Doppel',
                        style: GoogleFonts.notoSansJp(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeTransition(
                    opacity: _subtitleFade,
                    child: Text(
                      'AI Shadowing Coach',
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
