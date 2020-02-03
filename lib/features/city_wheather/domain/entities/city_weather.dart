import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CityWeather extends Equatable {
  final String city;
  final double temperature;

  CityWeather({@required this.city, @required this.temperature});

  @override
  List<Object> get props => [city, temperature];
}
