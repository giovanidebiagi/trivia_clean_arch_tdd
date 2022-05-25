import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures/i_failure.dart';
import '../../../../core/usecases/i_usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/i_number_trivia_repository.dart';

class GetConcreteNumberTrivia implements IUseCase<NumberTrivia, Params> {
  final INumberTriviaRepository repository;

  GetConcreteNumberTrivia({required this.repository});

  @override
  Future<Either<IFailure, NumberTrivia>> call({required Params params}) async {
    return await repository.getConcreteNumberTrivia(number: params.number);
  }
}

class Params extends Equatable {
  @override
  List<Object?> get props => [];

  final int number;

  const Params({required this.number});
}
