import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions/server_exception.dart';
import '../models/number_trivia_model.dart';
import 'i_number_trivia_remote_datasource.dart';

const REMOTE_NUMBER_TRIVIA_BASE_URL = 'http://numbersapi.com/';

class DioNumberTriviaRemoteDatasource implements INumberTriviaRemoteDatasource {
  final Dio dio;

  DioNumberTriviaRemoteDatasource({required this.dio});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    try {
      final response = await dio
          .get(REMOTE_NUMBER_TRIVIA_BASE_URL + number.toString() + '?json');

      return NumberTriviaModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    try {
      final response =
          await dio.get(REMOTE_NUMBER_TRIVIA_BASE_URL + 'random?json');

      return NumberTriviaModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }
}
