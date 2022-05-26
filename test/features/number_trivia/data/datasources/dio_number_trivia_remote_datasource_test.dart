import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trivia_clean_arch_tdd/core/errors/exceptions/server_exception.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/data/datasources/dio_number_trivia_remote_datasource.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late DioNumberTriviaRemoteDatasource dioNumberTriviaRemoteDatasource;

  setUp(() {
    mockDio = MockDio();
    dioNumberTriviaRemoteDatasource =
        DioNumberTriviaRemoteDatasource(dio: mockDio);
  });

  final tNumberTriviaReponseJsonString = fixture('trivia.json');
  final Map<String, dynamic> tNumberTriviaReponseJson =
      json.decode(tNumberTriviaReponseJsonString);

  final NumberTriviaModel numberTrivia =
      NumberTriviaModel.fromJson(tNumberTriviaReponseJson);

  final tNumber = numberTrivia.number;

  _setUpSuccessfulNumberTriviaGetRequest({required String endpoint}) {
    when(() => mockDio.get('$REMOTE_NUMBER_TRIVIA_BASE_URL$endpoint?json'))
        .thenAnswer(
      (invocation) async {
        return Response(
          data: tNumberTriviaReponseJson,
          requestOptions: RequestOptions(
            path: REMOTE_NUMBER_TRIVIA_BASE_URL,
          ),
        );
      },
    );
  }

  group('get concrete number', () {
    test('get concrete number when Dio connection is successful', () async {
      // arrange
      _setUpSuccessfulNumberTriviaGetRequest(endpoint: tNumber.toString());

      // act
      final response = await dioNumberTriviaRemoteDatasource
          .getConcreteNumberTrivia(tNumber);

      // assert
      verify(() => mockDio.get('$REMOTE_NUMBER_TRIVIA_BASE_URL$tNumber?json'));
      expect(response, numberTrivia);
    });

    test('should throw ServerException when something goes wrong', () {
      when(
        () => mockDio.get(any()),
      ).thenThrow(DioError(requestOptions: RequestOptions(path: 'anything')));

      // act
      final call = dioNumberTriviaRemoteDatasource.getConcreteNumberTrivia;

      // assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('get random number', () {
    test('get random number when Dio connection is successful', () async {
      // arrange
      _setUpSuccessfulNumberTriviaGetRequest(endpoint: 'random');

      // act
      final response =
          await dioNumberTriviaRemoteDatasource.getRandomNumberTrivia();

      // assert
      verify(() => mockDio.get('${REMOTE_NUMBER_TRIVIA_BASE_URL}random?json'));
      expect(response, numberTrivia);
    });

    test('should throw ServerException when something goes wrong', () {
      when(
        () => mockDio.get(any()),
      ).thenThrow(DioError(requestOptions: RequestOptions(path: 'anything')));

      // act
      final call = dioNumberTriviaRemoteDatasource.getConcreteNumberTrivia;

      // assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });
}
