import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';
import '../../domain/entities/pet_entity.dart';

class PetDetailState extends Equatable {
  final ViewData<PetEntity> statePetDetail;
  final ViewData<bool> stateCheckout;

  const PetDetailState({
    required this.statePetDetail,
    required this.stateCheckout,
  });

  PetDetailState copyWith({
    ViewData<PetEntity>? statePetDetail,
    ViewData<bool>? stateCheckout,
  }) {
    return PetDetailState(
      statePetDetail: statePetDetail ?? this.statePetDetail,
      stateCheckout: stateCheckout ?? this.stateCheckout,
    );
  }

  @override
  List<Object?> get props => [statePetDetail, stateCheckout];
}
