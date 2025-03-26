import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class PictureWidget extends StatelessWidget {
  PictureWidget({
    required this.tempImage,
    required this.networkImage,
    required this.isBefore,
    required this.onTap,
  });

  final File? tempImage;
  final networkImage;
  final bool isBefore;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    print('Temp_Image');
    print(tempImage);
    print('networkImage');
    print(networkImage);
    print('isBefore');
    print(isBefore);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          networkImage == null
              ? Container(
                  decoration: BoxDecoration(
                    color: Color(0XFFE9E9E9),
                    borderRadius: isBefore == true
                        ? BorderRadius.horizontal(left: Radius.circular(8.w))
                        : BorderRadius.horizontal(right: Radius.circular(8.w)),
                  ),
                  child: tempImage == null
                      ? Center(
                          child: SvgPicture.asset(
                            'assets/svg/camera.svg',
                            width: 50.h,
                            height: 50.h,
                          ),
                        )
                      : Image.file(
                          tempImage!,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                )
              // : ClipRRect(
              //     borderRadius: isBefore == true ? BorderRadius.horizontal(left: Radius.circular(8.w)) : BorderRadius.horizontal(right: Radius.circular(8.w)),
              //     child: FadeInImage(
              //       fit: BoxFit.cover,
              //       height: 194.h,
              //       // width: 100.h,
              //       image: NetworkImage(
              //         '${urlMediaRoute}${networkImage}',
              //       ),
              //       placeholder: NetworkImage(
              //         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwJclpF4yBA3FMXfmu05Wrf6jhYTlZFRIqIZjfsfAcEntbCUAUg4pvI9T-R1ISN3JUzek&usqp=CAU',
              //       ),
              //       imageErrorBuilder: (context, error, stackTrace) {
              //         return Image.network(
              //           'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop',
              //           fit: BoxFit.cover,
              //           // height: 100.h,
              //           // width: 100.h,
              //         );
              //       },
              //     ),
              //   ),
              ///
              //     : Container(
              //         decoration: BoxDecoration(
              //           image: DecorationImage(
              //             image: NetworkImage(
              //               '${urlMediaRoute}${networkImage}',
              //             ),
              //             fit: BoxFit.cover,
              //           ),
              //           color: Color(0XFFE9E9E9),
              //           borderRadius: isBefore == true ? BorderRadius.horizontal(left: Radius.circular(8.w)) : BorderRadius.horizontal(right: Radius.circular(8.w)),
              //         ),
              //       ),
              : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.teal,
                    borderRadius: isBefore == true
                        ? BorderRadius.horizontal(left: Radius.circular(8.w))
                        : BorderRadius.horizontal(right: Radius.circular(8.w)),
                  ),
                  // constraints: ,
                  child: ClipRRect(
                    borderRadius: isBefore == true
                        ? BorderRadius.horizontal(left: Radius.circular(8.w))
                        : BorderRadius.horizontal(right: Radius.circular(8.w)),
                    child: FadeInImage(
                      fit: BoxFit.fitWidth,
                      height: 194.h,
                      // width: 100.h,
                      image: NetworkImage('${urlMediaRoute}${networkImage}'),
                      placeholder: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwJclpF4yBA3FMXfmu05Wrf6jhYTlZFRIqIZjfsfAcEntbCUAUg4pvI9T-R1ISN3JUzek&usqp=CAU'),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwJclpF4yBA3FMXfmu05Wrf6jhYTlZFRIqIZjfsfAcEntbCUAUg4pvI9T-R1ISN3JUzek&usqp=CAU',
                          // fit: BoxFit.cover,
                          // height: 100.h,
                          // width: 100.h,
                        );
                      },
                    ),
                  ),
                ),
          isBefore == true
              ? Positioned(
                  top: 0,
                  left: 0,
                  child: PictureTabWidget(isBefore: isBefore),
                )
              : Positioned(
                  top: 0,
                  right: 0,
                  child: PictureTabWidget(isBefore: isBefore),
                ),
        ],
      ),
    );
  }
}

class PictureTabWidget extends StatelessWidget {
  const PictureTabWidget({
    super.key,
    required this.isBefore,
  });

  final bool isBefore;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 60.w,
      decoration: BoxDecoration(
        color: buttonClr,
        borderRadius: isBefore == true
            ? BorderRadius.only(
                topLeft: Radius.circular(8.w),
                bottomRight: Radius.circular(30.w),
              )
            : BorderRadius.only(
                topRight: Radius.circular(8.w),
                bottomLeft: Radius.circular(30.w),
              ),
      ),
      child: Center(
        child: Text(
          isBefore == true ? 'Before' : 'After',
          style: textField_16_LabelTextStyle,
        ),
      ),
    );
  }
}
