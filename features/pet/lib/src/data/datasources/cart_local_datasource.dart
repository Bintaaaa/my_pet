import 'package:hive/hive.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> insertCartItem(CartItemModel item);
  Future<void> removeCartItem(int petId);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Box _box;
  CartLocalDataSourceImpl(this._box);

  static const _key = 'cart_items';

  Future<List<dynamic>> _rawList() async {
    final v = _box.get(_key);
    if (v is List) return v;
    return <dynamic>[];
  }

  @override
  Future<void> clearCart() async {
    await _box.put(_key, <dynamic>[]);
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final raw = await _rawList();
    return raw.whereType<Map>().map((m) => CartItemModel.fromJson(Map<String, dynamic>.from(m))).toList();
  }

  @override
  Future<void> insertCartItem(CartItemModel item) async {
    final list = await _rawList();
    final exists = list.whereType<Map>().any((m) {
      final pid = m['petId'];
      return pid != null && pid == item.petId;
    });
    if (!exists) {
      list.add(item.toJson());
      await _box.put(_key, list);
    }
  }

  @override
  Future<void> removeCartItem(int petId) async {
    final list = await _rawList();
    final filtered = list.whereType<Map>().where((m) {
      final pid = m['petId'];
      return pid == null || pid != petId;
    }).toList();
    await _box.put(_key, filtered);
  }
}
