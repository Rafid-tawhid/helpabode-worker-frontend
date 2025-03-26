import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NetworkImageWithPlaceholder extends StatelessWidget {
  final String imageUrl;

  NetworkImageWithPlaceholder({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0), // Adjust the radius as needed
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 40,
        width: 40,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 40,
            width: 40,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 40,
          width: 40,
          color: Colors.grey,
          child: Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }
}
