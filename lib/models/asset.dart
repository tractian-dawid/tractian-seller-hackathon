class Asset {
  final int id;
  final String name;
  final String image; // URL da imagem
  final int sensornumber;
  bool isSelected;
  int quantity;

  Asset({
    required this.id,
    required this.name,
    required this.image,
    required this.sensornumber,
    this.isSelected = false,
    this.quantity = 0,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      sensornumber: json['sensornumber'] ?? 1,
      isSelected: json['isSelected'] ?? false,
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'sensornumber': sensornumber,
      'isSelected': isSelected,
      'quantity': quantity,
    };
  }

  Asset copyWith({
    int? id,
    String? name,
    String? image,
    int? sensornumber,
    bool? isSelected,
    int? quantity,
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      sensornumber: sensornumber ?? this.sensornumber,
      isSelected: isSelected ?? this.isSelected,
      quantity: quantity ?? this.quantity,
    );
  }
}
