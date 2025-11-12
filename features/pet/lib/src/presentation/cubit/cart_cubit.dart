import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import '../../data/repositories/cart_repository.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecases/checkout_cart_usecase.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository cartRepository;
  final CheckoutCartUseCase checkoutCartUseCase;

  CartCubit({required this.cartRepository, required this.checkoutCartUseCase})
      : super( CartState(stateCart: ViewData.initial()));

  Future<void> loadCart() async {
    emit(state.copyWith(stateCart: ViewData.loading()));
    final res = await cartRepository.getCart();
    if (res.isOk) {
      final items = res.value;
      if (items.isEmpty) {
        emit(state.copyWith(stateCart: ViewData.noData('Cart is empty')));
      } else {
        emit(state.copyWith(stateCart: ViewData.hasData(items)));
      }
    } else {
      emit(state.copyWith(stateCart: ViewData.error(res.failure.message)));
    }
  }

  Future<void> addToCart(CartItemEntity item) async {
    final res = await cartRepository.addToCart(item);
    if (res.isOk) {
      await loadCart();
    } else {
      emit(state.copyWith(stateCart: ViewData.error(res.failure.message)));
    }
  }

  Future<void> removeFromCart(int petId) async {
    final res = await cartRepository.removeFromCart(petId);
    if (res.isOk) {
      await loadCart();
    } else {
      emit(state.copyWith(stateCart: ViewData.error(res.failure.message)));
    }
  }

  Future<void> checkout() async {
    emit(state.copyWith(stateCart: ViewData.loading()));
    final res = await checkoutCartUseCase.call(null);
    if (res.isOk) {
      emit(state.copyWith(stateCart: ViewData.noData('Checkout complete')));
    } else {
      emit(state.copyWith(stateCart: ViewData.error(res.failure.message)));
    }
  }
}
