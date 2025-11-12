import 'package:core/core.dart';
import 'package:feature_pet/src/data/repositories/cart_repository.dart';
import '../repositories/pet_repository.dart';

class CheckoutCartUseCase extends UseCase<bool, void> {
  final PetRepository petRepository;
  final CartRepository cartRepository;

  CheckoutCartUseCase(this.petRepository, this.cartRepository);

  @override
  Future<Result<bool>> call(void params) async {
    final cartRes = await cartRepository.getCart();
    if (cartRes.isErr) return Result.err(cartRes.failure);

    final items = cartRes.value;
    if (items.isEmpty) return const Result.ok(true);

    for (final item in items) {
      final res = await petRepository.checkoutPet(item.petId, 1);
      if (res.isErr) {
        return Result.err(res.failure);
      }
    }

    await cartRepository.clearCart();
    return const Result.ok(true);
  }
}
