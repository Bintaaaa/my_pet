import 'package:core/core.dart';
import '../../data/datasources/cart_local_datasource.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/cart_repository.dart';
import '../entities/cart_entity.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource local;
  CartRepositoryImpl(this.local);

  @override
  Future<Result<void>> addToCart(CartItemEntity item) async {
    try {
      await local.insertCartItem(CartItemModel.fromEntity(item));
      return const Result.ok(null);
    } catch (e) {
      return Result.err(Failure(e.toString()));
    }
  }

  @override
  Future<Result<void>> clearCart() async {
    try {
      await local.clearCart();
      return const Result.ok(null);
    } catch (e) {
      return Result.err(Failure(e.toString()));
    }
  }

  @override
  Future<Result<List<CartItemEntity>>> getCart() async {
    try {
      final items = await local.getCartItems();
      return Result.ok(items.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.err(Failure(e.toString()));
    }
  }

  @override
  Future<Result<void>> removeFromCart(int petId) async {
    try {
      await local.removeCartItem(petId);
      return const Result.ok(null);
    } catch (e) {
      return Result.err(Failure(e.toString()));
    }
  }
}
