import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:feature_pet/src/domain/entities/pet_entity.dart';
import 'package:feature_pet/src/domain/repositories/pet_repository.dart';
import 'package:feature_pet/src/domain/usecases/get_pet_detail_usecase.dart';
import 'package:core/core.dart';

class MockPetRepository extends Mock implements PetRepository {}

void main() {
  late GetPetDetailUseCase usecase;
  late MockPetRepository mockRepository;

  setUp(() {
    mockRepository = MockPetRepository();
    usecase = GetPetDetailUseCase(mockRepository);
  });

  const tPetId = 1;
  final tPetEntity = PetEntity(
    id: tPetId,
    name: 'Doggie',
    category: 'Dogs',
    photoUrls: ['url1'],
    tags: ['tag1'],
    status: 'available',
  );

  test('should return PetEntity when repository returns ok', () async {
    when(() => mockRepository.getPetDetail(tPetId))
        .thenAnswer((_) async => Result.ok(tPetEntity));

    final result = await usecase.call(tPetId);

    expect(result.isOk, isTrue);
    expect(result.value, equals(tPetEntity));
    verify(() => mockRepository.getPetDetail(tPetId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository returns err', () async {
    final fail = Failure('Network error');
    when(() => mockRepository.getPetDetail(tPetId))
        .thenAnswer((_) async => Result.err(fail));

    final result = await usecase.call(tPetId);

    expect(result.isErr, isTrue);
    expect(result.failure.message, 'Network error');
    verify(() => mockRepository.getPetDetail(tPetId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
