// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/completed_order_provider.dart';
import '../../screens/open_order/completed_order/before_after_image_preview.dart';
import '../chat_model.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({
    super.key,
    required this.showRight,
    required this.message,
    required this.sameDate,
  });

  final bool showRight;
  final ChatModel message;
  final bool sameDate;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return (widget.message.message == null || widget.message.message == "") &&
            (widget.message.imageList == null ||
                widget.message.imageList!.isEmpty)
        ? SizedBox.shrink()
        : Align(
            alignment:
                widget.showRight ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: widget.showRight
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  widget.message.createdTime != null
                      ? Visibility(
                          visible: !widget.sameDate,
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              constraints: BoxConstraints(
                                maxWidth: 140,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x0C11111A),
                                    blurRadius: 32,
                                    offset: Offset(0, 8),
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Color(0x0C11111A),
                                    blurRadius: 16,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Text(
                                DateFormat('d MMMM')
                                    .format(widget.message.createdTime!),
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  widget.message.createdTime != null
                      ? Text(
                          DateFormat.jm().format(widget.message.createdTime!),
                          // "${widget.message.createdTime}",
                        )
                      : SizedBox.shrink(),
                  (widget.message.message == null ||
                          widget.message.message == "")
                      ? SizedBox.shrink()
                      : Container(
                          constraints: BoxConstraints(maxWidth: 280),
                          padding: EdgeInsets.symmetric(
                              vertical: 12.5, horizontal: 16),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x0C11111A),
                                blurRadius: 32,
                                offset: Offset(0, 8),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Color(0x0C11111A),
                                blurRadius: 16,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(24),
                              topLeft:
                                  Radius.circular(widget.showRight ? 24 : 0),
                              bottomRight:
                                  Radius.circular(widget.showRight ? 0 : 24),
                              bottomLeft: Radius.circular(24),
                            ),
                            color: widget.showRight
                                ? myColors.green
                                : Colors.white,
                          ),
                          child: Text(
                            widget.message.message ?? '',
                            style: interText(
                                16,
                                widget.showRight ? Colors.white : Colors.black,
                                FontWeight.w400),
                          ),
                        ),
                  widget.message.imageList!.isNotEmpty
                      ? Column(
                          children: List.generate(
                              widget.message.imageList!.length, (int index) {
                            return Container(
                              margin: EdgeInsets.only(top: 8),
                              width: 290,
                              height: 190,
                              decoration: BoxDecoration(
                                color: AppColors.dividerColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                onTap: () {
                                  var provider =
                                      context.read<CompletedOrderProvider>();
                                  provider.setImageToPreview(
                                      [widget.message.imageList![index]]);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ImagePreviewScreen()));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${urlBase}${widget.message.imageList![index]}",
                                  ),
                                ),
                              ),
                            );
                          }),
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          );
  }
}
