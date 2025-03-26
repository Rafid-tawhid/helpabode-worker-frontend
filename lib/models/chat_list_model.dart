class ChatInfoModelClass {
  String? _groupTextId;
  String? _serviceTitle;
  String? _serviceTextId;
  String? _serviceImage;
  int? _orderTimeId;
  String? _senderName;
  String? _senderTextId;
  String? _receiverName;
  String? _receiverTextId;
  String? _workerTextId;
  int? _totalChats;
  String? _lastMessage;
  String? _lastMessageTime;
  String? _orderStatus;
  String? _endUserOrderTextId;

  ChatInfoModelClass(
      {String? groupTextId,
      String? serviceTitle,
      String? serviceTextId,
      String? serviceImage,
      int? orderTimeId,
      String? senderName,
      String? senderTextId,
      String? receiverName,
      String? receiverTextId,
      String? workerTextId,
      int? totalChats,
      String? lastMessage,
      String? lastMessageTime,
      String? endUserOrderTextId,
      String? orderStatus}) {
    if (groupTextId != null) {
      this._groupTextId = groupTextId;
    }
    if (serviceTitle != null) {
      this._serviceTitle = serviceTitle;
    }
    if (serviceTextId != null) {
      this._serviceTextId = serviceTextId;
    }
    if (serviceImage != null) {
      this._serviceImage = serviceImage;
    }
    if (orderTimeId != null) {
      this._orderTimeId = orderTimeId;
    }
    if (senderName != null) {
      this._senderName = senderName;
    }
    if (senderTextId != null) {
      this._senderTextId = senderTextId;
    }
    if (receiverName != null) {
      this._receiverName = receiverName;
    }
    if (receiverTextId != null) {
      this._receiverTextId = receiverTextId;
    }
    if (workerTextId != null) {
      this._workerTextId = workerTextId;
    }
    if (totalChats != null) {
      this._totalChats = totalChats;
    }
    if (lastMessage != null) {
      this._lastMessage = lastMessage;
    }
    if (lastMessageTime != null) {
      this._lastMessageTime = lastMessageTime;
    }
    if (orderStatus != null) {
      this._orderStatus = orderStatus;
    }
    if (endUserOrderTextId != null) {
      this._endUserOrderTextId = endUserOrderTextId;
    }
  }

  String? get groupTextId => _groupTextId;
  String? get endUserOrderTextId => _endUserOrderTextId;
  set groupTextId(String? groupTextId) => _groupTextId = groupTextId;
  String? get serviceTitle => _serviceTitle;
  set serviceTitle(String? serviceTitle) => _serviceTitle = serviceTitle;
  String? get serviceTextId => _serviceTextId;
  set serviceTextId(String? serviceTextId) => _serviceTextId = serviceTextId;
  String? get serviceImage => _serviceImage;
  set serviceImage(String? serviceImage) => _serviceImage = serviceImage;
  int? get orderTimeId => _orderTimeId;
  set orderTimeId(int? orderTimeId) => _orderTimeId = orderTimeId;
  String? get senderName => _senderName;
  set senderName(String? senderName) => _senderName = senderName;
  String? get senderTextId => _senderTextId;
  set senderTextId(String? senderTextId) => _senderTextId = senderTextId;
  String? get receiverName => _receiverName;
  set receiverName(String? receiverName) => _receiverName = receiverName;
  String? get receiverTextId => _receiverTextId;
  set receiverTextId(String? receiverTextId) =>
      _receiverTextId = receiverTextId;
  String? get workerTextId => _workerTextId;
  set workerTextId(String? workerTextId) => _workerTextId = workerTextId;
  int? get totalChats => _totalChats;
  set totalChats(int? totalChats) => _totalChats = totalChats;
  String? get lastMessage => _lastMessage;
  set lastMessage(String? lastMessage) => _lastMessage = lastMessage;
  String? get lastMessageTime => _lastMessageTime;
  set lastMessageTime(String? lastMessageTime) =>
      _lastMessageTime = lastMessageTime;
  String? get orderStatus => _orderStatus;
  set orderStatus(String? orderStatus) => _orderStatus = orderStatus;
  set endUserOrderTextId(String? endUserOrderTextId) =>
      _endUserOrderTextId = endUserOrderTextId;

  ChatInfoModelClass.fromJson(Map<String, dynamic> json) {
    _groupTextId = json['groupTextId'];
    _serviceTitle = json['serviceTitle'];
    _serviceTextId = json['serviceTextId'];
    _serviceImage = json['serviceImage'];
    _endUserOrderTextId = json['endUserOrderTextId'];
    _orderTimeId = json['orderTimeId'];
    _senderName = json['senderName'];
    _senderTextId = json['senderTextId'];
    _receiverName = json['receiverName'];
    _receiverTextId = json['receiverTextId'];
    _workerTextId = json['workerTextId'];
    _totalChats = json['totalChats'];
    _lastMessage = json['lastMessage'];
    _lastMessageTime = json['lastMessageTime'];
    _orderStatus = json['orderStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupTextId'] = this._groupTextId;
    data['serviceTitle'] = this._serviceTitle;
    data['serviceTextId'] = this._serviceTextId;
    data['serviceImage'] = this._serviceImage;
    data['orderTimeId'] = this._orderTimeId;
    data['senderName'] = this._senderName;
    data['senderTextId'] = this._senderTextId;
    data['receiverName'] = this._receiverName;
    data['receiverTextId'] = this._receiverTextId;
    data['workerTextId'] = this._workerTextId;
    data['totalChats'] = this._totalChats;
    data['lastMessage'] = this._lastMessage;
    data['lastMessageTime'] = this._lastMessageTime;
    data['orderStatus'] = this._orderStatus;
    return data;
  }
}
