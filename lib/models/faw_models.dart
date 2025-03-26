import 'dart:math';

class FawModels {
  FawModels({
    String? question,
    String? answer,
    String? faqType,
    num? rank,
    String? status,
    String? created,
    bool clicked = false,
    String? clickedId,
  }) {
    _question = question;
    _answer = answer;
    _faqType = faqType;
    _rank = rank;
    _status = status;
    _created = created;
    _clicked = clicked ?? false;
    _clickedId = clickedId ?? _generateUniqueId();
  }

  FawModels.fromJson(dynamic json) {
    _question = json['question'];
    _answer = json['answer'];
    _faqType = json['faqType'];
    _rank = json['rank'];
    _status = json['status'];
    _created = json['created'];
    _clicked = json['clicked'] ?? false;
    _clickedId = json['clickedId'] ?? _generateUniqueId();
  }

  String? _question;
  String? _answer;
  String? _faqType;
  num? _rank;
  String? _status;
  String? _created;
  bool _clicked = false;
  String? _clickedId;

  FawModels copyWith({
    String? question,
    String? answer,
    String? faqType,
    num? rank,
    String? status,
    String? created,
    bool clicked = false,
    String? clickedId,
  }) =>
      FawModels(
        question: question ?? _question,
        answer: answer ?? _answer,
        faqType: faqType ?? _faqType,
        rank: rank ?? _rank,
        status: status ?? _status,
        created: created ?? _created,
        clicked: clicked ?? _clicked,
        clickedId: clickedId ?? _clickedId,
      );

  String? get question => _question;
  String? get answer => _answer;
  String? get faqType => _faqType;
  num? get rank => _rank;
  String? get status => _status;
  String? get created => _created;
  bool get clicked => _clicked;
  String? get clickedId => _clickedId;

  set clicked(bool value) {
    _clicked = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question'] = _question;
    map['answer'] = _answer;
    map['faqType'] = _faqType;
    map['rank'] = _rank;
    map['status'] = _status;
    map['created'] = _created;
    map['clicked'] = _clicked;
    map['clickedId'] = _clickedId;
    return map;
  }

  // Method to generate a unique random number as a string
  String _generateUniqueId() {
    final random = Random();
    return random.nextInt(100000000).toString();
  }
}
