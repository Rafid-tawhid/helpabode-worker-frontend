import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

import '../helper_functions/colors.dart';
import '../helper_functions/dashboard_helpers.dart';

class UserInfoRow extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final VoidCallback onImageTap;
  final VoidCallback onCallTap;
  final VoidCallback onChatTap;

  const UserInfoRow({
    Key? key,
    required this.imageUrl,
    required this.userName,
    required this.onImageTap,
    required this.onCallTap,
    required this.onChatTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onImageTap,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => _buildPlaceholder(context),
              errorWidget: (context, url, error) => _buildPlaceholder(context),
              height: 48,
              width: 48,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(color: myColors.green, width: 1),
                    borderRadius: BorderRadius.circular(50)),
                child: ClipOval(
                  child: Image(
                    image: imageProvider,
                    height: 44,
                    width: 44,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName.isNotEmpty ? userName : 'No name',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                GestureDetector(
                  onTap: onChatTap,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: myColors.devider,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                                color: myColors.primaryStroke, width: 1.7),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8.0, left: 16),
                                child: Icon(
                                  Icons.message,
                                  size: 18,
                                  color: Color(0xff777777),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Text(
                                  'Chat with Help Abode',
                                  style: interText(
                                      12, Color(0xff777777), FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: myColors.devider,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: myColors.primaryStroke, width: 1.7),
                        ),
                        child: IconButton(
                          onPressed: onCallTap,
                          icon: Icon(
                            Icons.call,
                            size: 20,
                            color: Color(0xff777777),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: Container(
          //     height: 42,
          //     width: 42,
          //     decoration: BoxDecoration(
          //       color: myColors.devider,
          //       borderRadius: BorderRadius.circular(30),
          //     ),
          //     child: IconButton(
          //       onPressed: onCallTap,
          //       icon: Icon(Icons.call, size: 24,color: Color(0xff777777),),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: myColors.green, width: 1),
      ),
      child: ClipOval(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: myColors.green,
          ),
          child: Text(
            DashboardHelpers.getFirstCharacterCombinationName(userName, null),
            style: interText(18, Colors.white, FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
