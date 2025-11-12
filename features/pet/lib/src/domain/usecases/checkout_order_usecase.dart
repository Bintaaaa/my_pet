import 'package:core/core.dart';
import '../repositories/pet_repository.dart';

class CheckoutOrderUseCase extends UseCase<bool, CheckoutParams> {
  final PetRepository repository;

  CheckoutOrderUseCase(this.repository);

  @override
  Future<Result<bool>> call(CheckoutParams params) {
    return repository.checkoutPet(params.petId, params.quantity);
  }
}

class CheckoutParams {
  final int petId;
  final int quantity;
  const CheckoutParams({required this.petId, required this.quantity});
}
