import 'package:dartz/dartz.dart';
import 'package:flutter_seed/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String string) {
    var value = int.tryParse(string);
    if (value == null) return Left(InvalidInputFailure());
    return Right(int.parse(string));
  }
}