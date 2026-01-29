import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

class CardListingShimmer extends StatelessWidget {
  final double width;
  final double height;

  const CardListingShimmer({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    bool isScreenWidth = width == MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(context.scale(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(context.scale(12)),
              topRight: Radius.circular(context.scale(12)),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: width,
                height: context.scale(isScreenWidth ? 172 : 128),
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(context.scale(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: width * 0.7,
                    height: context.scale(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: context.scale(8)),
                _buildLocationRow(context),
                SizedBox(height: context.scale(8)),
                _buildDetailsRow(context),
                SizedBox(height: context.scale(8)),
                _buildPriceRow(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width * 0.5,
        height: context.scale(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: context.scale(40),
        height: context.scale(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildDetailsRow(BuildContext context) {
    bool isScreenWidth = width == MediaQuery.of(context).size.width;

    return Row(
      children: [
        if (isScreenWidth) _buildDetailItem(context),
        if (isScreenWidth) _buildVerticalDivider(context),
        _buildDetailItem(context),
        _buildVerticalDivider(context),
        _buildDetailItem(context),
        _buildVerticalDivider(context),
        _buildDetailItem(context),
      ],
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.scale(8)),
      child: Container(
        width: 1,
        height: 12,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    bool isScreenWidth = MediaQuery.of(context).size.width == width;

    return isScreenWidth
        ? Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: context.scale(60),
            height: context.scale(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        SizedBox(width: context.scale(24)),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: context.scale(96),
            height: context.scale(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(width: context.scale(35)),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: context.scale(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        )
      ],
    )
        : Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: context.scale(100),
        height: context.scale(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class CardShimmerList extends StatelessWidget {
  const CardShimmerList({super.key ,this.numberOfCards = 5 , required this.scrollDirection , required this.cardHeight , required this.cardWidth});

  final Axis scrollDirection ;
  final double cardWidth , cardHeight ;
  final int numberOfCards ;
   @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      itemCount: numberOfCards,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Padding(
          padding: cardWidth == context.screenWidth? EdgeInsets.symmetric(horizontal: context.scale(16) , vertical: context.scale(8)) : EdgeInsets.only(right: context.scale(16)),
          child: CardListingShimmer(
            width: cardWidth,
            height: cardHeight,
          ),
        );
      },
    );
  }
}