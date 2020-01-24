import 'package:dartz/dartz.dart';
import 'package:flutter_seed/core/error/exceptions.dart';
import 'package:flutter_seed/core/error/failures.dart';
import 'package:flutter_seed/core/platform/network_info.dart';
import 'package:flutter_seed/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_seed/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_seed/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({this.remoteDataSource, this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    if (!await networkInfo.isConnected) return Left(ServerFailure());
    try {
      final response = await remoteDataSource.getConcreteNumberTrivia(number);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if (!await networkInfo.isConnected) return Left(ServerFailure());
    try {
      final response = await remoteDataSource.getRandomNumberTrivia();
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
