import 'package:dartz/dartz.dart';
import 'package:flutter_seed/core/error/failures.dart';
import 'package:flutter_seed/core/util/input_converter.dart';
import 'package:flutter_seed/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_seed/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_seed/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_seed/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_seed/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_seed/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('should initialState be Empty', () async {
    expect(bloc.initialState, equals(Empty()));
  });

  final tNumberString = '1';
  final tNumberParsed = 1;
  final tNumberTrivia = NumberTrivia(number: tNumberParsed, text: 'Test text');

  void setUpMockInputConverterSuccess() {
    when(mockInputConverter.stringToUnsignedInt(any)).thenReturn(Right(tNumberParsed));
  }

  void setUpMockInputConverterFailure() {
    when(mockInputConverter.stringToUnsignedInt(any))
        .thenReturn(Left(InvalidInputFailure()));
  }

  void setUpMockConcreteNumberTriviaSuccess() {
    when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
  }

  void setUpMockConcreteNumberTriviaError() {
    when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
  }

  void setUpMockRandomNumberTriviaSuccess() {
    when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
  }

  void setUpMockRandomNumberTriviaError() {
    when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
  }

  group('GetTriviaForConcreteNumber', () {
    test('''should call the InputConverter to validate and convert 
        the string to an unsigned integer''', () async {
      setUpMockInputConverterSuccess();

      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInt(any));

      verify(mockInputConverter.stringToUnsignedInt(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      setUpMockInputConverterFailure();

      final expected = [
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.cast(), emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      setUpMockInputConverterSuccess();
      setUpMockConcreteNumberTriviaSuccess();
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten succesfully', () async {
      setUpMockInputConverterSuccess();
      setUpMockConcreteNumberTriviaSuccess();
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.cast(), emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should emit [Loading, Error] when data is gotten unsuccesfully', () async {
      setUpMockInputConverterSuccess();
      setUpMockConcreteNumberTriviaError();
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
      final expected = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc.cast(), emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    test('should get data from the random use case', () async {
      setUpMockRandomNumberTriviaSuccess();
      bloc.add(GetTriviaForRandomNumberEvent());
      await untilCalled(mockGetRandomNumberTrivia(any));
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten succesfully', () async {
      setUpMockRandomNumberTriviaSuccess();
      bloc.add(GetTriviaForRandomNumberEvent());
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc.cast(), emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumberEvent());
    });

    test('should emit [Loading, Error] when data is gotten unsuccesfully', () async {
      setUpMockRandomNumberTriviaError();
      bloc.add(GetTriviaForRandomNumberEvent());
      final expected = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc.cast(), emitsInOrder(expected));
      bloc.add(GetTriviaForRandomNumberEvent());
    });
  });
}
