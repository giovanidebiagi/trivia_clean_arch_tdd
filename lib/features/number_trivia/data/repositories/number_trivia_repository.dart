import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions/cache_exception.dart';
import '../../../../core/errors/exceptions/server_exception.dart';
import '../../../../core/errors/failures/cache_failure.dart';
import '../../../../core/errors/failures/i_failure.dart';
import '../../../../core/errors/failures/server_failure.dart';
import '../../../../core/network/i_network_service.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/i_number_trivia_repository.dart';
import '../datasources/i_number_trivia_local_datasource.dart';
import '../datasources/i_number_trivia_remote_datasource.dart';
import '../models/number_trivia_model.dart';

typedef _TypeOfNumberTriviaFetching = Future<NumberTriviaModel> Function();

class NumberTriviaRepository implements INumberTriviaRepository {
  final INumberTriviaRemoteDatasource numberTriviaRemoteDatasource;
  final INumberTriviaLocalDatasource numberTriviaLocalDatasource;
  final INetworkService networkService;

  NumberTriviaRepository(
      {required this.numberTriviaRemoteDatasource,
      required this.numberTriviaLocalDatasource,
      required this.networkService});

  @override
  Future<Either<IFailure, NumberTrivia>> getConcreteNumberTrivia(
      {required int number}) async {
    return await _getNumberTrivia(() {
      return numberTriviaRemoteDatasource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<IFailure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getNumberTrivia(() {
      return numberTriviaRemoteDatasource.getRandomNumberTrivia();
    });
  }

  Future<Either<IFailure, NumberTrivia>> _getNumberTrivia(
      _TypeOfNumberTriviaFetching getConcreteOrRandomNumberTrivia) async {
    final connected = await networkService.isConnected;

    NumberTriviaModel numberTriviaModel;

    if (connected) {
      try {
        numberTriviaModel = await getConcreteOrRandomNumberTrivia();
        numberTriviaLocalDatasource.cacheNumberTrivia(
            numberTriviaModelToCache: numberTriviaModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        numberTriviaModel =
            await numberTriviaLocalDatasource.getLastNumberTrivia();
      } on CacheException {
        return Left(CacheFailure());
      }
    }

    return Right(numberTriviaModel);
  }
}
