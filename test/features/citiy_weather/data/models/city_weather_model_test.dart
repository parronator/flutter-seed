import 'dart:convert';
import 'package:flutter_seed/features/city_wheather/data/models/city_weather_model.dart';
import 'package:flutter_seed/features/city_wheather/domain/entities/city_weather.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tCity = 'Barcelona';
  final tCityWeatherModel = CityWeatherModel(city: tCity, temperature: 1.0);

  test('should be a subclass of CityWeather', () async {
    expect(tCityWeatherModel, isA<CityWeather>());
  });

  test('should return a CityWeatherModel from json', () async {
    final Map<String, dynamic> jsonMap = json.decode(fixture('city_weather.json'));
    final result = CityWeatherModel.fromJson(jsonMap);
    expect(result, equals(tCityWeatherModel));
  });

  test('should return a json from CityWeatherModel', () async {
    final Map<String, dynamic> jsonMap = {'city': 'Barcelona', 'temperature': 1.0};
    final result = tCityWeatherModel.toJson();
    expect(result, equals(jsonMap));
  });
}