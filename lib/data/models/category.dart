class ClsCategory {
  ClsCategory({
    required this.categoryId,
    required this.categoryName,
    this.parentId,
    this.type,
  });

  String categoryId;
  String categoryName;
  int? parentId;
  String? type;

  factory ClsCategory.fromJson(Map<String, dynamic> jsonData) => ClsCategory(
        categoryId: jsonData['category_id'] ?? "",
        categoryName: jsonData['category_name'] ?? "",
        parentId: jsonData['parent_id'] ?? "",
        type: jsonData['type'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'category_name': categoryName,
        'parent_id': parentId,
        'type': type,
      };
}
