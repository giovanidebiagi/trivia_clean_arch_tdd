import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trivia_clean_arch_tdd/core/errors/exceptions/cache_exception.dart';
import 'package:trivia_clean_arch_tdd/core/errors/exceptions/server_exception.dart';
import 'package:trivia_clean_arch_tdd/core/errors/failures/cache_failure.dart';
import 'package:trivia_clean_arch_tdd/core/errors/failures/server_failure.dart';
import 'package:trivia_clean_arch_tdd/core/network/i_network_service.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/data/datasources/i_number_trivia_local_datasource.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/data/datasources/i_number_trivia_remote_datasource.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDatasource extends Mock
    implements INumberTriviaRemoteDatasource {}

class MockLocalDatasource extends Mock implements INumberTriviaLocalDatasource {
}

class MockNetworkService extends Mock implements INetworkService {}

void main() {
  late NumberTriviaRepository numberTriviaRepository;
  late MockLocalDatasource mockLocalDatasource;
  late MockRemoteDatasource mockRemoteDatasource;
  late MockNetworkService mockNetworkService;

  setUp(() {
    mockLocalDatasource = MockLocalDatasource();
    mockRemoteDatasource = MockRemoteDatasource();
    mockNetworkService = MockNetworkService();
    numberTriviaRepository = NumberTriviaRepository(
      numberTriviaRemoteDatasource: mockRemoteDatasource,
      numberTriviaLocalDatasource: mockLocalDatasource,
      networkService: mockNetworkService,
    );
  });

  const tNumber = 10;
  const tNumberTriviaModel =
      NumberTriviaModel(text: 'Test Text', number: tNumber);
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;

  group('get concrete number trivia', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkService.isConnected)
          .thenAnswer((invocation) async => true);
      when(() => mockRemoteDatasource.getConcreteNumberTrivia(any()))
          .thenAnswer((invocation) async => tNumberTriviaModel);
      when(() => mockLocalDatasource.cacheNumberTrivia(
              numberTriviaModelToCache: tNumberTriviaModel))
          .thenAnswer((invocation) async {});

      // act
      numberTriviaRepository.getConcreteNumberTrivia(number: tNumber);

      // assert
      verify(() => mockNetworkService.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkService.isConnected)
            .thenAnswer((invocation) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getConcreteNumberTrivia(any()))
            .thenAnswer((invocation) async => tNumberTriviaModel);
        when(() => mockLocalDatasource.cacheNumberTrivia(
                numberTriviaModelToCache: tNumberTriviaModel))
            .thenAnswer((invocation) async {});

        // act
        final result = await numberTriviaRepository.getConcreteNumberTrivia(
            number: tNumber);

        // assert
        verify(() => mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        expect(result, const Right(tNumberTrivia));
      });

      test(
          'should cache remote data when the call to remote source is successfull',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getConcreteNumberTrivia(any()))
            .thenAnswer((invocation) async => tNumberTriviaModel);
        when(() => mockLocalDatasource.cacheNumberTrivia(
                numberTriviaModelToCache: tNumberTriviaModel))
            .thenAnswer((invocation) async {});

        // act
        await numberTriviaRepository.getConcreteNumberTrivia(number: tNumber);

        // assert
        verify(() => mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDatasource.cacheNumberTrivia(
            numberTriviaModelToCache: tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());

        // act
        final result = await numberTriviaRepository.getConcreteNumberTrivia(
            number: tNumber);

        // assert
        verify(() => mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, Left(ServerFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkService.isConnected)
            .thenAnswer((invocation) async => false);
      });

      test('should return cached data when data is present', () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((invocation) async => tNumberTriviaModel);

        // act
        final result = await numberTriviaRepository.getConcreteNumberTrivia(
            number: tNumber);

        // assert
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDatasource);
        expect(result, const Right(tNumberTrivia));
      });

      test('should return CacheFailure when data is not present', () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await numberTriviaRepository.getConcreteNumberTrivia(
            number: tNumber);

        // assert
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDatasource);
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group('get random number trivia', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkService.isConnected)
          .thenAnswer((invocation) async => true);
      when(() => mockRemoteDatasource.getRandomNumberTrivia())
          .thenAnswer((invocation) async => tNumberTriviaModel);
      when(() => mockLocalDatasource.cacheNumberTrivia(
              numberTriviaModelToCache: tNumberTriviaModel))
          .thenAnswer((invocation) async {});

      // act
      numberTriviaRepository.getRandomNumberTrivia();

      // assert
      verify(() => mockNetworkService.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkService.isConnected)
            .thenAnswer((invocation) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((invocation) async => tNumberTriviaModel);
        when(() => mockLocalDatasource.cacheNumberTrivia(
                numberTriviaModelToCache: tNumberTriviaModel))
            .thenAnswer((invocation) async {});

        // act
        final result = await numberTriviaRepository.getRandomNumberTrivia();

        // assert
        verify(() => mockRemoteDatasource.getRandomNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });

      test(
          'should cache remote data when the call to remote source is successfull',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((invocation) async => tNumberTriviaModel);
        when(() => mockLocalDatasource.cacheNumberTrivia(
                numberTriviaModelToCache: tNumberTriviaModel))
            .thenAnswer((invocation) async {});

        // act
        await numberTriviaRepository.getRandomNumberTrivia();

        // assert
        verify(() => mockRemoteDatasource.getRandomNumberTrivia());
        verify(() => mockLocalDatasource.cacheNumberTrivia(
            numberTriviaModelToCache: tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDatasource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        // act
        final result = await numberTriviaRepository.getRandomNumberTrivia();

        // assert
        verify(() => mockRemoteDatasource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, Left(ServerFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkService.isConnected)
            .thenAnswer((invocation) async => false);
      });

      test('should return cached data when data is present', () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((invocation) async => tNumberTriviaModel);

        // act
        final result = await numberTriviaRepository.getRandomNumberTrivia();

        // assert
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDatasource);
        expect(result, const Right(tNumberTrivia));
      });

      test('should return CacheFailure when data is not present', () async {
        // arrange
        when(() => mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await numberTriviaRepository.getRandomNumberTrivia();

        // assert
        verify(() => mockLocalDatasource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDatasource);
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
