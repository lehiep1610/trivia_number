import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_number/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an interger when the string represents an unsigned interger',
        () async {
      // arrange
      const str = '123';
      // act
      final result = inputConverter.stringToUnsignedInterger(str);
      // assert
      expect(result, const Right(123));
    });

    test('should return a failure when the string is not an interger',
        () async {
      // arrange
      const str = 'abc';
      // act
      final result = inputConverter.stringToUnsignedInterger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a failure when the string is a negative interger',
        () async {
      // arrange
      const str = '-123';
      // act
      final result = inputConverter.stringToUnsignedInterger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
