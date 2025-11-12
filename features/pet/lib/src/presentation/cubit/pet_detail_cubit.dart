import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import '../../domain/usecases/get_pet_detail_usecase.dart';
import '../../domain/usecases/checkout_order_usecase.dart';
import 'pet_detail_state.dart';

class PetDetailCubit extends Cubit<PetDetailState> {
  final GetPetDetailUseCase getPetDetailUseCase;
  final CheckoutOrderUseCase checkoutOrderUseCase;

  PetDetailCubit({
    required this.getPetDetailUseCase,
    required this.checkoutOrderUseCase,
  }) : super( PetDetailState(
    statePetDetail: ViewData.initial(),
    stateCheckout: ViewData.initial(),
  ));

  Future<void> fetchPetDetail({required int id}) async {
    emit(state.copyWith(statePetDetail: ViewData.loading()));
    final result = await getPetDetailUseCase.call(id);
    if (result.isOk) {
      emit(state.copyWith(statePetDetail: ViewData.hasData(result.value)));
    } else {
      emit(state.copyWith(statePetDetail: ViewData.error(result.failure.message)));
    }
  }

  Future<void> checkout({required int petId, int quantity = 1}) async {
    emit(state.copyWith(stateCheckout: ViewData.loading()));
    final params = CheckoutParams(petId: petId, quantity: quantity);
    final result = await checkoutOrderUseCase.call(params);
    if (result.isOk) {
      emit(state.copyWith(stateCheckout: ViewData.hasData(true)));
    } else {
      emit(state.copyWith(stateCheckout: ViewData.error(result.failure.message)));
    }
  }
}
