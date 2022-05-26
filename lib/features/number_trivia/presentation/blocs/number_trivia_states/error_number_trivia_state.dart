import 'package:equatable/equatable.dart';

import 'i_number_trivia_state.dart';

class ErrorNumberTriviaState extends Equatable implements INumberTriviaState {
  final String message;
  const ErrorNumberTriviaState({required this.message});

  @override
  List<Object?> get props => [message];
}
