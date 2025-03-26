// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/provider/completed_order_provider.dart';
import 'package:provider/provider.dart';

import '../../../misc/constants.dart';

class ImagePreviewScreen extends StatefulWidget {
  const ImagePreviewScreen({super.key});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      body: ImagePreviewCarousel(),
    );
  }
}

class ImagePreviewCarousel extends StatefulWidget {
  const ImagePreviewCarousel({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePreviewCarouselState createState() => _ImagePreviewCarouselState();
}

class _ImagePreviewCarouselState extends State<ImagePreviewCarousel> {
  int _currentIndex = 0;
  final controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CompletedOrderProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(),
        CarouselSlider(
          carouselController: controller,
          options: CarouselOptions(
            height: 450,
            viewportFraction: 1.0,
            onPageChanged: (index, _) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: provider.imageUrls.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Match image width to device width
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: '$urlBase$imageUrl',
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: provider.imageUrls.map((url) {
              int index = provider.imageUrls.indexOf(url);
              return GestureDetector(
                onTap: () {
                  controller.jumpToPage(index);
                },
                child: Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? myColors.greyTxt
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(8)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: '$urlBase${provider.imageUrls[index]}',
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _currentIndex == index
                            ? Colors.transparent
                            : Colors.black.withOpacity(.3),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
