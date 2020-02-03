import 'package:dartz/dartz.dart';
import 'package:flutter_seed/core/error/exceptions.dart';
import 'package:flutter_seed/core/error/failures.dart';
import 'package:flutter_seed/core/network/network_info.dart';
import 'package:flutter_seed/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_seed/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_seed/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_seed/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected){
      try {
        final response = await getConcreteOrRandom();
        await localDataSource.cacheNumberTrivia(response);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final response = await localDataSource.getLastNumberTrivia();
        return Right(response);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
