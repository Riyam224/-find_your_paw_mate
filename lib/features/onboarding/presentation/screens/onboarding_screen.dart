// import 'package:animals_tasks/core/styling/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class OnboardingScreen extends StatelessWidget {
//   const OnboardingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 const Spacer(),
//                 // 🐶🐱 Image
//                 Image.asset(
//                   'assets/images/onboarding_image.png',
//                   height: 280,
//                   fit: BoxFit.contain,
//                 ),
//                 const SizedBox(height: 40),

//                 // 📝 Title
//                 const Text(
//                   'Find Your Best\nCompanion With Us',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                     height: 1.3,
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // 💬 Subtitle
//                 const Text(
//                   'Join & discover the best suitable pets as per your preferences in your location',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                     height: 1.5,
//                   ),
//                 ),

//                 const Spacer(),
//                 // 🐾 Custom Get Started Button
//                 GestureDetector(
//                   onTap: () {
//                     try {
//                       GoRouter.of(context).go('/home');
//                     } catch (e) {
//                       debugPrint('⚠️ Navigation failed: $e');
//                     }
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     height: 56,
//                     decoration: BoxDecoration(
//                       color: AppColors.primary,
//                       borderRadius: BorderRadius.circular(28),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.15),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.pets, color: Colors.white),
//                         const SizedBox(width: 8),
//                         const Text(
//                           'Get Started',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:animals_tasks/core/styling/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // ✅ Safe navigation method
  void _goToHome() {
    if (!mounted) return; // prevent crash if widget disposed
    try {
      GoRouter.of(context).go('/home');
    } catch (e) {
      debugPrint('⚠️ Navigation failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Spacer(),

                // 🐶🐱 Image
                Image.asset(
                  'assets/images/onboarding_image.png',
                  height: 280,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),

                // 📝 Title
                const Text(
                  'Find Your Best\nCompanion With Us',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),

                // 💬 Subtitle
                const Text(
                  'Join & discover the best suitable pets as per your preferences in your location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),

                const Spacer(),

                // 🐾 Custom Get Started Button
                GestureDetector(
                  onTap: _goToHome, // ✅ safer navigation
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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
}