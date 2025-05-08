class CategoryModel {
  final int id;
  final String name;
  final String state;

  CategoryModel({
    required this.id,
    required this.name,
    required this.state,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['category_id'],
      name: json['category_name'],
      state: json['category_state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': id,
      'category_name': name,
      'category_state': state,
    };
  }
}
