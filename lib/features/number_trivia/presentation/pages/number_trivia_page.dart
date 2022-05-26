import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection_container.dart';
import '../blocs/number_trivia_bloc.dart';
import '../blocs/number_trivia_states/empty_number_trivia_state.dart';
import '../blocs/number_trivia_states/error_number_trivia_state.dart';
import '../blocs/number_trivia_states/i_number_trivia_state.dart';
import '../blocs/number_trivia_states/loaded_number_trivia_state.dart';
import '../blocs/number_trivia_states/loading_number_trivia_state.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_buttons_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => getIt<NumberTriviaBloc>(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  BlocBuilder<NumberTriviaBloc, INumberTriviaState>(
                    builder: (context, state) {
                      if (state is EmptyNumberTriviaState) {
                        return const MessageDisplay(
                            message: 'Start searching!');
                      } else if (state is LoadingNumberTriviaState) {
                        return const LoadingWidget();
                      } else if (state is LoadedNumberTriviaState) {
                        return TriviaDisplay(
                          numberTrivia: state.numberTrivia,
                        );
                      } else if (state is ErrorNumberTriviaState) {
                        return MessageDisplay(message: state.message);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 20),
                  const TriviaButtonsWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
