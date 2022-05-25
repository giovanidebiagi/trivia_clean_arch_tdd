import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trivia_clean_arch_tdd/core/errors/failures/i_failure.dart';
import 'package:trivia_clean_arch_tdd/core/usecases/i_usecase.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/repositories/i_number_trivia_repository.dart';

class GetRandomNumberTrivia implements IUseCase<NumberTrivia, NoParams> {
  final INumberTriviaRepository repository;

  GetRandomNumberTrivia({required this.repository});

  @override
  Future<Either<IFailure, NumberTrivia>> call(
      {required NoParams params}) async {
    return await repository.getRandomNumberTrivia();
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
