import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:provider/provider.dart';

import '../../chat/chat_provider.dart';
import 'live_agent_screen.dart';

class SupportChatScreen extends StatefulWidget {
  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> quickResponses = [
    "Update account or document",
    "Order cancel",
    "Earnings and tips",
    "Chat with real human"
  ];

  @override
  void initState() {
    addInitialMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Help Abode Support",
          style: interText(18, Colors.black, FontWeight.w600),
        ),
        actions: [TextButton(onPressed: () {}, child: Text("End"))],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messages[index];
                final isUser = message.containsKey("user");

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? myColors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message.values.first,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (chatProvider.showQuickResponse)
            _buildQuickResponseSection(context),
          _buildMessageInputSection(context),
        ],
      ),
    );
  }

  Widget _buildQuickResponseSection(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose a quick response below:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ...quickResponses.map((response) {
            return Container(
              width: 300,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        chatProvider.setQuickResponse(false);
                        if (response == 'Chat with real human') {
                          Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => LiveAgentScreen()));
                        } else {
                          chatProvider.addMessage("user", response);
                          chatProvider.addMessage("bot",
                              "Processing your request for '$response'...");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: response == "Chat with real human"
                            ? Colors.grey
                            : Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      child: Text(response),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMessageInputSection(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.grey),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Type Message",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.green),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                chatProvider.setQuickResponse(false);
                chatProvider.addMessage("user", _controller.text);
                _controller.clear();
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => LiveAgentScreen()));
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void addInitialMessage() {
    var chatProvider = context.read<ChatProvider>();
    chatProvider.clearChatHistory();
    chatProvider.setQuickResponse(true);
    chatProvider.addMessage(
        "bot", "Hi, I’m your Help Abode virtual assistant.");
    chatProvider.addMessage("bot",
        "You can select one of the issues below or if it’s something else, please type it in. If I can’t help you, I’ll contact you with one of my human teammates.");
  }
}
