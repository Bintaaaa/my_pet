import 'package:core/core.dart';
import '../../domain/entities/cart_entity.dart';

abstract class CartRepository {
  Future<Result<List<CartItemEntity>>> getCart();
  Future<Result<void>> addToCart(CartItemEntity item);
  Future<Result<void>> removeFromCart(int petId);
  Future<Result<void>> clearCart();
}
