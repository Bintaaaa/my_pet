import 'package:core/core.dart';
import '../../domain/entities/pet_entity.dart';
import '../../domain/repositories/pet_repository.dart';
import '../datasources/pet_remote_datasource.dart';
import '../datasources/pet_local_datasource.dart';
import '../models/order_model.dart';

class PetRepositoryImpl extends BaseRepository implements PetRepository {
  final PetRemoteDataSource remote;
  final PetLocalDataSource local;

  PetRepositoryImpl(
      NetworkHelper networkHelper,
      this.remote,
      this.local,
      ) : super(networkHelper);

  @override
  Future<Result<List<PetEntity>>> getPets(String status) async {
    return safeApiCall(() async {
      try {
        final models = await remote.getPets(status);
        await local.cachePets(models);
        return models.map((e) => e.toEntity()).toList();
      } catch (e) {
        final cached = await local.getCachedPets();
        if (cached.isNotEmpty) {
          return cached.map((e) => e.toEntity()).toList();
        }
        rethrow;
      }
    });
  }

  @override
  Future<Result<PetEntity>> getPetDetail(int id) {
    return safeApiCall(() async {
      final model = await remote.getPetDetail(id);
      return model.toEntity();
    });
  }

  @override
  Future<Result<bool>> checkoutPet(int petId, int quantity) {
    return safeApiCall(() async {
      final order = OrderModel(
        petId: petId,
        quantity: quantity,
        shipDate: DateTime.now().toUtc(),
        status: 'approved',
        complete: true,
      );
      await remote.checkoutPet(order);
      return true;
    });
  }
}
