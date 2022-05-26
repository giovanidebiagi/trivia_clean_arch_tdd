import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_clean_arch_tdd/core/errors/failures/invalid_input_failure.dart';
import 'package:trivia_clean_arch_tdd/core/utils/type_converting_utils.dart';

void main() {
  late TypeConvertingUtils typeConvertingUtils;

  setUp(() {
    typeConvertingUtils = TypeConvertingUtils();
  });

  group('type converting utils', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () {
      // arrange
      const numberStr = '100';

      // act
      final result =
          typeConvertingUtils.convertStringToUnsignedInt(numberStr: numberStr);

      // assert
      expect(result, const Right(100));
    });

    test('should return Failure when the string does not represent an integer',
        () {
      // arrange
      const numberStr = '1.0';

      // act
      final result = typeConvertingUtils.convertStringToUnsignedInt;

      // assert
      expect(result(numberStr: numberStr), Left(InvalidInputFailure()));
    });

    test('should return Failure when the string does not represent a number',
        () {
      // arrange
      const numberStr = 'abc';

      // act
      final result = typeConvertingUtils.convertStringToUnsignedInt;

      // assert
      expect(result(numberStr: numberStr), Left(InvalidInputFailure()));
    });

    test('should return Failure when the string represents a negative integer',
        () {
      // arrange
      const numberStr = '-100';

      // act
      final result = typeConvertingUtils.convertStringToUnsignedInt;

      // assert
      expect(result(numberStr: numberStr), Left(InvalidInputFailure()));
    });
  });
}
