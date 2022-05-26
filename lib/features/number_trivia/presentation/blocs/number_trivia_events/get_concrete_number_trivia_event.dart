import 'i_number_trivia_event.dart';

class GetConcreteNumberTriviaEvent implements INumberTriviaEvent {
  final String numberString;

  GetConcreteNumberTriviaEvent({required this.numberString});

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}
