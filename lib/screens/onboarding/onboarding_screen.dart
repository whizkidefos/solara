import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Shop Everything You Love',
      description: 'Explore a wide range of top brands and unique finds all in one place.',
      imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&h=1200&fit=crop',
    ),
    OnboardingData(
      title: 'Fast, Safe & Simple Checkout',
      description: 'Shop confidently with secure payment and easy returns.',
      imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&h=1200&fit=crop',
      showIcons: true,
    ),
    OnboardingData(
      title: 'Stay in the Know',
      description: 'Get real-time updates on your orders and deliveries, anytime, anywhere.',
      imageUrl: 'https://images.unsplash.com/photo-1507680434567-5739c80be1ac?w=800&h=1200&fit=crop',
    ),
    OnboardingData(
      title: "Let's Get Started",
      description: 'Discover, shop, and enjoy everything you love is just a tap away.',
      imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800&h=1200&fit=crop',
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skip() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _next() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _skip();
    }
  }

  void _previous() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with time and Skip button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '9:41',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_currentPage > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _previous,
                      color: AppColors.textPrimary,
                    )
                  else
                    const SizedBox(width: 48),
                  TextButton(
                    onPressed: _skip,
                    child: Row(
                      children: [
                        Text(
                          'Skip',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: _onboardingData[index],
                  );
                },
              ),
            ),

            // Bottom section with indicators and button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Next/Get Started button
                  AppButton(
                    text: _currentPage == _onboardingData.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: _next,
                    width: double.infinity,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.background,
                      size: 20,
                    ),
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

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image section
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              // Background image
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(data.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient overlay for better text readability
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),

              // Icons overlay (for checkout screen)
              if (data.showIcons)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.9),
                  ),
                  child: Center(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=600&h=800&fit=crop',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Text section
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                Text(
                  data.title,
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  data.description,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imageUrl;
  final bool showIcons;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.showIcons = false,
  });
}
