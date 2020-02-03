import 'package:dartz/dartz.dart';
import 'package:flutter_seed/core/error/failures.dart';
import 'package:flutter_seed/core/error/exceptions.dart';
import 'package:flutter_seed/core/network/network_info.dart';
import 'package:flutter_seed/features/city_wheather/data/datasources/city_weather_remote_data_source.dart';
import 'package:flutter_seed/features/city_wheather/domain/entities/city_weather.dart';
import 'package:flutter_seed/features/city_wheather/domain/repositories/city_weather_repository.dart';
import 'package:meta/meta.dart';

class CityWeatherRepositoryImpl extends CityWeatherRepository {
  final CityWeatherRemoteDataSource remote;
  final NetworkInfo networkInfo;

  CityWeatherRepositoryImpl({@required this.remote, @required this.networkInfo});

  @override
  Future<Either<Failure, CityWeather>> getCityWeather(String city) async {
    if(await networkInfo.isConnected == false) return Left(NetworkFailure());
    try {
      final response = await remote.getCityWeather(city);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}