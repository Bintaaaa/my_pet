import 'package:feature_pet/src/domain/entities/pet_entity.dart';

class PetModel {
  final int? id;
  final CategoryModel? category;
  final String? name;
  final List<String>? photoUrls;
  final List<TagModel>? tags;
  final String? status;

  const PetModel({
    this.id,
    this.category,
    this.name,
    this.photoUrls,
    this.tags,
    this.status,
  });

  factory PetModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PetModel();

    final category = json['category'] is Map
        ? CategoryModel.fromJson(Map<String, dynamic>.from(json['category']))
        : null;

    final photos = (json['photoUrls'] as List?)
        ?.whereType<String>()
        .toList();

    final tagList = (json['tags'] as List?)
        ?.whereType<Map>()
        .map((e) => TagModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return PetModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse('${json['id']}'),
      category: category,
      name: json['name']?.toString(),
      photoUrls: photos,
      tags: tagList,
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category?.toJson(),
    'name': name,
    'photoUrls': photoUrls,
    'tags': tags?.map((t) => t.toJson()).toList(),
    'status': status,
  };

  PetEntity toEntity() {
    return PetEntity(
      id: id ?? 0,
      name: name ?? '-',
      category: category?.name ?? '-',
      photoUrls: photoUrls ?? const [],
      status: status ?? 'unknown',
      tags: tags?.map((e) => e.name ?? '').where((e) => e.isNotEmpty).toList() ?? const [],
    );
  }
}

class CategoryModel {
  final int? id;
  final String? name;

  const CategoryModel({this.id, this.name});

  factory CategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CategoryModel();
    return CategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class TagModel {
  final int? id;
  final String? name;

  const TagModel({this.id, this.name});

  factory TagModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TagModel();
    return TagModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
