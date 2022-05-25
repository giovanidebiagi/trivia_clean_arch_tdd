import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_clean_arch_tdd/core/errors/exceptions/cache_exception.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/data/datasources/shared_preferences_number_trivia_local_datasource.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late SharedPreferencesNumberTriviaLocalDatasource numberTriviaLocalDatasource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();

    numberTriviaLocalDatasource = SharedPreferencesNumberTriviaLocalDatasource(
        sharedPreferences: mockSharedPreferences);
  });

  group('get cached number trivia', () {
    test(
        'should return last cached number trivia from SharedPreferences when it is present',
        () async {
      // arrange
      final String numberTriviaCachedString = fixture('trivia_cached.json');
      final NumberTrivia numberTrivia =
          NumberTriviaModel.fromJson(json.decode(numberTriviaCachedString));

      when(
        () => mockSharedPreferences.getString(any()),
      ).thenReturn(numberTriviaCachedString);

      // act
      final result = await numberTriviaLocalDatasource.getLastNumberTrivia();

      // assert
      verify(() => mockSharedPreferences.getString(CACHE_NUMBER_TRIVIA));

      expect(result, numberTrivia);
    });

    test('should throw CacheException when there is no cached value', () async {
      // arrange
      when(
        () => mockSharedPreferences.getString(any()),
      ).thenReturn(null);

      // act
      final result = numberTriviaLocalDatasource.getLastNumberTrivia;

      // assert
      expect(() => result(), throwsA(isA<CacheException>()));
    });
  });

  group('cache new number trivia', () {
    test('should cache new NumberTrivia to SharedPreferences', () async {
      // arrange
      const NumberTriviaModel tNumberTriviaModel =
          NumberTriviaModel(text: 'Test Text', number: 10);

      final String tNumberTriviaModelAsString =
          json.encode(tNumberTriviaModel.toJson());

      when(() => mockSharedPreferences.setString(
              CACHE_NUMBER_TRIVIA, tNumberTriviaModelAsString))
          .thenAnswer((invocation) async => true);

      // act
      numberTriviaLocalDatasource.cacheNumberTrivia(
          numberTriviaModelToCache: tNumberTriviaModel);

      // assert
      verify(() => mockSharedPreferences.setString(
          CACHE_NUMBER_TRIVIA, tNumberTriviaModelAsString));
    });

    test(
        'should throw CacheException when failing to cache new number trivia to Shared Preferences',
        () async {
      // arrange
      const NumberTriviaModel tNumberTriviaModel =
          NumberTriviaModel(text: 'Test Text', number: 10);

      final String tNumberTriviaModelAsString =
          json.encode(tNumberTriviaModel.toJson());

      when(() => mockSharedPreferences.setString(
              CACHE_NUMBER_TRIVIA, tNumberTriviaModelAsString))
          .thenAnswer((invocation) async => false);

      // act
      final result = numberTriviaLocalDatasource.cacheNumberTrivia;

      // assert
      expect(() => result(numberTriviaModelToCache: tNumberTriviaModel),
          throwsA(isA<CacheException>()));

      verify(() => mockSharedPreferences.setString(
          CACHE_NUMBER_TRIVIA, tNumberTriviaModelAsString));
    });
  });
}
