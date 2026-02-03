import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/app_logger.dart';

class OnboardRepository {
  static const String _onboardKey = 'is_first_time';

  Future<bool> isFirstTime() async {
    logger.i("OnboardRepo: Checking onboarding status...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isFirst = prefs.getBool(_onboardKey) ?? true;
    return isFirst;
  }

  Future<void> setOnboardingComplete() async {
    logger.i("OnboardRepo: Marking onboarding as complete...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardKey, false);
  }
}