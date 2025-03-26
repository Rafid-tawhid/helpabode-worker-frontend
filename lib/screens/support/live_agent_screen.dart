import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/chat/views/chat_screen.dart';
import 'package:provider/provider.dart';

class LiveAgentScreen extends StatefulWidget {
  @override
  State<LiveAgentScreen> createState() => _LiveAgentScreenState();
}

class _LiveAgentScreenState extends State<LiveAgentScreen> {
  @override
  void initState() {
    gotoNextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.support_agent, size: 40, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Text(
              "Transferring to Live Agent...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Please wait while we connect you with\na support representative",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 20),
            _LoadingDots(),
          ],
        ),
      ),
    );
  }

  void gotoNextScreen() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => ChatScreen(
                  receiverName: 'Support Admin',
                  receiverTextId: 'receiverTextId',
                  groupTextId: 'groupTextId',
                  workerId: 'workerId',
                  orderTimeId: 'orderTimeId',
                  orderTextId: 'orderTextId')));
    });
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  __LoadingDotsState createState() => __LoadingDotsState();
}

class __LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this)
          ..repeat();
    _animation = IntTween(begin: 0, end: 3).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        String dots = '.' * (_animation.value + 1);
        return Text(
          dots,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
