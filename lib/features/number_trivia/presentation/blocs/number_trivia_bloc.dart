import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures/cache_failure.dart';
import '../../../../core/errors/failures/failure_message_constants.dart';
import '../../../../core/errors/failures/server_failure.dart';
import '../../../../core/usecases/i_usecase.dart';
import '../../../../core/utils/type_converting_utils.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import 'number_trivia_events/get_concrete_number_trivia_event.dart';
import 'number_trivia_events/get_random_number_trivia_event.dart';
import 'number_trivia_events/i_number_trivia_event.dart';
import 'number_trivia_states/empty_number_trivia_state.dart';
import 'number_trivia_states/error_number_trivia_state.dart';
import 'number_trivia_states/i_number_trivia_state.dart';
import 'number_trivia_states/loaded_number_trivia_state.dart';
import 'number_trivia_states/loading_number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<INumberTriviaEvent, INumberTriviaState> {
  final IUseCase<NumberTrivia, Params> getConcreteNumberTrivia;
  final IUseCase<NumberTrivia, NoParams> getRandomNumberTrivia;
  final TypeConvertingUtils typeConvertingUtils;
  final INumberTriviaState initialState;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.typeConvertingUtils,
    this.initialState = const EmptyNumberTriviaState(),
  }) : super(initialState) {
    on<INumberTriviaEvent>(
      (event, emit) async {
        if (event is GetConcreteNumberTriviaEvent) {
          final parsedIntResult = typeConvertingUtils
              .convertStringToUnsignedInt(numberStr: event.numberString);

          await parsedIntResult.fold(
            (l) async {
              emit(const ErrorNumberTriviaState(
                  message: INVALID_INPUT_FAILURE_MESSAGE));
            },
            (r) async {
              emit(LoadingNumberTriviaState());

              final getConcreteNumberTriviaResult =
                  await getConcreteNumberTrivia(params: Params(number: r));

              await getConcreteNumberTriviaResult.fold(
                (l) async {
                  late final String errorMessage;

                  if (l is ServerFailure) {
                    errorMessage = SERVER_FAILURE_MESSAGE;
                  } else if (l is CacheFailure) {
                    errorMessage = CACHE_FAILURE_MESSAGE;
                  } else {
                    errorMessage = 'Unexpected Error';
                  }

                  emit(ErrorNumberTriviaState(message: errorMessage));
                },
                (r) async {
                  emit(LoadedNumberTriviaState(numberTrivia: r));
                },
              );
            },
          );
        } else if (event is GetRandomNumberTriviaEvent) {
          emit(LoadingNumberTriviaState());

          final getRandomNumberTriviaResult =
              await getRandomNumberTrivia(params: NoParams());

          getRandomNumberTriviaResult.fold(
            (l) {
              late final String errorMessage;

              if (l is ServerFailure) {
                errorMessage = SERVER_FAILURE_MESSAGE;
              } else if (l is CacheFailure) {
                errorMessage = CACHE_FAILURE_MESSAGE;
              } else {
                errorMessage = 'Unexpected Error';
              }

              emit(ErrorNumberTriviaState(message: errorMessage));
            },
            (r) {
              emit(LoadedNumberTriviaState(numberTrivia: r));
            },
          );
        }
      },
    );
  }
}
