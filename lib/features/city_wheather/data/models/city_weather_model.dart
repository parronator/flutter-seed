import 'package:flutter_seed/features/city_wheather/domain/entities/city_weather.dart';
import 'package:meta/meta.dart';

class CityWeatherModel extends CityWeather {
  final String city;
  final double temperature;

  CityWeatherModel({@required this.city, @required this.temperature});

  factory CityWeatherModel.fromJson(Map<String, dynamic> json) {
    return CityWeatherModel(city: json['name'], temperature: json['main']['temp']);
  }

  Map<String, dynamic> toJson() {
    return {'city': city, 'temperature': temperature};
  }
}
