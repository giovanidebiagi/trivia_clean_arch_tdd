import 'package:flutter/material.dart';

import 'features/number_trivia/presentation/pages/number_trivia_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(primaryColor: const Color.fromRGBO(39, 118, 234, 1)),
      home: const NumberTriviaPage(),
    );
  }
}
