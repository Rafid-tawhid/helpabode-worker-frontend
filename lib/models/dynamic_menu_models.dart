class DynamicMenuModels {
  final String moduleName;
  final String moduleTextId;
  final String isCreate;
  final String isRead;
  final String isDelete;
  final String isUpdate;

  DynamicMenuModels({
    required this.moduleName,
    required this.moduleTextId,
    required this.isCreate,
    required this.isRead,
    required this.isDelete,
    required this.isUpdate,
  });

  // Factory method to create an object from JSON
  factory DynamicMenuModels.fromJson(Map<String, dynamic> json) {
    return DynamicMenuModels(
      moduleName: json['moduleName'] ?? '',
      moduleTextId: json['moduleTextId'] ?? '',
      isCreate: json['isCreate'] ?? 'N',
      isRead: json['isRead'] ?? 'N',
      isDelete: json['isDelete'] ?? 'N',
      isUpdate: json['isUpdate'] ?? 'N',
    );
  }

  // Convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'moduleName': moduleName,
      'moduleTextId': moduleTextId,
      'isCreate': isCreate,
      'isRead': isRead,
      'isDelete': isDelete,
      'isUpdate': isUpdate,
    };
  }

  @override
  String toString() {
    return 'ModulePermission(moduleName: $moduleName, moduleTextId: $moduleTextId, isCreate: $isCreate, isRead: $isRead, isDelete: $isDelete, isUpdate: $isUpdate)';
  }
}
