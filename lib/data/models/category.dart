class ClsCategory {
  ClsCategory({
    required this.categoryId,
    required this.categoryName,
    this.parentId,
    this.type,
  });

  String categoryId;
  String categoryName;
  String? parentId;
  String? type;

  factory ClsCategory.fromJson(Map<String, dynamic> jsonData) => ClsCategory(
        categoryId: jsonData['category_id'].toString(),
        categoryName: jsonData['category_name'].toString(),
        parentId: jsonData['parent_id'].toString(),
        type: jsonData['type'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'category_name': categoryName,
        'parent_id': parentId,
        'type': type,
      };
}
