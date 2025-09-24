import 'package:flutter/material.dart';
import 'package:foodieland/utils/app_strings/app_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../home/ui/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static final String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate(); // Check authentication and navigate

    // Create an animation controller for the typewriter effect
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start animation
    _controller.forward();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(Duration(seconds: 3)); // Wait for splash screen
    final user = Supabase.instance.client.auth.currentUser;
    print(user);
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                // Calculate the current index for the typewriter effect
                int textLength = AppStrings.appTitle.length;
                int currentIndex = (_animation.value * textLength).toInt();
                String visibleText = AppStrings.appTitle.substring(
                  0,
                  currentIndex,
                );

                return RichText(
                  text: TextSpan(
                    style: GoogleFonts.lobster(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black, // Default color for text
                    ),
                    children: [
                      TextSpan(text: visibleText),
                      if (currentIndex == textLength)
                        TextSpan(
                          text:
                              ".", // Display the red dot after animation completes
                          style: TextStyle(color: Colors.red, fontSize: 40),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}
