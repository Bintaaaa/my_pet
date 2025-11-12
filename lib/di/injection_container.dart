import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:feature_pet/src/di/pet_injection.dart' as pet_di;
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  sl.registerLazySingleton(() => AppLogger('my_pets'));
  sl.registerLazySingleton(() => NetworkHelper(baseUrl: 'https://petstore3.swagger.io/api/v3'));

  await Hive.initFlutter();
  final cartBox = await Hive.openBox('cart_box');
  sl.registerLazySingleton(() => cartBox);

  pet_di.initPetFeature(sl);
}
