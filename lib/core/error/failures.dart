import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => null;
}

class ServerFailure extends Failure {}

class NetworkFailure extends Failure {}

class InvalidInputFailure extends Failure {}
