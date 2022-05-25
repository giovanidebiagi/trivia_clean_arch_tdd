import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures/i_failure.dart';
import '../entities/number_trivia.dart';

abstract class INumberTriviaRepository {
  Future<Either<IFailure, NumberTrivia>> getConcreteNumberTrivia(
      {required int number});
  Future<Either<IFailure, NumberTrivia>> getRandomNumberTrivia();
}
