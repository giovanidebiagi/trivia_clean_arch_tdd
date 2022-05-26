import 'package:dartz/dartz.dart';
import '../errors/failures/i_failure.dart';
import '../errors/failures/invalid_input_failure.dart';

class TypeConvertingUtils {
  Either<IFailure, int> convertStringToUnsignedInt(
      {required String numberStr}) {
    try {
      final number = int.parse(numberStr);

      if (number < 0) {
        throw const FormatException();
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
    return Right(int.parse(numberStr));
  }
}
