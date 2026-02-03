import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/utils/assets_utils.dart'; 
import '../../../../injection/injection_container.dart';
import '../../data/repository/onboard_repository.dart';
import '../../task_routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  void _checkOnboardingStatus() async {
    final onboardRepo = sl<OnboardRepository>();
    final isFirstTime = await onboardRepo.isFirstTime();

    if (!isFirstTime) {
      if (mounted) AppRouter.go(context, TaskRoutes.dashboard);
    }
  }

  void _onLetsStartClicked(BuildContext context) async {
    await sl<OnboardRepository>().setOnboardingComplete();
    if (context.mounted) AppRouter.go(context, TaskRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: SvgPicture.asset(
                    AssetsUtils.welcomeImage, 
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const Text(
                      "Task Management &\nTo-Do List",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold, 
                        color: AppColors.textBlack
                      ),
                    ),
                    const Gap(15),
                    const Text(
                      "This productive tool is designed to help you better manage your task project-wise conveniently!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14, 
                        color: AppColors.textGrey, 
                        height: 1.5
                      ),
                    ),
                    const Gap(40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () => _onLetsStartClicked(context), 
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Let's Start"),
                            Gap(10),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}