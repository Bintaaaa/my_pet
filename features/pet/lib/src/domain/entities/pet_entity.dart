import 'package:equatable/equatable.dart';

class PetEntity extends Equatable {
  final int id;
  final String name;
  final String category;
  final List<String> photoUrls;
  final String status;
  final List<String> tags;

  const PetEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.photoUrls,
    required this.status,
    required this.tags,
  });

  @override
  List<Object?> get props => [id, name, category, status];
}
