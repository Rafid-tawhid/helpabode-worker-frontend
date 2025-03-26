import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SingleLineShimmer extends StatelessWidget {
  final int? itemCount;
  final double itemHeight;
  final double spacing;
  final double borderRadius;

  const SingleLineShimmer({
    Key? key,
    this.itemCount,
    this.itemHeight = 48.0,
    this.spacing = 12.0,
    this.borderRadius = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int count = itemCount == null ? 5 : itemCount!;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(count, (index) {
          return Column(
            children: [
              Container(
                height: itemHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              if (index != count - 1) SizedBox(height: spacing),
            ],
          );
        }),
      ),
    );
  }
}
