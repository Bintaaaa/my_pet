import 'package:core/core.dart';
import '../repositories/pet_repository.dart';
import '../entities/pet_entity.dart';

class GetPetsUseCase extends UseCase<List<PetEntity>, String> {
  final PetRepository repository;

  GetPetsUseCase(this.repository);

  @override
  Future<Result<List<PetEntity>>> call(String status) {
    return repository.getPets(status);
  }
}
