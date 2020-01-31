import 'package:dartz/dartz.dart';
import 'package:flutter_seed/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String string) {
    final value = int.tryParse(string);
    if(value == null) return Left(InvalidInputFailure());
    else return Right(value);
  }
}