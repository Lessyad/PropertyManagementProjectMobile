import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/components/custom_image.dart';
import 'package:enmaa/core/entites/image_entity.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/features/home_module/domain/entities/banner_entity.dart';
import 'package:flutter/material.dart';

class BannersWidget extends StatefulWidget {
  const BannersWidget({
    super.key,
    required this.banners,
    this.padding = EdgeInsets.zero,
    this.height = 150,
    this.borderRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
  });

  final List<ImageEntity> banners;
  final EdgeInsets padding;
  final double height;
  final double borderRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;

  @override
  _BannersWidgetState createState() => _BannersWidgetState();
}

class _BannersWidgetState extends State<BannersWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isAutoScrolling = false;

  @override
  void initState() {
    super.initState();
    _currentPage = 0; // Start from the first image
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (_isAutoScrolling) return;
    if (widget.banners.isEmpty) return; // Éviter la division par zéro
    
    _isAutoScrolling = true;

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (_pageController.hasClients && widget.banners.isNotEmpty) {
        setState(() {
          _currentPage = (_currentPage + 1) % widget.banners.length;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
          );
        });
      }
      _isAutoScrolling = false;
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: widget.padding,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(context.scale(widget.borderRadius)),
              topRight: Radius.circular(context.scale(widget.borderRadius)),
              bottomLeft: Radius.circular(context.scale(widget.bottomLeftRadius)),
              bottomRight: Radius.circular(context.scale(widget.bottomRightRadius)),
            ),
            child: SizedBox(
              height: context.scale(widget.height),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemCount: widget.banners.length,
                    itemBuilder: (context, index) {
                      return CustomNetworkImage(
                        image: widget.banners[index].image,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Positioned(
                    bottom: context.scale(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.banners.length,
                            (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              _currentPage == index ? -1.5 : 0,
                            ),
                            child: Container(
                              width: context.scale(5),
                              height: context.scale(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? ColorManager.whiteColor
                                    : ColorManager.whiteColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
