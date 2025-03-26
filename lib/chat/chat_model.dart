import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  String? senderTextId;
  String? senderName;
  String? receiverTextId;
  String? receiverName;
  DateTime? createdTime;
  String? message;
  List<String>? imageList;
  String? messageTextId;
  String? status;

  ChatModel({
    this.senderTextId,
    this.senderName,
    this.receiverTextId,
    this.receiverName,
    this.createdTime,
    this.message,
    this.imageList,
    this.messageTextId,
    this.status,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        senderTextId: json["senderTextId"] ?? '',
        senderName: json["senderName"] ?? '',
        receiverTextId: json["receiverTextId"] ?? '',
        receiverName: json["receiverName"] ?? '',
        createdTime: json["createdTime"] != null
            ? DateTime.parse(json["createdTime"])
            : null,
        message: json["message"] ?? '',
        imageList: json["imageList"] != null
            ? List<String>.from(
                json["imageList"].map((x) => x),
              )
            : [],
        messageTextId: json["messageTextId"] ?? '',
        status: json["status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "senderTextId": senderTextId,
        "senderName": senderName,
        "receiverTextId": receiverTextId,
        "receiverName": receiverName,
        "createdTime": createdTime!.toIso8601String(),
        "message": message,
        "imageList": imageList,
        "messageTextId": messageTextId,
        "status": status,
      };
}
