import '../models/number_trivia_model.dart';

abstract class INumberTriviaLocalDatasource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(
      {required NumberTriviaModel numberTriviaModelToCache});
}
