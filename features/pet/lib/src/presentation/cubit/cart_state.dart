import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

import '../../domain/entities/cart_entity.dart';

class CartState extends Equatable {
  final ViewData<List<CartItemEntity>> stateCart;
  const CartState({required this.stateCart});

  CartState copyWith({ViewData<List<CartItemEntity>>? stateCart}) {
    return CartState(stateCart: stateCart ?? this.stateCart);
  }

  @override
  List<Object?> get props => [stateCart];
}
