import 'package:flutter_seed/core/error/exceptions.dart';
import 'package:flutter_seed/features/city_wheather/data/datasources/city_weather_remote_data_source.dart';
import 'package:flutter_seed/features/city_wheather/data/models/city_weather_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  CityWeatherRemoteDataSource dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = CityWeatherRemoteDataSourceImpl(client: mockHttpClient);
  });

  final tCity = 'Barcelona';
  final tCityWeatherModel = CityWeatherModel(city: tCity, temperature: 1.0);

  void setUpMockHttpClientSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('city_weather.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('city_weather.json'), 404));
  }

  test('should be a remote data source', () async {
    expect(dataSource, isA<CityWeatherRemoteDataSource>());
  });

  test('should return a CityWeatherModel when getting weather for a city', () async {
    setUpMockHttpClientSuccess();
    final result = await dataSource.getCityWeather(tCity);
    verify(mockHttpClient.get(
      '${CityWeatherRemoteDataSourceImpl.baseUrl}?q=$tCity&appid=${CityWeatherRemoteDataSourceImpl.appId}',
      headers: {'Content-Type': 'application/json'},
    ));
    expect(result, equals(tCityWeatherModel));
  });

  test('should throw an error when getting weather for a city is not found', () async {
    setUpMockHttpClientFailure404();
    final call = dataSource.getCityWeather;
    expect(() => call(tCity), throwsA(TypeMatcher<ServerException>()));
  });
}
