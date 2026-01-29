import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../configuration/managers/font_manager.dart';
import '../../../configuration/managers/style_manager.dart';
import '../../../configuration/routers/route_names.dart';
import '../../../core/components/button_app_component.dart';
import '../components/on_boarding_content_component.dart';
import '../models/on_boarding_mdoel.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  List<OnBoardingPage> _onBoardingPages(BuildContext context) => [
    OnBoardingPage(
      image: AppAssets.onBoarding1,
      title: LocaleKeys.onBoardingTitle1.tr(),
      description1: LocaleKeys.onBoardingDesc1.tr(),
      description2: LocaleKeys.onBoardingDesc2.tr(),
    ),
    OnBoardingPage(
      image: AppAssets.onBoarding2,
      title: LocaleKeys.onBoardingTitle2.tr(),
      description1: LocaleKeys.onBoardingDesc3.tr(),
      description2: LocaleKeys.onBoardingDesc4.tr(),
    ),
    OnBoardingPage(
      image: AppAssets.onBoarding3,
      title: LocaleKeys.onBoardingTitle3.tr(),
      description1: LocaleKeys.onBoardingDesc5.tr(),
      description2: LocaleKeys.onBoardingDesc6.tr(),
    ),
  ];

  void _navigateToNextPage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, RoutersNames.layoutScreen);
    } else {
      Navigator.pushReplacementNamed(context, RoutersNames.authenticationFlow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = _onBoardingPages(context);

    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    itemBuilder: (context, index) => OnBoardingPageWidget(
                      page: pages[index],
                      currentPage: _currentPage,
                      totalPages: pages.length,
                    ),
                  ),
                ),
                _buildPageIndicator(pages.length),
                const SizedBox(height: 16),
                _buildNavigationButton(pages.length),
              ],
            ),
            _buildSkipButton(pages.length),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _currentPage == index ? context.scale(10) : context.scale(6),
          height: _currentPage == index ? context.scale(10) : context.scale(6),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? ColorManager.primaryColor : ColorManager.primaryColor2,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(int totalPages) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ButtonAppComponent(
        width: double.infinity,
        height: 46,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: ColorManager.primaryColor,
          borderRadius: BorderRadius.circular(context.scale(20)),
        ),
        buttonContent: Center(
          child: Text(
            _currentPage == totalPages - 1
                ? LocaleKeys.login.tr()
                : LocaleKeys.next.tr(),
            style: getBoldStyle(
              color: ColorManager.whiteColor,
              fontSize: FontSize.s14,
            ),
          ),
        ),
        onTap: () {
          if (_currentPage == totalPages - 1) {
            _navigateToNextPage();
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        },
      ),
    );
  }

  Widget _buildSkipButton(int totalPages) {
    return PositionedDirectional(
      top: context.scale(16),
      end: context.scale(16),
      child: Visibility(
        visible: _currentPage != totalPages - 1,
        child: GestureDetector(
          onTap: _navigateToNextPage,
          child: Text(
            LocaleKeys.skip.tr(),
            style: getMediumStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12,
            ),
          ),
        ),
      ),
    );
  }
}
