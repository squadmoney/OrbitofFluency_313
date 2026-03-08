import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../navigation/widgets/main_scaffold.dart';
import '../widgets/onboarding_slide.dart';
import '../widgets/page_indicator.dart';

const String _kOnboardingCompletedKey = 'onboarding_completed';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isNavigating = false;

  static const List<_SlideData> _slides = [
    _SlideData(
      circleColor: AppColors.orange,
      centerSvg: 'assets/onb0_med.svg',
      topLeftSvg: 'assets/onb0_high.svg',
      bottomRightSvg: 'assets/onb0_low.svg',
      title: 'Learn Through Images',
      body:
          'Use visual memory to make information stick faster and more naturally.',
    ),
    _SlideData(
      circleColor: AppColors.teal,
      centerSvg: 'assets/onb1_med.svg',
      topLeftSvg: 'assets/onb1_high.svg',
      bottomRightSvg: 'assets/onb1_low.svg',
      title: 'Study What Matters to You',
      body:
          'Choose the topics that are important for your goals and interests.',
    ),
    _SlideData(
      circleColor: AppColors.coral,
      centerSvg: 'assets/onb2_med.svg',
      topLeftSvg: 'assets/onb2_high.svg',
      bottomRightSvg: 'assets/onb2_low.svg',
      title: 'Short Sessions. Lasting Progress.',
      body: 'A few focused minutes each day lead to steady improvement.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    if (_isNavigating) return;

    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() => _isNavigating = true);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kOnboardingCompletedKey, true);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute<void>(
          builder: (context) => const MainScaffold(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundBlue,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Slides take up all available space above bottom area
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return OnboardingSlide(
                    circleColor: slide.circleColor,
                    centerSvg: slide.centerSvg,
                    topLeftSvg: slide.topLeftSvg,
                    bottomRightSvg: slide.bottomRightSvg,
                    title: slide.title,
                    body: slide.body,
                  );
                },
              ),
            ),

            // Bottom: page indicator + button
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                24,
                AppSpacing.screenPadding,
                bottomInset + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PageIndicator(
                    currentPage: _currentPage,
                    pageCount: _slides.length,
                  ),
                  const SizedBox(height: 24),
                  AppPrimaryButton(
                    label: 'Next',
                    onPressed: _isNavigating ? null : _handleNext,
                    isLoading: _isNavigating,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Private data class for slide configuration
class _SlideData {
  final Color circleColor;
  final String centerSvg;
  final String topLeftSvg;
  final String bottomRightSvg;
  final String title;
  final String body;

  const _SlideData({
    required this.circleColor,
    required this.centerSvg,
    required this.topLeftSvg,
    required this.bottomRightSvg,
    required this.title,
    required this.body,
  });
}
