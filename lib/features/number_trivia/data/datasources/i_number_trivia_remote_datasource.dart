import '../models/number_trivia_model.dart';

abstract class INumberTriviaRemoteDatasource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerExecption] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerExecption] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
