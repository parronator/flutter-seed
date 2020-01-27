import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumberEvent(this.numberString);

  @override
  List<Object> get props => [numberString];
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {}
