import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions/cache_exception.dart';
import '../models/number_trivia_model.dart';
import 'i_number_trivia_local_datasource.dart';

const CACHE_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class SharedPreferencesNumberTriviaLocalDatasource
    implements INumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;

  SharedPreferencesNumberTriviaLocalDatasource(
      {required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(
      {required NumberTriviaModel numberTriviaModelToCache}) async {
    final success = await sharedPreferences.setString(
        CACHE_NUMBER_TRIVIA, json.encode(numberTriviaModelToCache.toJson()));

    if (success == false) {
      throw CacheException();
    }
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final numberTriviaAsString =
        sharedPreferences.getString(CACHE_NUMBER_TRIVIA);

    if (numberTriviaAsString == null) {
      throw CacheException();
    }

    return NumberTriviaModel.fromJson(json.decode(numberTriviaAsString));
  }
}
