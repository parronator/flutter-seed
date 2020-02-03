import 'package:dartz/dartz.dart';
import 'package:flutter_seed/core/error/failures.dart';
import 'package:flutter_seed/features/city_wheather/domain/entities/city_weather.dart';

abstract class CityWeatherRepository {
  Future<Either<Failure, CityWeather>> getCityWeather(String city);
}
