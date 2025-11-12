import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';
import '../../domain/entities/pet_entity.dart';

class PetListState extends Equatable {
  final ViewData<List<PetEntity>> statePetList;

  const PetListState({
    required this.statePetList,
  });

  PetListState copyWith({
    ViewData<List<PetEntity>>? statePetList,
  }) {
    return PetListState(
      statePetList: statePetList ?? this.statePetList,
    );
  }

  @override
  List<Object?> get props => [statePetList];
}
