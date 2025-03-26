import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/api_services.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/chat_list_model.dart';
import 'chat_model.dart';

class ChatProvider with ChangeNotifier {
  // final ChatRepo chatRepo;
  //
  // ChatProvider({required this.chatRepo});

  List<ChatModel> _chatHistory = [];

  List<ChatModel> get chatHistory => _chatHistory;

  addSingleMessage(ChatModel chat) {
    _chatHistory.insert(0, chat);
    notifyListeners();
  }

  addAllMessageHistory(List<dynamic> messages) {
    _chatHistory.clear();
    try {
      for (var chat in messages) {
        _chatHistory.add(ChatModel.fromJson(chat));
      }
    } catch (e) {
      debugPrint("Error in getting chat history:-------------- $e");
    }
    notifyListeners();
  }

  clearChatHistory() {
    _chatHistory.clear();
    _messages.clear();
    notifyListeners();
  }

  XFile? _selectedImageFile;

  XFile? get selectedImageFile => _selectedImageFile;

  setSelectedImageFile(XFile? file) {
    _selectedImageFile = file;
    debugPrint(file.toString());
    notifyListeners();
  }

  List<XFile>? _selectedImageFileList = [];

  List<XFile>? get selectedImageFileList => _selectedImageFileList;

  setSelectedImageFileList(List<XFile>? fileList) {
    // _selectedImageFileList = fileList;
    _selectedImageFileList!.addAll(fileList ?? []);
    debugPrint(fileList.toString());
    notifyListeners();
  }

  addSingleImageFile(XFile? file) {
    file != null ? _selectedImageFileList!.add(file) : null;
    notifyListeners();
  }

  clearSelecteFileList() {
    _selectedImageFileList!.clear();
    notifyListeners();
  }

  bool _chatHistoryLoading = false;

  bool get chatHistoryLoading => _chatHistoryLoading;

  setLoading(bool status) {
    _chatHistoryLoading = status;
    notifyListeners();
  }

  List<dynamic> _chatImageList = [];

  List<dynamic> get chatImageList => _chatImageList;

  clearImageList() {
    _chatImageList.clear();
    notifyListeners();
  }

  Future<bool> getChat(String orderItem) async {
    final String url = '${urlBase}api/get-chat/${orderItem}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _chatHistory.clear();
        // Successful request
        final data = jsonDecode(response.body);

        for (var i in data['chatList']) {
          _chatHistory.add(ChatModel.fromJson(i));
        }
        debugPrint('_chatHistory ${_chatHistory.length}');
        return true;
      } else {
        // Request failed
        print('Failed to load chat. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error occurred while getting chat: $error');
      return false;
    }
  }

  Future<bool> saveChatImages(String chatGroupId) async {
    clearImageList();

    //https://enduser.dev.helpabode.com:54238
    var uri = Uri.parse('${urlBase}api/save-chat-image/');
    var request = http.MultipartRequest('POST', uri);

    // Add the bearer token to the headers
    request.headers['Authorization'] = 'Bearer ${token}';

    debugPrint('URI $uri ${selectedImageFileList!.length}');

    // Add the images to the request
    for (var imageFile in selectedImageFileList!) {
      var file = await http.MultipartFile.fromPath(
        'imageList',
        imageFile.path,
      );
      request.files.add(file);
    }

    // Add the groupTextId to the request
    request.fields['groupTextId'] = chatGroupId;

    try {
      var response = await request.send();

      debugPrint('Response $response');
      if (response.statusCode == 201) {
        await response.stream.transform(utf8.decoder).listen((value) async {
          try {
            var jsonResponse = jsonDecode(value);
            _chatImageList = jsonResponse["imageList"];

            notifyListeners();
          } catch (e) {
            debugPrint('Error decoding response: $e');
          }
        }).asFuture(); // Ensure that this part is awaited before returning

        return true;
      } else {
        String responseBody =
            await response.stream.transform(utf8.decoder).join();
        var data = jsonDecode(responseBody);
        Fluttertoast.showToast(
            msg: '${data['message'] ?? 'Something went wrong'}');
        debugPrint('Failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong: $e');
      debugPrint('An error occurred: $e');
      return false;
    }
  }

  void removeImage(int index) {
    debugPrint(index.toString());
    selectedImageFileList!.removeAt(index);
    selectedImageFileList!.forEach((e) {
      debugPrint(e.name);
    });
    notifyListeners();
  }

  List<ChatInfoModelClass> _chatInfoList = [];
  List<ChatInfoModelClass> get chatInfoList => _chatInfoList;

  void getMessageInfo() async {
    debugPrint('Calling......');
    ApiService apiService = ApiService();
    setLoading(true);
    var data = await apiService.getData('api/providerChatList/');
    setLoading(false);
    if (data != null) {
      _chatInfoList.clear();
      for (var i in data['chat_list']) {
        _chatInfoList.add(ChatInfoModelClass.fromJson(i));
      }
    }
    debugPrint('_chatInfoList ${_chatInfoList.length}');
    notifyListeners();
  }

  final List<Map<String, String>> _messages = [];

  List<Map<String, String>> get messages => _messages;

  void addMessage(String sender, String message) {
    _messages.add({sender: message});
    notifyListeners();
  }

  bool _showQuickResponse = true;
  bool get showQuickResponse => _showQuickResponse;

  setQuickResponse(bool val) {
    _showQuickResponse = val;
    notifyListeners();
  }

}
