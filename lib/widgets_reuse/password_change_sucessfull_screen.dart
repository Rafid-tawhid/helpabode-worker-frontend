import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class PasswordChangeSucessfullScreen extends StatelessWidget {
  const PasswordChangeSucessfullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      context.pushNamed('home');
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/svg/reset_pass_bg.svg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Your Password has been changed',
                  textAlign: TextAlign.center,
                  style: interText(24, Colors.black, FontWeight.w700),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Log in to Help Abode account with new password',
                    textAlign: TextAlign.center,
                    style: interText(16, Colors.black, FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
