import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures/i_failure.dart';

abstract class IUseCase<Type, Params> {
  Future<Either<IFailure, Type>> call({required Params params});
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
