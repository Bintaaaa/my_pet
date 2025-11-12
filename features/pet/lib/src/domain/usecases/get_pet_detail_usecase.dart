import 'package:core/core.dart';
import '../entities/pet_entity.dart';
import '../repositories/pet_repository.dart';

class GetPetDetailUseCase extends UseCase<PetEntity, int> {
  final PetRepository repository;

  GetPetDetailUseCase(this.repository);

  @override
  Future<Result<PetEntity>> call(int params) {
    return repository.getPetDetail(params);
  }
}
