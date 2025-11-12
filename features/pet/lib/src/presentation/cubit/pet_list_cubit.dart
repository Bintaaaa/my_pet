import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import '../../domain/usecases/get_pets_usecase.dart';
import 'pet_list_state.dart';

class PetListCubit extends Cubit<PetListState> {
  final GetPetsUseCase usecase;

  PetListCubit({required this.usecase})
      : super(
     PetListState(
      statePetList: ViewData.initial(),
    ),
  );

  Future<void> fetchPets({String status = 'available'}) async {
    emit(
      state.copyWith(
        statePetList: ViewData.loading(),
      ),
    );

    final result = await usecase.call(status);
    if (result.isOk) {
      final pets = result.value;
      if (pets.isEmpty) {
        emit(
          state.copyWith(
            statePetList: ViewData.noData('No pets available'),
          ),
        );
      } else {
        emit(
          state.copyWith(
            statePetList: ViewData.hasData(pets),
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          statePetList: ViewData.error(
            result.failure.message,
          ),
        ),
      );
    }
  }
}
