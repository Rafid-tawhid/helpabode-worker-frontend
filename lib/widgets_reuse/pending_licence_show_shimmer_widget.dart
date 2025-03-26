import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class NetworkImageWithShimmer extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final String placeholder; // Path to your placeholder asset

  const NetworkImageWithShimmer({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          placeholder,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
