import 'dart:convert';
import 'package:flutter_seed/core/error/exceptions.dart';
import 'package:flutter_seed/features/city_wheather/data/models/city_weather_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class CityWeatherRemoteDataSource {
  Future<CityWeatherModel> getCityWeather(String city);
}

class CityWeatherRemoteDataSourceImpl extends CityWeatherRemoteDataSource {
  final http.Client client;
  static const baseUrl = 'https://samples.openweathermap.org/data/2.5/weather';
  static const appId = 'b6907d289e10d714a6e88b30761fae22';

  CityWeatherRemoteDataSourceImpl({@required this.client});

  @override
  Future<CityWeatherModel> getCityWeather(String city) async {
    final response = await client.get('$baseUrl?q=$city&appid=$appId',
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) throw ServerException();
    return CityWeatherModel.fromJson(json.decode(response.body));
  }
}
