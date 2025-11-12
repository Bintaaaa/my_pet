import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:core/core.dart';
import '../data/datasources/pet_remote_datasource.dart';
import '../data/datasources/pet_local_datasource.dart';
import '../data/datasources/cart_local_datasource.dart';
import '../data/repositories/cart_repository.dart';
import '../data/repositories/pet_repository_impl.dart';
import '../domain/repositories/cart_repository_impl.dart';
import '../domain/repositories/pet_repository.dart';
import '../domain/usecases/get_pets_usecase.dart';
import '../domain/usecases/get_pet_detail_usecase.dart';
import '../domain/usecases/checkout_order_usecase.dart';
import '../domain/usecases/checkout_cart_usecase.dart';

void initPetFeature(GetIt sl) {
  sl.registerLazySingleton<PetRemoteDataSource>(
        () => PetRemoteDataSourceImpl(sl<NetworkHelper>()),
  );

  final Box box = sl<Box>();

  sl.registerLazySingleton<PetLocalDataSource>(
        () => PetLocalDataSourceImpl(box),
  );

  sl.registerLazySingleton<CartLocalDataSource>(
        () => CartLocalDataSourceImpl(box),
  );

  sl.registerLazySingleton<PetRepository>(
        () => PetRepositoryImpl(
      sl<NetworkHelper>(),
      sl<PetRemoteDataSource>(),
      sl<PetLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<CartRepository>(
        () => CartRepositoryImpl(sl<CartLocalDataSource>()),
  );

  sl.registerLazySingleton(() => GetPetsUseCase(sl()));
  sl.registerLazySingleton(() => GetPetDetailUseCase(sl()));
  sl.registerLazySingleton(() => CheckoutOrderUseCase(sl()));
  sl.registerLazySingleton(() => CheckoutCartUseCase(sl(), sl()));
}
