import 'package:flutter/material.dart';
import 'app_widget.dart';
import 'package:trivia_clean_arch_tdd/core/injection_container.dart'
    as injection_container;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injection_container.init();

  runApp(const AppWidget());
}
