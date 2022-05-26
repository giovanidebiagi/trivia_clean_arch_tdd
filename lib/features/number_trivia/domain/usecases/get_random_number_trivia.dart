import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures/i_failure.dart';
import '../../../../core/usecases/i_usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/i_number_trivia_repository.dart';

class GetRandomNumberTrivia implements IUseCase<NumberTrivia, NoParams> {
  final INumberTriviaRepository repository;

  GetRandomNumberTrivia({required this.repository});

  @override
  Future<Either<IFailure, NumberTrivia>> call(
      {required NoParams params}) async {
    return await repository.getRandomNumberTrivia();
  }
}
