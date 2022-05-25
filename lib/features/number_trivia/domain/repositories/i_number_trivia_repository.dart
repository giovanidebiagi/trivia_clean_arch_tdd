import 'package:dartz/dartz.dart';
import 'package:trivia_clean_arch_tdd/core/errors/failures/i_failure.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';

abstract class INumberTriviaRepository {
  Future<Either<IFailure, NumberTrivia>> getConcreteNumberTrivia(
      {required int number});
  Future<Either<IFailure, NumberTrivia>> getRandomNumberTrivia();
}
