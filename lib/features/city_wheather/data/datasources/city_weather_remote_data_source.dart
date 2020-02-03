import 'package:flutter_seed/features/city_wheather/data/models/city_weather_model.dart';

abstract class CityWeatherRemoteDataSource {
  Future<CityWeatherModel> getCityWeather(String city);
}
