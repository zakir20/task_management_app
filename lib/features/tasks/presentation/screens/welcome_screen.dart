import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_logger.dart'; 
import '../../task_routes.dart';
import '../widgets/welcome_loading_shimmer.dart'; 

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWelcomeScreen();
  }

  void _initializeWelcomeScreen() async {
    logger.i("Checking onboarding status...");
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    final bool? isFirstTime = prefs.getBool('is_first_time');

    if (isFirstTime == false) {
      logger.d("User already seen onboarding. Redirecting to Dashboard.");
      if (mounted) {
        context.go(TaskRoutes.dashboard);
      }
      return; 
    }

    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted) {
      setState(() => _isLoading = false);
      logger.d("Welcome Screen ready. Showing UI.");
    }
  }

  void _onLetsStartClicked(BuildContext context) async {
    logger.i("Saving onboarding flag...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', false); 
    
    logger.v("Navigation triggered: Moving to Dashboard.");
    if (context.mounted) {
      context.go(TaskRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isLoading 
              ? const WelcomeLoadingShimmer() 
              : _buildWelcomeContent(context),
        ),
      ),
    );
  }

  Widget _buildWelcomeContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/welcome.svg',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  "Task Management &\nTo-Do List",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                const Gap(15),
                Text(
                  "This productive tool is designed to help you better manage your task project-wise conveniently!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textGrey,
                    height: 1.5,
                  ),
                ),
                const Gap(40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => _onLetsStartClicked(context), 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Let's Start",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        const Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}