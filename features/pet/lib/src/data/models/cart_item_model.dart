import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/pet_entity.dart';

class CartItemModel {
  final int? id;
  final int? petId;
  final String? name;
  final String? category;
  final List<String>? photoUrls;

  const CartItemModel({
    this.id,
    this.petId,
    this.name,
    this.category,
    this.photoUrls,
  });

  factory CartItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CartItemModel();
    final photos = (json['photoUrls'] as List?)?.whereType<String>().toList();
    return CartItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      petId: json['petId'] is int ? json['petId'] : int.tryParse('${json['petId']}'),
      name: json['name']?.toString(),
      category: json['category']?.toString(),
      photoUrls: photos,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'name': name,
    'category': category,
    'photoUrls': photoUrls,
  };

  factory CartItemModel.fromEntity(CartItemEntity e) {
    return CartItemModel(
      petId: e.petId,
      name: e.name,
      category: e.category,
      photoUrls: e.photoUrls,
    );
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      petId: petId ?? 0,
      name: name ?? '-',
      category: category ?? '-',
      photoUrls: photoUrls ?? const [],
    );
  }

  factory CartItemModel.fromPetEntity(PetEntity e) {
    return CartItemModel(
      petId: e.id,
      name: e.name,
      category: e.category,
      photoUrls: e.photoUrls,
    );
  }
}
