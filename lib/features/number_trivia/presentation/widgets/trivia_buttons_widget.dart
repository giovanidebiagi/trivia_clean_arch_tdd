import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/number_trivia_bloc.dart';
import '../blocs/number_trivia_events/get_concrete_number_trivia_event.dart';
import '../blocs/number_trivia_events/get_random_number_trivia_event.dart';

class TriviaButtonsWidget extends StatelessWidget {
  const TriviaButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textFieldController = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: textFieldController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<NumberTriviaBloc>(context).add(
                    GetConcreteNumberTriviaEvent(
                      numberString: textFieldController.text,
                    ),
                  );
                  textFieldController.clear();
                },
                style: ElevatedButton.styleFrom(),
                child: const Text('Search'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<NumberTriviaBloc>(context).add(
                    GetRandomNumberTriviaEvent(),
                  );
                },
                child: const Text('Get random trivia'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
