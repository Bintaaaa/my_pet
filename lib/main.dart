import 'package:flutter/material.dart';
import 'package:my_pets/app.dart';

import 'di/injection_container.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const MyPetsApp());
}
