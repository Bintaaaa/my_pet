import '../entities/pet_entity.dart';
import 'package:core/core.dart';

abstract class PetRepository {
  Future<Result<List<PetEntity>>> getPets(String status);
  Future<Result<PetEntity>> getPetDetail(int id);
  Future<Result<bool>> checkoutPet(int petId, int quantity);
}
