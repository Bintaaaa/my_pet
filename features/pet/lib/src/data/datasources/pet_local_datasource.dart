import 'package:hive/hive.dart';
import '../models/pet_model.dart';

abstract class PetLocalDataSource {
  Future<void> cachePets(List<PetModel> pets);
  Future<List<PetModel>> getCachedPets();
}

class PetLocalDataSourceImpl implements PetLocalDataSource {
  final Box _box;
  static const _cacheKey = 'cached_pets';

  PetLocalDataSourceImpl(this._box);

  @override
  Future<void> cachePets(List<PetModel> pets) async {
    final list = pets.map((e) => e.toJson()).toList();
    await _box.put(_cacheKey, list);
  }

  @override
  Future<List<PetModel>> getCachedPets() async {
    final cached = _box.get(_cacheKey);
    if (cached is List) {
      return cached
          .whereType<Map>()
          .map((e) => PetModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }
}
