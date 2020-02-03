import 'package:dartz/dartz.dart';
import 'package:flutter_seed/core/error/exceptions.dart';
import 'package:flutter_seed/core/error/failures.dart';
import 'package:flutter_seed/core/network/network_info.dart';
import 'package:flutter_seed/features/city_wheather/data/datasources/city_weather_remote_data_source.dart';
import 'package:flutter_seed/features/city_wheather/data/models/city_weather_model.dart';
import 'package:flutter_seed/features/city_wheather/data/repositories/city_weather_repository_impl.dart';
import 'package:flutter_seed/features/city_wheather/domain/repositories/city_weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCityWeatherRemoteDataSource extends Mock
    implements CityWeatherRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockNetworkInfo mockNetworkInfo;
  MockCityWeatherRemoteDataSource mockCityWeatherRemoteDataSource;
  CityWeatherRepository repository;

  setUp(() {
    mockCityWeatherRemoteDataSource = MockCityWeatherRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CityWeatherRepositoryImpl(
        remote: mockCityWeatherRemoteDataSource, networkInfo: mockNetworkInfo);
  });

  final tCity = 'Barcelona';
  final tCityWeatherModel = CityWeatherModel(city: tCity, temperature: 1.0);

  test('should get CityWeatherModel when calling from remote data source succesfully',
      () async {
    when(mockCityWeatherRemoteDataSource.getCityWeather(any))
        .thenAnswer((_) async => tCityWeatherModel);
    final result = await repository.getCityWeather(tCity);
    verify(mockCityWeatherRemoteDataSource.getCityWeather(tCity));
    verify(mockNetworkInfo.isConnected);
    expect(result, equals(Right(tCityWeatherModel)));
  });

  test('should get ServerFailure when calling from remote data source unsuccesfully', () async {
    when(mockCityWeatherRemoteDataSource.getCityWeather(tCity))
        .thenThrow(ServerException());
    final result = await repository.getCityWeather(tCity);
    expect(result, equals(Left(ServerFailure())));
  });

  test('should get NetworkFailure when calling from remote data source and is offline', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    final result = await repository.getCityWeather(tCity);
    verifyZeroInteractions(mockCityWeatherRemoteDataSource);
    expect(result, equals(Left(NetworkFailure())));
  });
}
