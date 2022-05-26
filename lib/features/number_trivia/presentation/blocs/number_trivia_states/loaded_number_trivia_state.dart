import 'package:equatable/equatable.dart';

import '../../../domain/entities/number_trivia.dart';
import 'i_number_trivia_state.dart';

class LoadedNumberTriviaState extends Equatable implements INumberTriviaState {
  final NumberTrivia numberTrivia;

  const LoadedNumberTriviaState({required this.numberTrivia});

  @override
  List<Object?> get props => [numberTrivia];
}
