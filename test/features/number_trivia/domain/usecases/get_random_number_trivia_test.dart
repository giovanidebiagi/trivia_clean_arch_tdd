import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/repositories/i_number_trivia_repository.dart';
import 'package:trivia_clean_arch_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements INumberTriviaRepository {}

void main() {
  late final GetRandomNumberTrivia getRandomNumberTrivia;
  late final INumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getRandomNumberTrivia =
        GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });

  const int tNumber = 100;
  const NumberTrivia tNumberTrivia =
      NumberTrivia(number: tNumber, text: 'Any text');

  test('Should get random NumberTrivia from repository', () async {
    // arrange
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((invocation) async => const Right(tNumberTrivia));

    // act
    final result = await getRandomNumberTrivia(params: NoParams());

    // assert
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    expect(
      result,
      const Right(tNumberTrivia),
    );
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
