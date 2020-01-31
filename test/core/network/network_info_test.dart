import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_seed/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });
  test('should forward the call to DataConnectionChecker.hascConnection', () async {
    final tHasConnectionFuture = Future.value(true);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);

    final result = networkInfoImpl.isConnected;

    expect(result, tHasConnectionFuture);
    verify(mockDataConnectionChecker.hasConnection);
  });
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
