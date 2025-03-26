// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../widgets_reuse/custom_text_field.dart';
import '../../../../../widgets_reuse/expandable_text.dart';
import '../../provider/user_provider.dart';
import '../chat_model.dart';
import '../chat_provider.dart';
import '../widgets/chat_app-bar.dart';
import '../widgets/chat_box.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.receiverName, required this.receiverTextId, required this.groupTextId, this.service, required this.workerId, required this.orderTimeId, required this.orderTextId});

  final String receiverName;
  final String receiverTextId;
  final String groupTextId;
  final String orderTextId;
  final String orderTimeId;
  final dynamic service;
  final String workerId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  WebSocketChannel? _channel;

  void _connect() {
    var cp = context.read<ChatProvider>();

    String uri = 'ws://enduser.dev.helpabode.com:54238/ws/chat/${widget.groupTextId}/';
    debugPrint("---------Chat Socket URI is: -----------: $uri");

    _channel = WebSocketChannel.connect(
      Uri.parse(uri),
    );

    bool connectionSuccess = false;

    _channel!.stream.listen(
      (message) {
        // The first message received indicates the connection was successful
        if (!connectionSuccess) {
          connectionSuccess = true;
          debugPrint('WebSocket connection successful!');
        }

        // Handle incoming messages
        bool messageExist = cp.chatHistory.any((chat) => chat.messageTextId == jsonDecode(message)['messageTextId']);
        messageExist ? null : cp.addSingleMessage(ChatModel.fromJson(jsonDecode(message)));
        // Handle incoming messages
        // cp.addSingleMessage(ChatModel.fromJson(jsonDecode(message)));
        debugPrint("createdTime data type: ${jsonDecode(message)['createdTime'].runtimeType}");
        debugPrint("Hello minhaz. Websocket connected: ${jsonDecode(message)}");
      },
      onDone: () {
        if (!connectionSuccess) {
          debugPrint('WebSocket connection closed before any message was received.');
        } else {
          debugPrint('WebSocket connection closed.');
        }
      },
      onError: (error) {
        debugPrint('WebSocket connection failed: $error');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _connect();
    debugPrint('receiverName ${widget.receiverName}');
    debugPrint('receiverTextId ${widget.receiverTextId}');
    debugPrint('groupTextId ${widget.groupTextId}');
    debugPrint('orderTextId ${widget.orderTextId}');
    debugPrint('workerId ${widget.workerId}');
    // setSeenStatus();
  }

  // setSeenStatus() {
  //   var cp = context.read<ChatProvider>();
  //   var up = context.read<UserProvider>();
  //   for (var chat in cp.chatHistory) {
  //     if (chat.receiverName == up.textId) {
  //       chat.status = 'seen';
  //       _channel!.sink.add(jsonEncode(chatModelToJson(chat)));
  //       return;
  //     }
  //   }
  // }

  // void _sendMessage(bool fromSeen) async {
  //   var op = context.read<OrderProvider>();
  //   var cp = context.read<ChatProvider>();
  //
  //   // Fluttertoast.showToast(msg: '${widget.receiverName} ${widget.receiverTextId}');
  //   String? imageBase64;
  //   if (cp.selectedImageFile != null) {
  //     imageBase64 = await _convertImageToBase64(cp.selectedImageFile!.path);
  //   }
  //   var msg = {
  //     "message": _controller.text,
  //     "sender": "Provider",
  //     "senderTextId": op.pendingOrderInfoList.first.workerTextId,
  //     "receiverTextId": widget.receiverTextId,
  //     "groupTextId": widget.groupTextId,
  //     "imageList": imageBase64??[],
  //     // "senderName": '${up.firstName} ${up.lastName}',
  //     // "receiverName": widget.receiverName,
  //     // "createdTimeTime": DateTime.now().toString(),
  //   };
  //   debugPrint(msg.toString());
  //   if (_channel != null && _controller.text.isNotEmpty) {
  //     _channel!.sink.add(jsonEncode(msg));
  //     _controller.clear();
  //   }
  //   FocusScope.of(context).unfocus();
  //   _controller.clear();
  // }

  void _sendMessageMultipleImage(bool fromSeen) async {
    var cp = context.read<ChatProvider>();
    if (cp.selectedImageFileList != null && cp.selectedImageFileList!.isNotEmpty) {
      await cp.saveChatImages(widget.groupTextId).then(
        (status) async {
          if (status) {
            await cp.setSelectedImageFile(null);
            await cp.clearSelecteFileList();
            if (_channel != null) {
              _channel!.sink.add(
                jsonEncode(getMessageContent()),
              );
              cp.clearImageList();
              _controller.clear();
            }
          }
        },
      );
    } else {
      if (_channel != null) {
        _channel!.sink.add(jsonEncode(getMessageContent()));
        _controller.clear();
      }
    }
    FocusScope.of(context).unfocus();
    _controller.clear();
  }

  getMessageContent() {
    var up = context.read<UserProvider>();
    var cp = context.read<ChatProvider>();
    var msg = {
      "message": _controller.text,
      "sender": "Provider",
      "senderTextId": up.userModel.textId,
      "receiverTextId": widget.receiverTextId,
      "groupTextId": widget.groupTextId,
      "imageList": cp.chatImageList,
      "endUserOrderTextId": widget.orderTextId,
      "endUserOrderTimeId": widget.orderTimeId
      // "endUserOrderTextId": op.pendingOrderInfoList.first.orderTextId,
      // "endUserOrderTimeId":op.pendingOrderInfoList.first.orderItemId

      // "image": imageBase64,
      // "senderName": '${up.firstName} ${up.lastName}',
      // "receiverName": widget.receiverName,
      // "createdTimeTime": DateTime.now().toString(),
    };
    debugPrint("chat message contents are: $msg");
    return msg;
  }

  @override
  void dispose() {
    // _channel?.sink.close(status.goingAway);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var cp = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: AppColors.boxColor2,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: SizedBox.shrink(),
        flexibleSpace: FlexibleSpaceBar(
          title: ChatScreenAppBar(
            name: widget.receiverName,
          ),
          titlePadding: EdgeInsets.all(0),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Container(
              height: 42,
              decoration: BoxDecoration(
                color: Color(0xFFE9E9E9),
                border: Border.all(
                  color: Color(0xFFD9D9D9),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.service ?? 'House Cleaning',
                    style: interText(14, Colors.black, FontWeight.w600),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      debugPrint(cp.chatHistory.length.toString());
                    },
                    child: Text(
                      // "${cp.chatHistory.length}",
                      "See details",
                      style: interText(12, myColors.green, FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: cp.chatHistory.length,
              reverse: true,
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                ChatModel message = cp.chatHistory[index];
                return ChatBox(
                  // showRight: message.senderTextId == op.pendingOrderInfoList.first.workerTextId,
                  showRight: message.senderTextId == widget.workerId,
                  message: message,
                  sameDate: index == cp.chatHistory.length - 1
                      ? false
                      : message.createdTime != null
                          ? NecessaryMethods.sameDateCheck(
                              message.createdTime!,
                              cp.chatHistory[index + 1].createdTime,
                            )
                          : true,
                );
              },
            )),
            Container(
              color: Colors.white,
              width: double.infinity,
              height: cp.selectedImageFileList!.isNotEmpty ? 160 : 70,
              padding: EdgeInsets.only(top: 8),
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cp.selectedImageFileList!.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              cp.selectedImageFileList!.length,
                              (int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        height: 72,
                                        width: 120,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.file(
                                            File(cp.selectedImageFileList![index].path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        child: InkWell(
                                            onTap: () {
                                              cp.removeImage(index);
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            )),
                                        right: 0,
                                        top: 0,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          XFile? compressedImageFile = await NecessaryMethods.pickImage(context, isCamera: true);
                          cp.addSingleImageFile(compressedImageFile);
                        },
                        child: Icon(
                          // Icons.camera_alt_outlined,
                          CupertinoIcons.photo_camera,
                          size: 28,
                          color: myColors.green,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () async {
                          List<XFile>? compressedImageFileList = await NecessaryMethods.pickMultiImage(context);
                          cp.setSelectedImageFileList(
                            compressedImageFileList,
                          );

                          // XFile? compressedImageFile =
                          //     await NecessaryMethods.pickImage(context);
                          // cp.setSelectedImageFile(compressedImageFile);
                        },
                        child: Icon(
                          Icons.image_outlined,
                          color: myColors.green,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomTextFieldChat(
                          controller: _controller,
                          isShowBorder: false,
                          borderRadius: 30,
                          focusBorderColor: Colors.white,
                          enabledBorderColor: Colors.white,
                          fillColor: const Color(0xFFE9E9E9),
                          hintText: "Type message",
                          horizontalSize: 14,
                        ),
                        // child: CustomTextField(
                        //   controller: _controller,
                        //   isShowBorder: false,
                        //   focusBorderColor: Colors.white,
                        //   enabledBorderColor: Colors.white,
                        //   fillColor: Colors.white,
                        //   hintText: "Type message",
                        // ),
                      ),

                      // cp.selectedImageFile != null
                      //     ? Image.file(
                      //         File(cp.selectedImageFile!.path),
                      //         fit: BoxFit.cover,
                      //         height: 40,
                      //       )
                      //     : SizedBox.shrink(),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () {
                          // _sendMessage(false);
                          _sendMessageMultipleImage(false);
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.send,
                            color: myColors.green,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key, required this.receiverName, required this.receiverTextId, required this.groupTextId});
//   final String receiverName;
//   final String receiverTextId;
//   final String groupTextId;

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   WebSocketChannel? _channel;

//   void _connect() {
//     var cp = context.read<ChatProvider>();
//     String uri = 'ws://${urlBase}ws/chat/${widget.groupTextId}/';

//     debugPrint("---------Chat Socket URI is: -----------: $uri");

//     _channel = WebSocketChannel.connect(
//       // Uri.parse('wss://echo.websocket.org'),
//       Uri.parse(uri),
//     );

//     _channel!.stream.listen(
//       (message) {
//         // cp.chatHistory.insert(0, ChatModel.fromJson(jsonDecode(message)));
//         cp.addSingleMessage(ChatModel.fromJson(jsonDecode(message)));
//         debugPrint("createdTime  data type: ${jsonDecode(message)['createdTime'].runtimeType}");
//         debugPrint("Hello minhaz. Websocket connected: ${jsonDecode(message)}");
//       },
//       onDone: () {
//         debugPrint('WebSocket connection closed');
//       },
//       onError: (error) {
//         debugPrint('WebSocket error: $error');
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _connect();
//     // setSeenStatus();
//   }

//   // setSeenStatus() {
//   //   var cp = context.read<ChatProvider>();
//   //   var up = context.read<UserProvider>();
//   //   for (var chat in cp.chatHistory) {
//   //     if (chat.receiverName == up.textId) {
//   //       chat.status = 'seen';
//   //       _channel!.sink.add(jsonEncode(chatModelToJson(chat)));
//   //       return;
//   //     }
//   //   }
//   // }

//   void _sendMessage(bool fromSeen) {
//     var up = context.read<UserProvider>();
//     // Fluttertoast.showToast(msg: '${widget.receiverName} ${widget.receiverTextId}');
//     var msg = {
//       "message": _controller.text,
//       "sender": "EndUser",
//       "senderTextId": textId,
//       "receiverTextId": widget.receiverTextId,
//       "groupTextId": widget.groupTextId,
//       // "senderName": '${up.firstName} ${up.lastName}',
//       // "receiverName": widget.receiverName,
//       // "createdTimeTime": DateTime.now().toString(),
//     };
//     if (_channel != null && _controller.text.isNotEmpty) {
//       _channel!.sink.add(jsonEncode(msg));
//       _controller.clear();
//     }
//     FocusScope.of(context).unfocus();
//     _controller.clear();
//   }

//   @override
//   void dispose() {
//     // _channel?.sink.close(status.goingAway);
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var up = context.read<UserProvider>();
//     var cp = context.watch<ChatProvider>();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         centerTitle: false,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: SizedBox.shrink(),
//         flexibleSpace: FlexibleSpaceBar(
//           title: ChatScreenAppBar(),
//           titlePadding: EdgeInsets.all(0),
//         ),
//       ),
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: CustomScrollView(
//           slivers: [
//             SliverStickyHeader(
//               header: Container(
//                 height: 42,
//                 decoration: BoxDecoration(
//                   color: Color(0xFFE9E9E9),
//                   border: Border.all(
//                     color: Color(0xFFD9D9D9),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Text(
//                       "House Cleaning",
//                       style: interText(14, Colors.black, FontWeight.w400),
//                     ),
//                     Spacer(),
//                     TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         // "${cp.chatHistory.length}",
//                         "See details",
//                         style: interText(14, myColors.green, FontWeight.w400),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 8,
//                     ),
//                   ],
//                 ),
//               ),
//               sliver: SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   childCount: 1,
//                   (context, i) => SizedBox(
//                     height: MediaQuery.of(context).size.height - (200 + MediaQuery.of(context).padding.bottom),
//                     child: ListView.builder(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                       itemCount: cp.chatHistory.length,
//                       reverse: true,
//                       shrinkWrap: true,
//                       // physics: NeverScrollableScrollPhysics(),
//                       itemBuilder: (BuildContext context, int index) {
//                         ChatModel message = cp.chatHistory[index];

//                         return ChatBox(
//                           showRight: message.senderTextId == textId,
//                           message: message,
//                           sameDate: index == cp.chatHistory.length - 1
//                               ? false
//                               : message.createdTime != null
//                                   ? NecessaryMethods.sameDateCheck(
//                                       message.createdTime!,
//                                       cp.chatHistory[index + 1].createdTime,
//                                     )
//                                   : true,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Container(
//                 color: Colors.white,
//                 width: double.infinity,
//                 height: 80,
//                 padding: EdgeInsets.symmetric(horizontal: 0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: CustomTextFieldChat(
//                         controller: _controller,
//                         isShowBorder: false,
//                         focusBorderColor: Colors.white,
//                         enabledBorderColor: Colors.white,
//                         fillColor: Colors.white,
//                         hintText: "Type message",
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         // XFile? compressedImageFile = await NecessaryMethods.pickImage(context);
//                         // cp.setSelectedImageFile(compressedImageFile);
//                       },
//                       child: SvgPicture.asset('assets/svg/check.svg'),
//                     ),
//                     SizedBox(
//                       width: 12,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         _sendMessage(false);
//                       },
//                       child: Container(
//                         width: 52,
//                         height: 52,
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryColor,
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: Icon(
//                           Icons.subdirectory_arrow_right_rounded,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
