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
const String CACHE_FAILURE_MESSAGE = 'Cache failure';
const String UNEXPECTED_FAILURE = 'Unexpected failure';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required this.concrete, @required this.random, @required this.inputConverter});

  @override
  NumberTriviaState get initialState => NumberTriviaState.empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    yield* await event.when(
        getTriviaForConcreteNumberEvent: (e) => mapGetTriviaForConcreteNumber(e),
        getTriviaForRandomNumberEvent: (e) => mapGetTriviaForRandomNumber(e));
  }

  Stream<NumberTriviaState> mapGetTriviaForRandomNumber(
      GetTriviaForRandomNumberEvent e) async* {
    yield NumberTriviaState.loading();
    final result = await random(NoParams());
    yield* _eitherLoadedOrErrorState(result);
  }

  Stream<NumberTriviaState> mapGetTriviaForConcreteNumber(
      GetTriviaForConcreteNumberEvent event) async* {
    final inputEither = inputConverter.stringToUnsignedInt(event.numberString);
    yield* inputEither.fold(
      (failure) async* {
        yield NumberTriviaState.error(message: INVALID_INPUT_FAILURE_MESSAGE);
      },
      (integer) async* {
        yield NumberTriviaState.loading();
        final result = await concrete(Params(number: integer));
        yield* _eitherLoadedOrErrorState(result);
      },
    );
  }
}

Stream<NumberTriviaState> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> result) async* {
  yield result.fold(
      (failure) => NumberTriviaState.error(message: _mapFailureToMessage(failure)),
      (trivia) => NumberTriviaState.loaded(trivia: trivia));
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case InvalidInputFailure:
      return INVALID_INPUT_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    default:
      return UNEXPECTED_FAILURE;
  }
}
