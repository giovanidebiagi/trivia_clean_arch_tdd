import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/repositories/i_number_trivia_repository.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements INumberTriviaRepository {}

void main() {
  late final GetConcreteNumberTrivia getConcreteNumberTrivia;
  late final INumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getConcreteNumberTrivia =
        GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });

  const int tNumber = 100;
  const NumberTrivia tNumberTrivia =
      NumberTrivia(number: tNumber, text: 'Any text');

  test('Should call NumberTriviaRepository getConcreteNumberTrivia() method',
      () async {
    // arrange
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(
            number: any(named: 'number')))
        .thenAnswer((invocation) async => const Right(tNumberTrivia));

    // act
    final result =
        await getConcreteNumberTrivia(params: const Params(number: tNumber));

    // assert
    verify(() =>
        mockNumberTriviaRepository.getConcreteNumberTrivia(number: tNumber));
    expect(
      result,
      const Right(tNumberTrivia),
    );
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
