import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/number_trivia/data/datasources/i_number_trivia_local_datasource.dart';
import '../features/number_trivia/data/datasources/shared_preferences_number_trivia_local_datasource.dart';
import '../features/number_trivia/data/datasources/dio_number_trivia_remote_datasource.dart';
import '../features/number_trivia/data/datasources/i_number_trivia_remote_datasource.dart';
import '../features/number_trivia/data/repositories/number_trivia_repository.dart';
import '../features/number_trivia/domain/entities/number_trivia.dart';
import '../features/number_trivia/domain/repositories/i_number_trivia_repository.dart';
import '../features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import '../features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import '../features/number_trivia/presentation/blocs/number_trivia_bloc.dart';
import 'network/i_network_service.dart';
import 'network/network_service.dart';
import 'usecases/i_usecase.dart';
import 'utils/type_converting_utils.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  //! Features
  // Datasources
  getIt.registerLazySingleton<INumberTriviaLocalDatasource>(
    () => SharedPreferencesNumberTriviaLocalDatasource(
      sharedPreferences: getIt(),
    ),
  );
  getIt.registerLazySingleton<INumberTriviaRemoteDatasource>(
    () => DioNumberTriviaRemoteDatasource(
      dio: getIt(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<INumberTriviaRepository>(
    () => NumberTriviaRepository(
      networkService: getIt(),
      numberTriviaLocalDatasource: getIt(),
      numberTriviaRemoteDatasource: getIt(),
    ),
  );

  // Usecases
  getIt.registerLazySingleton<IUseCase<NumberTrivia, Params>>(
    () => GetConcreteNumberTrivia(
      repository: getIt(),
    ),
  );
  getIt.registerLazySingleton<IUseCase<NumberTrivia, NoParams>>(
    () => GetRandomNumberTrivia(
      repository: getIt(),
    ),
  );

  // BLoCs
  getIt.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: getIt(),
      typeConvertingUtils: getIt(),
      getRandomNumberTrivia: getIt(),
    ),
  );

  //! External
  final sharedPreferencess = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferencess);

  getIt.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  getIt.registerLazySingleton<Dio>(
    () => Dio(),
  );

  //! Core
  getIt.registerLazySingleton<INetworkService>(
    () => NetworkService(
      internetConnectionChecker: getIt(),
    ),
  );
  getIt.registerLazySingleton<TypeConvertingUtils>(() => TypeConvertingUtils());
}
