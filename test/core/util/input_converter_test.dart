import 'package:dartz/dartz.dart';
import 'package:flutter_seed/core/error/failures.dart';
import 'package:flutter_seed/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  test('should convert String data from input to int', () async {
    String tInput = '1';
    final result = inputConverter.stringToUnsignedInt(tInput);

    expect(result, Right(1));
  });

  test('should return a failure when the string is not an integer', () async {
    String tInput = 'abc';
    final result = inputConverter.stringToUnsignedInt(tInput);
    expect(result, Left(InvalidInputFailure()));
  });
}
