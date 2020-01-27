import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_seed/core/error/failures.dart';
import 'package:flutter_seed/core/util/input_converter.dart';
import 'package:flutter_seed/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_seed/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_seed/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';
const String SERVER_FAILURE_MESSAGE = 'Server failure';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required this.concrete, @required this.random, @required this.inputConverter});

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumberEvent) {
      final inputEither = inputConverter.stringToUnsignedInt(event.numberString);
      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield Loading();
          final result = await concrete(Params(number: integer));
          yield* _eitherLoadedOrErrorState(result);
        },
      );
    }
    if (event is GetTriviaForRandomNumberEvent) {
      yield Loading();
      final result = await random(NoParams());
      yield* _eitherLoadedOrErrorState(result);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(Either<Failure, NumberTrivia> result) async* {
     yield result.fold((failure) => Error(message: SERVER_FAILURE_MESSAGE),
        (trivia) => Loaded(trivia: trivia));
  }
}
