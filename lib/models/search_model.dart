class SearchModel {
  final int id;
  final String? cityTextId;
  final String? stateTextId;
  final String? zip;
  final String? stateName;
  final String? stateShortName;
  final String? countryIso2Code;
  final String? countryName;
  final String? countryShortName;
  bool isSelected;

  SearchModel({
    required this.id, // Added id attribute
    this.cityTextId,
    this.stateTextId,
    this.zip,
    this.stateName,
    this.stateShortName,
    this.countryIso2Code,
    this.countryName,
    this.countryShortName,
    this.isSelected = false, // Add isSelected with default value false
  });

  SearchModel.fromJson(dynamic json)
      : id = json['id'],
        cityTextId = json['cityTextId'],
        stateTextId = json['stateTextId'],
        zip = json['zip'],
        stateName = json['stateName'],
        stateShortName = json['stateShortName'],
        countryIso2Code = json['countryIso2Code'],
        countryName = json['countryName'],
        countryShortName = json['countryShortName'],
        isSelected =
            json['isSelected'] ?? false; // Initialize isSelected from JSON

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cityTextId': cityTextId,
      'stateTextId': stateTextId,
      'zip': zip,
      'stateName': stateName,
      'stateShortName': stateShortName,
      'countryIso2Code': countryIso2Code,
      'countryName': countryName,
      'countryShortName': countryShortName,
      'isSelected': isSelected,
    };
  }
}
