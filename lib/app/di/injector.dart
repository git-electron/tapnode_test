import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../features/home/data/database/home_database.dart';
import 'injector.config.dart';

final $ = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  $.init();
}

@module
abstract class AppModule {
  @lazySingleton
  HomeDatabase get homeDatabase => HomeDatabase();

  @lazySingleton
  Logger get logger => Logger();
}
