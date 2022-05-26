import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trivia_clean_arch_tdd/core/errors/failures/cache_failure.dart';
import 'package:trivia_clean_arch_tdd/core/errors/failures/failure_message_constants.dart';
import 'package:trivia_clean_arch_tdd/core/errors/failures/invalid_input_failure.dart';
import 'package:trivia_clean_arch_tdd/core/errors/failures/server_failure.dart';
import 'package:trivia_clean_arch_tdd/core/usecases/i_usecase.dart';
import 'package:trivia_clean_arch_tdd/core/utils/type_converting_utils.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/presentation/blocs/number_trivia_bloc.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/presentation/blocs/number_trivia_events/get_concrete_number_trivia_event.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/presentation/blocs/number_trivia_events/get_random_number_trivia_event.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/presentation/blocs/number_trivia_states/empty_number_trivia_state.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/presentation/blocs/number_trivia_states/error_number_trivia_state.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/presentation/blocs/number_trivia_states/loaded_number_trivia_state.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/presentation/blocs/number_trivia_states/loading_number_trivia_state.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockTypeConvertingUtils extends Mock implements TypeConvertingUtils {}

void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockTypeConvertingUtils mockTypeConvertingUtils;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockTypeConvertingUtils = MockTypeConvertingUtils();

    numberTriviaBloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      typeConvertingUtils: mockTypeConvertingUtils,
    );
  });

  test('should yield InitialNumberTriviaState() when bloc starts', () async {
    expect(numberTriviaBloc.initialState, isA<EmptyNumberTriviaState>());
  });

  group('GetConcreteNumberTrivia', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia =
        NumberTrivia(text: 'Test Number Trivia', number: tNumberParsed);

    void _setUpMockTypeConvertingUtilsSuccess() =>
        when(() => mockTypeConvertingUtils.convertStringToUnsignedInt(
            numberStr: tNumberString)).thenReturn(const Right(tNumberParsed));

    void _setUpMockGetConcreteNumberTriviaSuccess() =>
        when(() => mockGetConcreteNumberTrivia.call(
                params: const Params(number: tNumberParsed)))
            .thenAnswer((invocation) async => const Right(tNumberTrivia));

    Future<void>
        _awaitUntilTypeConvertingUtilsConvertStringToUnsignedIntMethodIsCalled() async =>
            await untilCalled(() =>
                mockTypeConvertingUtils.convertStringToUnsignedInt(
                    numberStr: any(named: 'numberStr')));

    Future<void> _awaitUntilGetConcreteNumberTriviaCallMethodIsCalled() async =>
        await untilCalled(() => mockGetConcreteNumberTrivia.call(
            params: const Params(number: tNumberParsed)));

    test(''' should call InputConverter to validate and convert the 
        string to an unsigned int ''', () async {
      // arrange
      _setUpMockTypeConvertingUtilsSuccess();

      // Because of null safety, we must mock one non-null answer (it could be any answer)
      _setUpMockGetConcreteNumberTriviaSuccess();

      // act
      numberTriviaBloc
          .add(GetConcreteNumberTriviaEvent(numberString: tNumberString));

      // As Streams are async, the function may take some time to complete,
      // therefore, we should await for it
      await _awaitUntilTypeConvertingUtilsConvertStringToUnsignedIntMethodIsCalled();

      // assert
      verify(() => mockTypeConvertingUtils.convertStringToUnsignedInt(
          numberStr: tNumberString));
    });

    test(
        'should return ErrorNumberTriviaState when converting was not successful',
        () async {
      // arrange
      when(
        () => mockTypeConvertingUtils.convertStringToUnsignedInt(
            numberStr: any(named: 'numberStr')),
      ).thenReturn(Left(InvalidInputFailure()));

      // assert later
      // In this case, the assert part should be BEFORE the act part,
      // because in the assert part, we are REGISTERING (expectLater) what
      // should be expected later. If we did not do this, and
      // numberTriviaBloc.add() completed before registering what's expected
      // an error would happen
      expectLater(
        numberTriviaBloc.stream,
        emits(
          const ErrorNumberTriviaState(message: INVALID_INPUT_FAILURE_MESSAGE),
        ),
      );

      // act
      numberTriviaBloc
          .add(GetConcreteNumberTriviaEvent(numberString: tNumberString));
      await _awaitUntilTypeConvertingUtilsConvertStringToUnsignedIntMethodIsCalled();
    });

    test(
        ''' should call getConcreteNumberTrivia (call method) to get concrete number
 trivia from local or remote database ''', () async {
      // arrange
      _setUpMockTypeConvertingUtilsSuccess();

      // Because of null safety, we must mock one non-null answer (it could be any answer)
      _setUpMockGetConcreteNumberTriviaSuccess();

      // act
      numberTriviaBloc
          .add(GetConcreteNumberTriviaEvent(numberString: tNumberString));

      // As Streams are async, the function may take some time to complete,
      // therefore, we should await for it
      await _awaitUntilTypeConvertingUtilsConvertStringToUnsignedIntMethodIsCalled();
      await _awaitUntilGetConcreteNumberTriviaCallMethodIsCalled();

      // assert
      verify(() => mockGetConcreteNumberTrivia(
          params: const Params(number: tNumberParsed)));
    });

    test(
        'should emit [LoadingNumberTriviaState, LoadedNumberTriviaState] when data is gotten successfully',
        () async {
      // arrange
      _setUpMockTypeConvertingUtilsSuccess();
      _setUpMockGetConcreteNumberTriviaSuccess();

      // assert later
      expectLater(
          numberTriviaBloc.stream,
          emitsInOrder([
            LoadingNumberTriviaState(),
            const LoadedNumberTriviaState(numberTrivia: tNumberTrivia),
          ]));

      // act
      numberTriviaBloc
          .add(GetConcreteNumberTriviaEvent(numberString: tNumberString));
      await _awaitUntilTypeConvertingUtilsConvertStringToUnsignedIntMethodIsCalled();
      await _awaitUntilGetConcreteNumberTriviaCallMethodIsCalled();
    });

    test(
        '''should emit [LoadingNumberTriviaState] and [ErrorNumberTriviaState] with [SERVER_FAILURE_MESSAGE]
    when [ServerFailure] occurs''', () async {
      // arrange
      _setUpMockTypeConvertingUtilsSuccess();

      when(
        () => mockGetConcreteNumberTrivia.call(
            params: const Params(number: tNumberParsed)),
      ).thenAnswer((invocation) async => Left(ServerFailure()));

      // assert
      expectLater(
          numberTriviaBloc.stream,
          emitsInOrder([
            LoadingNumberTriviaState(),
            const ErrorNumberTriviaState(message: SERVER_FAILURE_MESSAGE)
          ]));

      // act
      numberTriviaBloc
          .add(GetConcreteNumberTriviaEvent(numberString: tNumberString));

      await _awaitUntilTypeConvertingUtilsConvertStringToUnsignedIntMethodIsCalled();
      await _awaitUntilGetConcreteNumberTriviaCallMethodIsCalled();
    });

    test(
        '''should emit [LoadingNumberTriviaState] and [ErrorNumberTriviaState] with [CACHE_FAILURE_MESSAGE]
    when [CacheFailure] occurs''', () async {
      // arrange
      _setUpMockTypeConvertingUtilsSuccess();

      when(
        () => mockGetConcreteNumberTrivia.call(
            params: const Params(number: tNumberParsed)),
      ).thenAnswer((invocation) async => Left(CacheFailure()));

      // assert
      expectLater(
          numberTriviaBloc.stream,
          emitsInOrder([
            LoadingNumberTriviaState(),
            const ErrorNumberTriviaState(message: CACHE_FAILURE_MESSAGE)
          ]));

      // act
      numberTriviaBloc
          .add(GetConcreteNumberTriviaEvent(numberString: tNumberString));
      await _awaitUntilTypeConvertingUtilsConvertStringToUnsignedIntMethodIsCalled();
      await _awaitUntilGetConcreteNumberTriviaCallMethodIsCalled();
    });
  });

  group('GetRandomNumberTrivia', () {
    const tNumber = 1;
    const tNumberTrivia =
        NumberTrivia(text: 'Test Number Trivia', number: tNumber);

    void _setUpMockGetRandomNumberTriviaSuccess() =>
        when(() => mockGetRandomNumberTrivia.call(params: NoParams()))
            .thenAnswer((invocation) async => const Right(tNumberTrivia));

    Future<void> _awaitUntilGetRandomNumberTriviaCallMethodIsCalled() async =>
        await untilCalled(
            () => mockGetRandomNumberTrivia.call(params: NoParams()));

    test(
        ''' should call getRandomNumberTrivia (call method) to get concrete number
 trivia from local or remote database ''', () async {
      // arrange

      // Because of null safety, we must mock one non-null answer (it could be any answer)
      _setUpMockGetRandomNumberTriviaSuccess();

      // act
      numberTriviaBloc.add(GetRandomNumberTriviaEvent());

      // As Streams are async, the function may take some time to complete,
      // therefore, we should await for it
      await _awaitUntilGetRandomNumberTriviaCallMethodIsCalled();

      // assert
      verify(() => mockGetRandomNumberTrivia(params: NoParams()));
    });

    test(
        'should emit [LoadingNumberTriviaState, LoadedNumberTriviaState] when data is gotten successfully',
        () async {
      // arrange
      _setUpMockGetRandomNumberTriviaSuccess();

      // assert later
      expectLater(
          numberTriviaBloc.stream,
          emitsInOrder([
            LoadingNumberTriviaState(),
            const LoadedNumberTriviaState(numberTrivia: tNumberTrivia),
          ]));

      // act
      numberTriviaBloc.add(GetRandomNumberTriviaEvent());

      await _awaitUntilGetRandomNumberTriviaCallMethodIsCalled();
    });

    test(
        '''should emit [LoadingNumberTriviaState] and [ErrorNumberTriviaState] with [SERVER_FAILURE_MESSAGE]
    when [ServerFailure] occurs''', () async {
      // arrange
      when(
        () => mockGetRandomNumberTrivia.call(params: NoParams()),
      ).thenAnswer((invocation) async => Left(ServerFailure()));

      // assert
      expectLater(
          numberTriviaBloc.stream,
          emitsInOrder([
            LoadingNumberTriviaState(),
            const ErrorNumberTriviaState(message: SERVER_FAILURE_MESSAGE)
          ]));

      // act
      numberTriviaBloc.add(GetRandomNumberTriviaEvent());
      await _awaitUntilGetRandomNumberTriviaCallMethodIsCalled();
    });

    test(
        '''should emit [LoadingNumberTriviaState] and [ErrorNumberTriviaState] with [CACHE_FAILURE_MESSAGE]
    when [CacheFailure] occurs''', () async {
      // arrange
      when(
        () => mockGetRandomNumberTrivia.call(params: NoParams()),
      ).thenAnswer((invocation) async => Left(CacheFailure()));

      // assert
      expectLater(
          numberTriviaBloc.stream,
          emitsInOrder([
            LoadingNumberTriviaState(),
            const ErrorNumberTriviaState(message: CACHE_FAILURE_MESSAGE)
          ]));

      // act
      numberTriviaBloc.add(GetRandomNumberTriviaEvent());
      await _awaitUntilGetRandomNumberTriviaCallMethodIsCalled();
    });
  });
}
