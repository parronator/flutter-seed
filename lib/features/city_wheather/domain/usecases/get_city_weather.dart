import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_seed/core/error/failures.dart';
import 'package:flutter_seed/core/usecases/usecase.dart';
import 'package:flutter_seed/features/city_wheather/domain/entities/city_weather.dart';
import 'package:flutter_seed/features/city_wheather/domain/repositories/city_weather_repository.dart';
import 'package:meta/meta.dart';

class GetCityWeather implements UseCase<CityWeather, Params> {
  CityWeatherRepository repository;

  GetCityWeather(this.repository);

  @override
  Future<Either<Failure, CityWeather>> call(params) async {
    return await repository.getCityWeather(params.city);
  }
}

class Params extends Equatable {
  final String city;

  Params({@required this.city});

  @override
  List<Object> get props => [city];
}