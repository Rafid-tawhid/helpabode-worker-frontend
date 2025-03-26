import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/chat/chat_provider.dart';
import 'package:help_abode_worker_app_ver_2/chat/views/chat_screen.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/chat_list_model.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/widgets/single_line_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../auth/helper.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    Future.microtask(() {
      callMessageInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Consumer<ChatProvider>(
          builder: (context, pro, _) => pro.chatInfoList.isNotEmpty
              ? MessageListView()
              : const NoMessagesView(),
        ));
  }

  void callMessageInfo() {
    debugPrint('Calling......1');
    var cp = context.read<ChatProvider>();
    cp.getMessageInfo();
  }
}

class NoMessagesView extends StatelessWidget {
  const NoMessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Messages',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'No recent messages found for your latest delivery.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class MessageListView extends StatelessWidget {
  const MessageListView({super.key});

  @override
  Widget build(BuildContext context) {
    // final List<MessageItem> messages = [
    //   MessageItem(
    //     name: 'Omar Faruk',
    //     message: "Hi Jason- I'm having trouble finding the...",
    //     time: '4:53 PM',
    //     orderStatus: 'Current Order',
    //     unreadCount: 5,
    //   ),
    //   MessageItem(
    //     name: 'Liam Carter',
    //     message: "Hey Alex! I'm struggling to locate the...",
    //     time: '4:53 PM',
    //     orderStatus: 'Current Order',
    //     unreadCount: 0,
    //   ),
    //   MessageItem(
    //     name: 'Sofia Patel',
    //     message: "Hello Sam! I'm having a hard time tracking...",
    //     time: '4:53 PM',
    //     orderStatus: 'Completed Order',
    //     unreadCount: 0,
    //   ),
    //   MessageItem(
    //     name: 'Ethan Nguyen',
    //     message: "Hi Taylor! I'm finding it difficult to disco...",
    //     time: '4:53 PM',
    //     orderStatus: 'Current Order',
    //     unreadCount: 2,
    //   ),
    //   MessageItem(
    //     name: 'Ava Johnson',
    //     message: "Hey Jordan! I'm having issues pinpointing the...",
    //     time: '4:53 PM',
    //     orderStatus: 'Current Order',
    //     unreadCount: 0,
    //   ),
    // ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Messages',
                style: interText(24, Colors.black, FontWeight.bold),
              ),
              // Text(
              //   'No recent messages found for your latest delivery.',
              //   style: interText(14,Colors.black, FontWeight.w400),
              // ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<ChatProvider>(
              builder: (context, pro, _) => pro.chatHistoryLoading
                  ? SingleLineShimmer(
                      itemCount: 5,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: pro.chatInfoList.length,
                      itemBuilder: (context, index) {
                        final message = pro.chatInfoList[index];
                        return MessageTile(chat: message);
                      },
                    )),
        ),
      ],
    );
  }
}

class MessageTile extends StatelessWidget {
  final ChatInfoModelClass chat;

  const MessageTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          onTap: () async {
            var cp = context.read<ChatProvider>();
            if (await cp.getChat(chat.orderTimeId.toString())) {
              Helper.toScreen(
                context,
                ChatScreen(
                    receiverName: chat.receiverName??'',
                    receiverTextId: chat.senderTextId??'',
                    groupTextId: chat.groupTextId ?? '',
                    service: chat.serviceTitle ?? '',
                    orderTextId: chat.endUserOrderTextId ?? '',
                    orderTimeId: chat.orderTimeId.toString() ?? '',
                    workerId: chat.receiverTextId ?? ''),
              );
            }
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                '${urlBase}${chat.serviceImage}'), // Replace with actual image URL
          ),
          title: Text(chat.senderName??'',
            style:  TextStyle(fontWeight: chat.totalChats==0?FontWeight.w500: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.lastMessage ?? 'c',
                style:interText(14, myColors.green, FontWeight.bold),
              ),
              Text(
                chat.serviceTitle ?? '',
                style: const TextStyle(color: Colors.black54, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: chat.totalChats!=0? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatTimestamp(chat.lastMessageTime ?? ''),
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              if (chat.totalChats! > 0)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle
                  ),
                  child: Text(
                    '${chat.totalChats}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ):SizedBox.shrink(),
        ),
        Divider(height: .5, color: myColors.devider),
      ],
    );
  }

  String formatTimestamp(String timestamp) {
    DateTime inputDate = DateTime.parse(timestamp).toLocal();
    DateTime now = DateTime.now();

    if (inputDate.year == now.year &&
        inputDate.month == now.month &&
        inputDate.day == now.day) {
      return DateFormat.jm().format(inputDate); // e.g., "4:51 AM"
    } else if (inputDate.year == now.year) {
      return DateFormat('dd/MM').format(inputDate); // e.g., "12/04"
    } else {
      return DateFormat('yyyy').format(inputDate); // e.g., "2024"
    }
  }
}
