import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CustomCircleShimmerImage extends StatelessWidget {
  final String imageUrl;
  final String placeholder;
  final double size;
  final double? borderRadius;

  CustomCircleShimmerImage({
    required this.imageUrl,
    required this.placeholder,
    required this.size,
    this.borderRadius, // Optional border radius
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: ClipRRect(
        borderRadius: borderRadius != null
            ? BorderRadius.circular(borderRadius!)
            : BorderRadius.circular(size / 2),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            placeholder,
            fit: BoxFit.cover,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
