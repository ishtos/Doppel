import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _contentController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _contentController.forward();

    await Future.delayed(const Duration(milliseconds: 1300));
    if (!mounted) return;
    context.go('/home');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // FIXED: ダークモード対応のカラー設定
    final bgColor = isDark
        ? theme.colorScheme.surface
        : const Color(0xFF1A237E);
    final textColor = isDark
        ? theme.colorScheme.onSurface
        : Colors.white;
    final accentColor = isDark
        ? theme.colorScheme.primary
        : const Color(0xFFFF8F00);

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.15),
                ),
                child: Icon(
                  Icons.record_voice_over,
                  size: 48,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(height: 24),

            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacity.value,
                  child: child,
                );
              },
              child: Text(
                'Doppel',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 12),

            AnimatedBuilder(
              animation: _contentController,
              builder: (context, child) {
                return SlideTransition(
                  position: _taglineSlide,
                  child: Opacity(
                    opacity: _taglineOpacity.value,
                    child: child,
                  ),
                );
              },
              child: Text(
                'AI Shadowing Coach',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: textColor.withValues(alpha: 0.7),
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
