import 'package:dartz/dartz.dart';
import 'package:flutter_seed/features/city_wheather/domain/entities/city_weather.dart';
import 'package:flutter_seed/features/city_wheather/domain/repositories/city_weather_repository.dart';
import 'package:flutter_seed/features/city_wheather/domain/usecases/get_city_weather.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCityWeatherRepository extends Mock implements CityWeatherRepository {}

void main() {
  GetCityWeather usecase;
  MockCityWeatherRepository mockCityWeatherRepository;

  setUp(() {
      mockCityWeatherRepository = MockCityWeatherRepository();
      usecase = GetCityWeather(mockCityWeatherRepository);
  });

  final tCity = 'Barcelona';
  final tCityWeather = CityWeather(city: tCity, temperature: 1.0);

  test('should get city weather from the repository', () async {
    when(mockCityWeatherRepository.getCityWeather(any)).thenAnswer((_) async => Right(tCityWeather));

    final result = await usecase(Params(city: tCity));

    expect(result, Right(tCityWeather));

    verify(mockCityWeatherRepository.getCityWeather(tCity));
    verifyNoMoreInteractions(mockCityWeatherRepository);

  });
}